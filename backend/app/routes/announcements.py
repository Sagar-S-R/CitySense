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
