"""
Authentication Routes
Handles user registration and login
"""

from fastapi import APIRouter, HTTPException
from ..models.user import UserRegister, UserLogin, LoginResponse
from ..services.user_service import user_service

# Create router for auth endpoints
router = APIRouter(
    prefix="/auth",
    tags=["authentication"]
)

@router.post("/register")
async def register(user_data: UserRegister):
    """
    Register a new user
    
    Request Body:
        - name: Full name
        - ward: Ward name (e.g., "Jayanagar")
        - email: Email address
        - password: Password (will be hashed)
        - role: User role (citizen/officer/admin)
    
    Returns:
        Success message and user_id
    """
    try:
        result = user_service.register_user(user_data)
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/login", response_model=LoginResponse)
async def login(credentials: UserLogin):
    """
    Authenticate user and get JWT token
    
    Request Body:
        - email: User email
        - password: User password
    
    Returns:
        JWT access token and user information
    """
    try:
        result = user_service.login_user(credentials)
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
