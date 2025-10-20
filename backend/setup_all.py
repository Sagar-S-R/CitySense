"""
Complete Database Setup
Runs both schema creation and data population
"""

print("="*60)
print("CITYSENSE DATABASE SETUP")
print("="*60)

# Step 1: Setup Database Schema
print("\nStep 1: Creating database schema...")
try:
    import setup_database
    setup_database.setup_database()
except Exception as e:
    print(f"Error setting up database: {e}")
    exit(1)

# Step 2: Populate with Data
print("\n" + "="*60)
print("\nStep 2: Populating database with dummy data...")
try:
    import populate_data
    populate_data.populate_database()
except Exception as e:
    print(f"Error populating database: {e}")
    exit(1)

print("\n" + "="*60)
print("SETUP COMPLETE!")
print("="*60)
print("\nYou can now:")
print("1. Start the backend: python -m uvicorn main:app --reload")
print("2. Start the frontend: npm start")
print("3. Login with test accounts (see above for credentials)")
print("="*60)
