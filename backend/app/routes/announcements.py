"""
Announcement Routes
Handles official announcements from government
"""

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from ..core.database import Database
from ..core.security import security_service

# Create router for announcement endpoints
router = APIRouter(
    prefix="/announcements",
    tags=["announcements"]
)

class AnnouncementCreate(BaseModel):
    """Schema for creating announcements"""
    ward: Optional[int] = None  # ward_number (None for city-wide)
    title: str
    body: str

class AnnouncementResponse(BaseModel):
    """Schema for announcement response"""
    id: int
    ward: Optional[int] = None  # ward_number from database (None for city-wide)
    title: str
    body: str
    date: str

@router.get("/")
async def get_announcements(
    ward: int = None,
    limit: int = 20,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Get announcements (optionally filtered by ward)
    
    Query Parameters:
        - ward: Optional ward filter (ward number)
        - limit: Maximum number of announcements (default: 20)
    
    Returns:
        List of announcements
    
    Requires:
        JWT authentication token
    """
    try:
        with Database.get_cursor() as cursor:
            # Build query with optional ward filter
            if ward:
                cursor.execute("""
                    SELECT id, ward_number, title, body, date
                    FROM announcements
                    WHERE ward_number = %s OR ward_number IS NULL
                    ORDER BY date DESC
                    LIMIT %s
                """, (ward, limit))
            else:
                cursor.execute("""
                    SELECT id, ward_number, title, body, date
                    FROM announcements
                    ORDER BY date DESC
                    LIMIT %s
                """, (limit,))
            
            announcements = cursor.fetchall()
            
            return [
                AnnouncementResponse(
                    id=a['id'],
                    ward=a['ward_number'],
                    title=a['title'],
                    body=a['body'],
                    date=a['date'].isoformat()
                )
                for a in announcements
            ]
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


class AnnouncementSearchQuery(BaseModel):
    """Search query for announcements"""
    query: str
    ward: Optional[int] = None
    limit: int = 5


@router.post("/search")
async def search_announcements(
    search_query: AnnouncementSearchQuery,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    AI-powered semantic search across announcements
    
    Request Body:
        - query: Natural language search query
        - ward: Optional ward filter
        - limit: Maximum results (default: 5)
    
    Returns:
        Relevant announcements ranked by semantic similarity
    
    Requires:
        JWT authentication token
    """
    try:
        # Import here to avoid circular imports
        from ..services.embedding_service import embedding_service
        
        with Database.get_cursor() as cursor:
            # Generate query embedding
            query_embedding = embedding_service.get_embedding(search_query.query)
            embedding_str = embedding_service.embedding_to_postgres_string(query_embedding)
            
            # Build search query
            sql = """
                SELECT id, ward_number, title, body, date,
                       1 - (embedding <=> %s::vector) AS relevance_score
                FROM announcements
                WHERE embedding IS NOT NULL
            """
            params = [embedding_str]
            
            # Apply ward filter if specified
            if search_query.ward:
                sql += " AND (ward_number = %s OR ward_number IS NULL)"
                params.append(search_query.ward)
            
            sql += " ORDER BY relevance_score DESC LIMIT %s"
            params.append(search_query.limit)
            
            cursor.execute(sql, params)
            results = cursor.fetchall()
            
            return {
                "results": [
                    {
                        "id": r['id'],
                        "ward": r['ward_number'],
                        "title": r['title'],
                        "body": r['body'],
                        "date": r['date'].isoformat(),
                        "relevance_score": float(r['relevance_score'])
                    }
                    for r in results
                ],
                "query": search_query.query,
                "total_found": len(results)
            }
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/")
async def create_announcement(
    announcement_data: AnnouncementCreate,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Create a new announcement (Admin only)
    
    Request Body:
        - ward: Target ward or 'all' for city-wide
        - title: Announcement title
        - message: Announcement message
    
    Returns:
        Success message with announcement ID
    
    Requires:
        JWT authentication token with admin role
    """
    # Check if user is admin
    if current_user['role'] != 'admin':
        raise HTTPException(status_code=403, detail="Admin access required")
    
    try:
        with Database.get_cursor() as cursor:
            cursor.execute("""
                INSERT INTO announcements (ward_number, title, body, date)
                VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
                RETURNING id
            """, (
                announcement_data.ward,
                announcement_data.title,
                announcement_data.body
            ))
            announcement_id = cursor.fetchone()['id']
            
            return {
                "message": "Announcement created successfully",
                "announcement_id": announcement_id
            }
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
