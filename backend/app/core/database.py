"""
Database Connection Management
Handles PostgreSQL connections with connection pooling
"""

import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
from .config import settings

class Database:
    """Database connection manager"""
    
    @staticmethod
    def get_connection():
        """
        Create and return a database connection
        Returns connection with RealDictCursor for dict-like row access
        """
        conn = psycopg2.connect(
            host=settings.DB_HOST,
            database=settings.DB_NAME,
            user=settings.DB_USER,
            password=settings.DB_PASSWORD,
            port=settings.DB_PORT,
            cursor_factory=RealDictCursor
        )
        return conn
    
    @staticmethod
    @contextmanager
    def get_db():
        """
        Context manager for database connections
        Automatically handles connection closing
        
        Usage:
            with Database.get_db() as conn:
                cursor = conn.cursor()
                cursor.execute("SELECT * FROM table")
        """
        conn = Database.get_connection()
        try:
            yield conn
            conn.commit()
        except Exception as e:
            conn.rollback()
            raise e
        finally:
            conn.close()
    
    @staticmethod
    @contextmanager
    def get_cursor():
        """
        Context manager for database cursor
        Automatically handles connection and cursor closing
        
        Usage:
            with Database.get_cursor() as cursor:
                cursor.execute("SELECT * FROM table")
                results = cursor.fetchall()
        """
        conn = Database.get_connection()
        cursor = conn.cursor()
        try:
            yield cursor
            conn.commit()
        except Exception as e:
            conn.rollback()
            raise e
        finally:
            cursor.close()
            conn.close()

# Create database instance
db = Database()
