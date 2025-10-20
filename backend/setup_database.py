"""
Database Setup Script
Creates all necessary tables for the CitySense application
"""

import psycopg2
from app.core.config import settings

def setup_database():
    """Create all database tables"""
    
    # Connect to database
    conn = psycopg2.connect(
        host=settings.DB_HOST,
        database=settings.DB_NAME,
        user=settings.DB_USER,
        password=settings.DB_PASSWORD,
        port=settings.DB_PORT
    )
    
    cursor = conn.cursor()
    
    print("Setting up database...")
    
    # Enable pgvector extension
    print("1. Enabling pgvector extension...")
    cursor.execute("CREATE EXTENSION IF NOT EXISTS vector;")
    
    # Create Citizens table
    print("2. Creating Citizens table...")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS citizens (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            phone VARCHAR(15),
            ward_number INTEGER,
            zone VARCHAR(50),
            address TEXT,
            role VARCHAR(20) NOT NULL DEFAULT 'citizen',
            password_hash VARCHAR(255) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_login TIMESTAMP
        );
    """)
    
    # Create indexes for Citizens
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_citizens_email ON citizens(email);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_citizens_ward ON citizens(ward_number);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_citizens_zone ON citizens(zone);")
    
    # Create Complaints table
    print("3. Creating Complaints table...")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS complaints (
            id SERIAL PRIMARY KEY,
            user_id INTEGER NOT NULL REFERENCES citizens(id) ON DELETE CASCADE,
            ward_number INTEGER NOT NULL,
            category VARCHAR(100) NOT NULL,
            description TEXT NOT NULL,
            status VARCHAR(20) NOT NULL DEFAULT 'pending',
            date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            embedding VECTOR(384)
        );
    """)
    
    # Create indexes for Complaints
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_complaints_ward ON complaints(ward_number);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_complaints_status ON complaints(status);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_complaints_category ON complaints(category);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_complaints_date ON complaints(date DESC);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_complaints_user ON complaints(user_id);")
    
    # Try to create vector index (may fail if not enough data)
    try:
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_complaints_embedding ON complaints USING hnsw (embedding vector_cosine_ops);")
    except Exception as e:
        print(f"   Note: Vector index creation skipped (will be created when data is added): {e}")
    
    # Create Announcements table
    print("4. Creating Announcements table...")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS announcements (
            id SERIAL PRIMARY KEY,
            ward_number INTEGER,
            title VARCHAR(200) NOT NULL,
            body TEXT NOT NULL,
            date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            embedding VECTOR(384)
        );
    """)
    
    # Create indexes for Announcements
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_announcements_ward ON announcements(ward_number);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_announcements_date ON announcements(date DESC);")
    
    # Create Reports table (if needed)
    print("5. Creating Reports table...")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS reports (
            id SERIAL PRIMARY KEY,
            officer_id INTEGER NOT NULL REFERENCES citizens(id) ON DELETE CASCADE,
            ward_number INTEGER NOT NULL,
            report_text TEXT NOT NULL,
            date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            embedding VECTOR(384)
        );
    """)
    
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_reports_ward ON reports(ward_number);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_reports_date ON reports(date DESC);")
    
    # Commit changes
    conn.commit()
    
    print("\n✅ Database setup completed successfully!")
    print("\nCreated tables:")
    print("  - citizens")
    print("  - complaints")
    print("  - announcements")
    print("  - reports")
    
    # Verify tables
    cursor.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_type = 'BASE TABLE'
        ORDER BY table_name;
    """)
    
    tables = cursor.fetchall()
    print(f"\nTotal tables in database: {len(tables)}")
    for table in tables:
        print(f"  - {table[0]}")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    try:
        setup_database()
    except Exception as e:
        print(f"\n❌ Error setting up database: {e}")
        import traceback
        traceback.print_exc()
