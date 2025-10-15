"""
User Service
Business logic for user authentication and management
"""

from typing import Optional
from fastapi import HTTPException, status
from ..core.database import Database
from ..core.security import security_service
from ..models.user import UserRegister, UserLogin, UserResponse, LoginResponse

class UserService:
    """Handle user-related operations"""
    
    @staticmethod
    def register_user(user_data: UserRegister) -> dict:
        """
        Register a new user
        
        Args:
            user_data: User registration data
            
        Returns:
            Dictionary with success message and user_id
        """
        with Database.get_cursor() as cursor:
            # Check if email already exists
            cursor.execute(
                "SELECT id FROM Citizens WHERE email = %s",
                (user_data.email,)
            )
            if cursor.fetchone():
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email already registered"
                )
            
            # Hash password and insert user
            hashed_pwd = security_service.hash_password(user_data.password)
            cursor.execute(
                """
                INSERT INTO Citizens (name, ward, email, role, password_hash)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING id
                """,
                (user_data.name, user_data.ward, user_data.email, user_data.role, hashed_pwd)
            )
            user_id = cursor.fetchone()['id']
            
            return {
                "message": "User registered successfully",
                "user_id": user_id
            }
    
    @staticmethod
    def login_user(credentials: UserLogin) -> LoginResponse:
        """
        Authenticate user and return JWT token
        
        Args:
            credentials: User login credentials
            
        Returns:
            LoginResponse with token and user data
        """
        with Database.get_cursor() as cursor:
            # Fetch user by email
            cursor.execute(
                "SELECT id, name, email, role, ward, password_hash FROM Citizens WHERE email = %s",
                (credentials.email,)
            )
            db_user = cursor.fetchone()
            
            # Verify credentials
            if not db_user or not security_service.verify_password(
                credentials.password, 
                db_user['password_hash']
            ):
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid credentials"
                )
            
            # Create JWT token
            token = security_service.create_access_token({
                "user_id": db_user['id'],
                "email": db_user['email'],
                "role": db_user['role'],
                "ward": db_user['ward']
            })
            
            return LoginResponse(
                access_token=token,
                token_type="bearer",
                user=UserResponse(
                    id=db_user['id'],
                    name=db_user['name'],
                    email=db_user['email'],
                    role=db_user['role'],
                    ward=db_user['ward']
                )
            )
    
    @staticmethod
    def get_user_by_id(user_id: int) -> Optional[dict]:
        """
        Get user by ID
        
        Args:
            user_id: User ID
            
        Returns:
            User dictionary or None
        """
        with Database.get_cursor() as cursor:
            cursor.execute(
                "SELECT id, name, email, role, ward FROM Citizens WHERE id = %s",
                (user_id,)
            )
            return cursor.fetchone()

# Create user service instance
user_service = UserService()
