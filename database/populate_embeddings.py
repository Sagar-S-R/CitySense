"""
Populate embeddings for existing data in database
Run this script after inserting sample data to generate embeddings
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import sys
import os

# Add parent directory to path to import embedding_service
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from backend.app.services.embedding_service import EmbeddingService

def populate_embeddings():
    """
    Generate and store embeddings for all existing text data
    This needs to be run once after importing sample data
    """
    print("Initializing embedding service...")
    embedding_service = EmbeddingService()
    
    print("Connecting to database...")
    conn = psycopg2.connect(
        host="localhost",
        database="smartcity_db",
        user="postgres",
        password="postgres",
        cursor_factory=RealDictCursor
    )
    cursor = conn.cursor()
    
    try:
        # Populate Complaints embeddings
        print("\n=== Processing Complaints ===")
        cursor.execute("SELECT id, description FROM Complaints WHERE embedding IS NULL")
        complaints = cursor.fetchall()
        print(f"Found {len(complaints)} complaints without embeddings")
        
        for i, complaint in enumerate(complaints, 1):
            embedding = embedding_service.get_embedding(complaint['description'])
            embedding_str = "[" + ",".join(map(str, embedding)) + "]"
            
            cursor.execute(
                "UPDATE Complaints SET embedding = %s::vector WHERE id = %s",
                (embedding_str, complaint['id'])
            )
            
            if i % 10 == 0:
                print(f"  Processed {i}/{len(complaints)} complaints")
        
        conn.commit()
        print(f"✓ Completed all {len(complaints)} complaints")
        
        # Populate Reports embeddings
        print("\n=== Processing Reports ===")
        cursor.execute("SELECT id, report_text FROM Reports WHERE embedding IS NULL")
        reports = cursor.fetchall()
        print(f"Found {len(reports)} reports without embeddings")
        
        for i, report in enumerate(reports, 1):
            embedding = embedding_service.get_embedding(report['report_text'])
            embedding_str = "[" + ",".join(map(str, embedding)) + "]"
            
            cursor.execute(
                "UPDATE Reports SET embedding = %s::vector WHERE id = %s",
                (embedding_str, report['id'])
            )
            print(f"  Processed {i}/{len(reports)} reports")
        
        conn.commit()
        print(f"✓ Completed all {len(reports)} reports")
        
        # Populate Announcements embeddings
        print("\n=== Processing Announcements ===")
        cursor.execute("SELECT id, title, body FROM Announcements WHERE embedding IS NULL")
        announcements = cursor.fetchall()
        print(f"Found {len(announcements)} announcements without embeddings")
        
        for i, announcement in enumerate(announcements, 1):
            # Combine title and body for richer embedding
            text = f"{announcement['title']}. {announcement['body']}"
            embedding = embedding_service.get_embedding(text)
            embedding_str = "[" + ",".join(map(str, embedding)) + "]"
            
            cursor.execute(
                "UPDATE Announcements SET embedding = %s::vector WHERE id = %s",
                (embedding_str, announcement['id'])
            )
            print(f"  Processed {i}/{len(announcements)} announcements")
        
        conn.commit()
        print(f"✓ Completed all {len(announcements)} announcements")
        
        # Populate Services embeddings
        print("\n=== Processing Services ===")
        cursor.execute("SELECT id, service_name, description FROM Services WHERE embedding IS NULL")
        services = cursor.fetchall()
        print(f"Found {len(services)} services without embeddings")
        
        for i, service in enumerate(services, 1):
            # Combine service name and description
            text = f"{service['service_name']}. {service['description']}"
            embedding = embedding_service.get_embedding(text)
            embedding_str = "[" + ",".join(map(str, embedding)) + "]"
            
            cursor.execute(
                "UPDATE Services SET embedding = %s::vector WHERE id = %s",
                (embedding_str, service['id'])
            )
            print(f"  Processed {i}/{len(services)} services")
        
        conn.commit()
        print(f"✓ Completed all {len(services)} services")
        
        print("\n" + "="*50)
        print("✓ All embeddings populated successfully!")
        print("="*50)
        
        # Verify embeddings
        print("\n=== Verification ===")
        cursor.execute("SELECT COUNT(*) as total FROM Complaints WHERE embedding IS NOT NULL")
        print(f"Complaints with embeddings: {cursor.fetchone()['total']}")
        
        cursor.execute("SELECT COUNT(*) as total FROM Reports WHERE embedding IS NOT NULL")
        print(f"Reports with embeddings: {cursor.fetchone()['total']}")
        
        cursor.execute("SELECT COUNT(*) as total FROM Announcements WHERE embedding IS NOT NULL")
        print(f"Announcements with embeddings: {cursor.fetchone()['total']}")
        
        cursor.execute("SELECT COUNT(*) as total FROM Services WHERE embedding IS NOT NULL")
        print(f"Services with embeddings: {cursor.fetchone()['total']}")
        
    except Exception as e:
        conn.rollback()
        print(f"\n✗ Error: {e}")
        raise
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    populate_embeddings()
