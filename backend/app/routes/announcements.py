"""
Announcement Routes
Handles official announcements from government
"""

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from ..core.database import Database
from ..core.security import security_service

# Create router for announcement endpoints
router = APIRouter(
    prefix="/announcements",
    tags=["announcements"]
)

class AnnouncementCreate(BaseModel):
    """Schema for creating announcements"""
    ward: str
    title: str
    message: str

class AnnouncementResponse(BaseModel):
    """Schema for announcement response"""
    id: int
    ward: str
    title: str
    message: str
    date: str

@router.get("/")
async def get_announcements(
    ward: str = None,
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Get announcements (optionally filtered by ward)
    
    Query Parameters:
        - ward: Optional ward filter
    
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
                    SELECT id, ward, title, message, date
                    FROM Announcements
                    WHERE ward = %s OR ward = 'all'
                    ORDER BY date DESC
                    LIMIT 20
                """, (ward,))
            else:
                cursor.execute("""
                    SELECT id, ward, title, message, date
                    FROM Announcements
                    ORDER BY date DESC
                    LIMIT 20
                """)
            
            announcements = cursor.fetchall()
            
            return [
                AnnouncementResponse(
                    id=a['id'],
                    ward=a['ward'],
                    title=a['title'],
                    message=a['message'],
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
                INSERT INTO Announcements (ward, title, message, date)
                VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
                RETURNING id
            """, (
                announcement_data.ward,
                announcement_data.title,
                announcement_data.message
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
