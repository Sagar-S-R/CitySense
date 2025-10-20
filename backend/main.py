"""
SmartCity InsightHub Backend - Main Application Entry Point
FastAPI application with clean modular architecture
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

# Import configuration and database
from app.core.config import settings
from app.core.database import Database

# Import all route modules
from app.routes import auth, complaints, dashboard, announcements

# Import embedding service for initialization check
from app.services.embedding_service import embedding_service


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan handler
    Runs on startup and shutdown
    """
    # Startup
    print("=" * 60)
    print("🚀 Starting SmartCity InsightHub Backend")
    print("=" * 60)
    
    # Test database connection
    try:
        with Database.get_connection() as conn:
            print("✅ Database connection successful")
            with conn.cursor() as cursor:
                cursor.execute("SELECT version()")
                db_version = cursor.fetchone()
                # Handle dict result from RealDictCursor
                version_str = db_version['version'] if isinstance(db_version, dict) else db_version[0]
                print(f"📊 PostgreSQL: {version_str[:50]}...")
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        raise
    
    # Verify AI model loaded
    print(f"🤖 AI Model loaded: {embedding_service.dimension}D embeddings")
    
    print("=" * 60)
    print("✅ Backend initialization complete!")
    print(f"🌐 API: http://localhost:8000")
    print(f"📖 Docs: http://localhost:8000/docs")
    print("=" * 60)
    
    yield
    
    # Shutdown
    print("\n👋 Shutting down SmartCity InsightHub Backend...")


# Create FastAPI application
app = FastAPI(
    title="SmartCity InsightHub API",
    description="""
    AI-powered citizen complaint management system with semantic search.
    
    **Features:**
    - 🔐 JWT Authentication
    - 🤖 AI-Powered Semantic Search (SentenceTransformers)
    - 📊 Real-time Dashboard Analytics
    - 🏘️ Multi-Ward Support
    - 📢 Government Announcements
    """,
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# Configure CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register all route modules
app.include_router(auth.router)
app.include_router(complaints.router)
app.include_router(dashboard.router)
app.include_router(announcements.router)


# Root endpoint
@app.get("/")
async def root():
    """API root - Health check"""
    return {
        "message": "SmartCity InsightHub API",
        "version": "1.0.0",
        "status": "running",
        "docs": "/docs",
        "features": [
            "AI-Powered Semantic Search",
            "JWT Authentication",
            "Real-time Analytics",
            "Multi-Ward Support"
        ]
    }


# Health check endpoint
@app.get("/health")
async def health_check():
    """
    Detailed health check
    Tests database connectivity
    """
    try:
        with Database.get_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1")
                cursor.fetchone()
        
        return {
            "status": "healthy",
            "database": "connected",
            "ai_model": "loaded"
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e)
        }


# Run application
if __name__ == "__main__":
    import uvicorn
    
    print("\n" + "=" * 60)
    print("🌟 SmartCity InsightHub - Starting Development Server")
    print("=" * 60 + "\n")
    
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
