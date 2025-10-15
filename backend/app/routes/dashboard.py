"""
Dashboard Routes
Handles dashboard data and analytics
"""

from fastapi import APIRouter, Depends, HTTPException
from ..core.database import Database
from ..core.security import security_service

# Create router for dashboard endpoints
router = APIRouter(
    prefix="/dashboard",
    tags=["dashboard"]
)

@router.get("/data")
async def get_dashboard_data(
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Get dashboard statistics and visualizations
    
    Returns:
        - Ward-wise complaint counts
        - Status breakdown
        - Category distribution
        - Recent trends
    
    Requires:
        JWT authentication token
    
    Access:
        - Citizens: See only their ward or all public data
        - Officers: See data for their assigned ward
        - Admins: See all data across all wards
    """
    try:
        with Database.get_cursor() as cursor:
            user_role = current_user['role']
            user_ward = current_user['ward']
            
            # Build base query with role-based filtering
            ward_filter = ""
            params = []
            
            if user_role == 'officer':
                ward_filter = "WHERE ward = %s"
                params.append(user_ward)
            
            # 1. Ward-wise complaint counts
            cursor.execute(f"""
                SELECT ward, COUNT(*) as complaint_count
                FROM Complaints
                {ward_filter}
                GROUP BY ward
                ORDER BY complaint_count DESC
            """, params)
            ward_data = cursor.fetchall()
            
            # 2. Status breakdown
            cursor.execute(f"""
                SELECT status, COUNT(*) as count
                FROM Complaints
                {ward_filter}
                GROUP BY status
            """, params)
            status_data = cursor.fetchall()
            
            # 3. Category distribution
            cursor.execute(f"""
                SELECT category, COUNT(*) as count
                FROM Complaints
                {ward_filter}
                GROUP BY category
                ORDER BY count DESC
            """, params)
            category_data = cursor.fetchall()
            
            # 4. Recent trends (last 7 days)
            cursor.execute(f"""
                SELECT DATE(date) as day, COUNT(*) as count
                FROM Complaints
                {ward_filter}
                WHERE date >= CURRENT_DATE - INTERVAL '7 days'
                GROUP BY DATE(date)
                ORDER BY day ASC
            """, params)
            trend_data = cursor.fetchall()
            
            return {
                "ward_wise": [
                    {"ward": row['ward'], "count": row['complaint_count']}
                    for row in ward_data
                ],
                "status_breakdown": [
                    {"status": row['status'], "count": row['count']}
                    for row in status_data
                ],
                "category_distribution": [
                    {"category": row['category'], "count": row['count']}
                    for row in category_data
                ],
                "recent_trends": [
                    {"date": str(row['day']), "count": row['count']}
                    for row in trend_data
                ]
            }
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/summary")
async def get_summary_stats(
    current_user: dict = Depends(security_service.get_current_user)
):
    """
    Get summary statistics for quick overview
    
    Returns:
        - Total complaints
        - Pending complaints
        - Resolved complaints
        - Average resolution time
    
    Requires:
        JWT authentication token
    """
    try:
        with Database.get_cursor() as cursor:
            user_role = current_user['role']
            user_ward = current_user['ward']
            
            # Build ward filter based on role
            ward_filter = ""
            params = []
            
            if user_role == 'officer':
                ward_filter = "WHERE ward = %s"
                params.append(user_ward)
            
            # Get summary counts
            cursor.execute(f"""
                SELECT 
                    COUNT(*) as total,
                    COUNT(*) FILTER (WHERE status = 'pending') as pending,
                    COUNT(*) FILTER (WHERE status = 'resolved') as resolved,
                    COUNT(*) FILTER (WHERE status = 'in_progress') as in_progress
                FROM Complaints
                {ward_filter}
            """, params)
            summary = cursor.fetchone()
            
            return {
                "total_complaints": summary['total'],
                "pending": summary['pending'],
                "in_progress": summary['in_progress'],
                "resolved": summary['resolved']
            }
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
