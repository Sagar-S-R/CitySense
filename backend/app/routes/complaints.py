"""
Complaint Routes
Handles complaint submission, search, and management
"""

from fastapi import APIRouter, Depends, HTTPException
from ..models.complaint import (
    ComplaintSubmit, 
    ComplaintSubmitResponse,
    SearchQuery, 
    ComplaintUpdate
)
from ..services.complaint_service import complaint_service
from ..core.security import security_service

# Create router for complaint endpoints
router = APIRouter(
    prefix="/complaints",
    tags=["complaints"]
)

@router.post("/submit", response_model=ComplaintSubmitResponse)
async def submit_complaint(
    complaint_data: ComplaintSubmit,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Submit a new complaint
    
    Request Body:
        - ward: Ward name
        - category: Issue category (roads/sanitation/water/electricity/other)
        - description: Detailed description
    
    Returns:
        Complaint ID and similar existing complaints (AI-powered)
    
    Requires:
        JWT authentication token
    """
    try:
        result = complaint_service.submit_complaint(
            complaint_data,
            current_user['user_id']
        )
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/search")
async def search_complaints(
    search_query: SearchQuery,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    AI-powered semantic search across complaints
    
    Request Body:
        - query: Natural language search query
        - ward: Optional ward filter
        - limit: Maximum results (default: 10)
    
    Returns:
        Relevant complaints ranked by semantic similarity
    
    Requires:
        JWT authentication token
    """
    try:
        results = complaint_service.search_complaints(
            search_query,
            current_user['role'],
            current_user['user_id'],
            current_user['ward']
        )
        return results
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/similar/{complaint_id}")
async def get_similar_issues(
    complaint_id: int,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Find complaints similar to a specific complaint
    
    Path Parameter:
        - complaint_id: ID of the complaint
    
    Returns:
        List of similar complaints (AI-powered)
    
    Requires:
        JWT authentication token
    """
    try:
        result = complaint_service.get_similar_issues(complaint_id)
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/update/{complaint_id}")
async def update_complaint_status(
    complaint_id: int,
    update_data: ComplaintUpdate,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Update complaint status (Officers and Admins only)
    
    Path Parameter:
        - complaint_id: ID of complaint to update
    
    Request Body:
        - status: New status (pending/in_progress/resolved/rejected)
    
    Returns:
        Success message
    
    Requires:
        JWT authentication token with officer or admin role
    """
    try:
        result = complaint_service.update_complaint_status(
            complaint_id,
            update_data.status,
            current_user['role'],
            current_user['ward']
        )
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
