"""
Complaint Service
Business logic for complaint management and AI-powered search
"""

from datetime import datetime
from typing import List, Optional
from fastapi import HTTPException, status
from ..core.database import Database
from ..models.complaint import ComplaintSubmit, ComplaintResponse, SearchQuery, ComplaintSubmitResponse
from .embedding_service import embedding_service

class ComplaintService:
    """Handle complaint-related operations"""
    
    @staticmethod
    def submit_complaint(
        complaint_data: ComplaintSubmit,
        user_id: int
    ) -> ComplaintSubmitResponse:
        """
        Submit a new complaint with AI embedding
        
        Args:
            complaint_data: Complaint submission data
            user_id: ID of user submitting complaint
            
        Returns:
            ComplaintSubmitResponse with complaint_id and similar complaints
        """
        with Database.get_cursor() as cursor:
            # Generate embedding for complaint description
            embedding = embedding_service.get_embedding(complaint_data.description)
            embedding_str = embedding_service.embedding_to_postgres_string(embedding)
            
            # Insert complaint
            cursor.execute(
                """
                INSERT INTO complaints (user_id, ward_number, category, description, status, date, embedding)
                VALUES (%s, %s, %s, %s, %s, %s, %s::vector)
                RETURNING id
                """,
                (
                    user_id,
                    complaint_data.ward,
                    complaint_data.category,
                    complaint_data.description,
                    'pending',
                    datetime.now(),
                    embedding_str
                )
            )
            complaint_id = cursor.fetchone()['id']
            
            # Find similar complaints
            similar = ComplaintService._find_similar_internal(
                cursor,
                complaint_data.description,
                complaint_data.ward,
                exclude_id=complaint_id
            )
            
            return ComplaintSubmitResponse(
                message="Complaint submitted successfully",
                complaint_id=complaint_id,
                similar_complaints=similar[:3]
            )
    
    @staticmethod
    def search_complaints(
        search_query: SearchQuery,
        user_role: str,
        user_id: int,
        user_ward: str
    ) -> dict:
        """
        AI-powered semantic search across complaints
        
        Args:
            search_query: Search query parameters
            user_role: Role of user (citizen/officer/admin)
            user_id: ID of user
            user_ward: Ward of user
            
        Returns:
            Dictionary with search results
        """
        with Database.get_cursor() as cursor:
            # Generate query embedding
            query_embedding = embedding_service.get_embedding(search_query.query)
            embedding_str = embedding_service.embedding_to_postgres_string(query_embedding)
            
            # Build search query
            sql = """
                SELECT c.id, c.ward_number, c.category, c.description, c.status, c.date,
                       u.name as citizen_name,
                       1 - (c.embedding <=> %s::vector) AS relevance_score
                FROM complaints c
                JOIN citizens u ON c.user_id = u.id
                WHERE 1=1
            """
            params = [embedding_str]
            
            # Apply ward filter if specified
            if search_query.ward:
                sql += " AND c.ward_number = %s"
                params.append(search_query.ward)
            
            # Apply role-based filtering
            if user_role == 'citizen':
                sql += " AND (c.user_id = %s OR c.status IN ('resolved', 'in_progress'))"
                params.append(user_id)
            elif user_role == 'officer':
                sql += " AND c.ward_number = %s"
                params.append(user_ward)
            
            sql += " ORDER BY relevance_score DESC LIMIT %s"
            params.append(search_query.limit)
            
            cursor.execute(sql, params)
            results = cursor.fetchall()
            
            return {
                "results": [
                    ComplaintResponse(
                        id=r['id'],
                        ward=r['ward_number'],
                        category=r['category'],
                        description=r['description'],
                        status=r['status'],
                        date=r['date'].isoformat(),
                        citizen_name=r['citizen_name'],
                        relevance_score=float(r['relevance_score'])
                    )
                    for r in results
                ],
                "query": search_query.query,
                "total_found": len(results)
            }
    
    @staticmethod
    def get_similar_issues(complaint_id: int) -> dict:
        """
        Find complaints similar to a specific complaint
        
        Args:
            complaint_id: ID of the complaint
            
        Returns:
            Dictionary with similar complaints
        """
        with Database.get_cursor() as cursor:
            # Fetch the original complaint
            cursor.execute(
                "SELECT description, ward_number FROM complaints WHERE id = %s",
                (complaint_id,)
            )
            complaint = cursor.fetchone()
            
            if not complaint:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Complaint not found"
                )
            
            # Find similar complaints
            similar = ComplaintService._find_similar_internal(
                cursor,
                complaint['description'],
                complaint['ward_number'],
                exclude_id=complaint_id
            )
            
            return {
                "complaint_id": complaint_id,
                "similar_issues": similar
            }
    
    @staticmethod
    def update_complaint_status(
        complaint_id: int,
        new_status: str,
        user_role: str,
        user_ward: str
    ) -> dict:
        """
        Update complaint status (officer/admin only)
        
        Args:
            complaint_id: ID of complaint to update
            new_status: New status value
            user_role: Role of user making update
            user_ward: Ward of user (for officers)
            
        Returns:
            Success message
        """
        if user_role not in ['officer', 'admin']:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        
        with Database.get_cursor() as cursor:
            # Verify ward access for officers
            if user_role == 'officer':
                cursor.execute(
                    "SELECT ward_number FROM complaints WHERE id = %s",
                    (complaint_id,)
                )
                complaint = cursor.fetchone()
                if not complaint or complaint['ward_number'] != user_ward:
                    raise HTTPException(
                        status_code=status.HTTP_403_FORBIDDEN,
                        detail="Access denied to this ward"
                    )
            
            # Update status
            cursor.execute(
                "UPDATE complaints SET status = %s WHERE id = %s",
                (new_status, complaint_id)
            )
            
            return {"message": "Status updated successfully"}
    
    @staticmethod
    def _find_similar_internal(
        cursor,
        query_text: str,
        ward: str,
        exclude_id: Optional[int] = None,
        limit: int = 5
    ) -> List[ComplaintResponse]:
        """
        Internal helper to find similar complaints
        
        Args:
            cursor: Database cursor
            query_text: Text to find similar complaints for
            ward: Ward to search within
            exclude_id: Optional complaint ID to exclude
            limit: Maximum number of results
            
        Returns:
            List of similar complaints
        """
        # Generate query embedding
        query_embedding = embedding_service.get_embedding(query_text)
        embedding_str = embedding_service.embedding_to_postgres_string(query_embedding)
        
        # Build similarity search query
        sql = """
            SELECT id, description, category, status, date,
                   1 - (embedding <=> %s::vector) AS similarity_score
            FROM complaints
            WHERE ward_number = %s
        """
        params = [embedding_str, ward]
        
        if exclude_id:
            sql += " AND id != %s"
            params.append(exclude_id)
        
        sql += " ORDER BY similarity_score DESC LIMIT %s"
        params.append(limit)
        
        cursor.execute(sql, params)
        results = cursor.fetchall()
        
        return [
            ComplaintResponse(
                id=r['id'],
                description=r['description'],
                category=r['category'],
                status=r['status'],
                date=r['date'].isoformat(),
                similarity_score=float(r['similarity_score'])
            )
            for r in results
        ]

# Create complaint service instance
complaint_service = ComplaintService()
