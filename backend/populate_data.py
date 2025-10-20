"""
Populate Database with Realistic Dummy Data
"""

import psycopg2
from datetime import datetime, timedelta
import random
from app.core.config import settings
from app.core.security import security_service

def populate_database():
    """Populate database with realistic sample data"""
    
    conn = psycopg2.connect(
        host=settings.DB_HOST,
        database=settings.DB_NAME,
        user=settings.DB_USER,
        password=settings.DB_PASSWORD,
        port=settings.DB_PORT
    )
    
    cursor = conn.cursor()
    
    print("Populating database with dummy data...\n")
    
    # Clear existing data
    print("1. Clearing existing data...")
    cursor.execute("TRUNCATE TABLE announcements, reports, complaints, citizens RESTART IDENTITY CASCADE;")
    
    # Sample data
    wards = list(range(1, 199))  # Bangalore has 198 wards
    zones = ['East', 'West', 'South', 'North', 'Central', 'Mahadevapura', 'Bommanahalli', 'Yelahanka']
    
    categories = [
        'Roads & Infrastructure',
        'Water Supply',
        'Sanitation & Drainage',
        'Electricity',
        'Street Lights',
        'Garbage Collection',
        'Public Transport',
        'Parks & Recreation',
        'Traffic Management',
        'Others'
    ]
    
    statuses = ['pending', 'in_progress', 'resolved']
    
    # Sample citizen names
    first_names = ['Rajesh', 'Priya', 'Suresh', 'Anjali', 'Vikram', 'Kavya', 'Amit', 'Deepa', 
                   'Kiran', 'Sneha', 'Arjun', 'Divya', 'Ravi', 'Pooja', 'Sagar', 'Meera',
                   'Naveen', 'Lakshmi', 'Anil', 'Shalini', 'Ganesh', 'Asha', 'Mohan', 'Sowmya']
    
    last_names = ['Kumar', 'Rao', 'Reddy', 'Sharma', 'Nair', 'Iyer', 'Patel', 'Singh',
                  'Murthy', 'Hegde', 'Joshi', 'Desai', 'Menon', 'Varma', 'Bhat', 'Kulkarni']
    
    # 2. Create Citizens (30 citizens, 5 officers, 2 admins)
    print("2. Creating users...")
    user_ids = []
    officer_ids = []
    admin_ids = []
    
    # Regular citizens
    for i in range(30):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        email = f"citizen{i+1}@example.com"
        ward = random.choice(wards)
        zone = random.choice(zones)
        phone = f"+91 {''.join([str(random.randint(0,9)) for _ in range(10)])}"
        password_hash = security_service.hash_password("password123")
        
        cursor.execute("""
            INSERT INTO citizens (name, email, phone, ward_number, zone, role, password_hash, created_at)
            VALUES (%s, %s, %s, %s, %s, 'citizen', %s, %s)
            RETURNING id
        """, (name, email, phone, ward, zone, password_hash, datetime.now() - timedelta(days=random.randint(30, 365))))
        
        user_ids.append(cursor.fetchone()[0])
    
    # Officers
    for i in range(5):
        name = f"Officer {random.choice(first_names)} {random.choice(last_names)}"
        email = f"officer{i+1}@bangalore.gov.in"
        ward = random.choice(wards)
        zone = random.choice(zones)
        phone = f"+91 {''.join([str(random.randint(0,9)) for _ in range(10)])}"
        password_hash = security_service.hash_password("officer123")
        
        cursor.execute("""
            INSERT INTO citizens (name, email, phone, ward_number, zone, role, password_hash, created_at)
            VALUES (%s, %s, %s, %s, %s, 'officer', %s, %s)
            RETURNING id
        """, (name, email, phone, ward, zone, password_hash, datetime.now() - timedelta(days=random.randint(60, 400))))
        
        officer_ids.append(cursor.fetchone()[0])
    
    # Admins
    for i in range(2):
        name = f"Admin {random.choice(['Ramesh', 'Sudhir'])} {random.choice(last_names)}"
        email = f"admin{i+1}@bangalore.gov.in"
        ward = random.choice(wards)
        zone = random.choice(zones)
        phone = f"+91 {''.join([str(random.randint(0,9)) for _ in range(10)])}"
        password_hash = security_service.hash_password("admin123")
        
        cursor.execute("""
            INSERT INTO citizens (name, email, phone, ward_number, zone, role, password_hash, created_at)
            VALUES (%s, %s, %s, %s, %s, 'admin', %s, %s)
            RETURNING id
        """, (name, email, phone, ward, zone, password_hash, datetime.now() - timedelta(days=random.randint(100, 500))))
        
        admin_ids.append(cursor.fetchone()[0])
    
    print(f"   Created {len(user_ids)} citizens, {len(officer_ids)} officers, {len(admin_ids)} admins")
    
    # 3. Create Complaints (100+ complaints)
    print("3. Creating complaints...")
    
    complaint_descriptions = [
        "Large pothole on main road causing traffic congestion",
        "Street light not working for past week",
        "Water supply disrupted since yesterday morning",
        "Garbage not collected for 3 days",
        "Drainage overflow near residential area",
        "Road repair work incomplete and abandoned",
        "No water supply in the morning hours",
        "Streetlights remain on during daytime wasting electricity",
        "Broken sewage pipe leaking on the street",
        "Tree branches blocking road visibility",
        "Illegal parking causing traffic jam",
        "Public park gate broken and not repaired",
        "Road flooding during rain due to poor drainage",
        "Transformer making loud noise",
        "Footpath damaged and dangerous for pedestrians",
        "Bus stop shelter damaged",
        "Signal light malfunction at junction",
        "Stray dogs menace in the area",
        "Street vendor encroachment blocking footpath",
        "Public toilet not maintained properly"
    ]
    
    for i in range(120):
        user_id = random.choice(user_ids)
        ward = random.randint(1, 198)
        category = random.choice(categories)
        description = random.choice(complaint_descriptions)
        status = random.choices(statuses, weights=[30, 40, 30])[0]  # More in_progress complaints
        days_ago = random.randint(1, 90)
        
        cursor.execute("""
            INSERT INTO complaints (user_id, ward_number, category, description, status, date)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (user_id, ward, category, description, status, datetime.now() - timedelta(days=days_ago)))
    
    print(f"   Created 120 complaints")
    
    # 4. Create Announcements (20+ announcements)
    print("4. Creating announcements...")
    
    announcements = [
        ("Road Maintenance Work", "Major road repair work will be conducted on MG Road from Dec 1-15. Expect traffic diversions.", None),
        ("Water Supply Disruption", "Water supply will be disrupted on Dec 5 from 10 AM to 4 PM due to pipeline maintenance.", 25),
        ("Waste Collection Schedule Change", "Garbage collection timings changed to 6 AM - 8 AM starting next week.", None),
        ("New Park Opening", "A new children's park will be inaugurated in Ward 42 on December 10.", 42),
        ("Property Tax Deadline", "Last date to pay property tax without penalty is December 31, 2025.", None),
        ("Street Light Repair Drive", "All non-functional street lights will be repaired in the next 2 weeks.", None),
        ("Vaccination Drive", "Free vaccination camp organized at community center on December 8.", 18),
        ("Traffic Rule Awareness", "Special drive against traffic violations from December 1-10. Follow rules to avoid penalties.", None),
        ("Monsoon Preparedness", "BBMP has cleaned major drains in preparation for monsoon. Report clogged drains on our portal.", None),
        ("E-Governance Initiative", "New mobile app launched for citizen services. Download from Play Store.", None),
        ("Tree Plantation Drive", "Join us for tree plantation drive on December 15. Register at ward office.", 35),
        ("Power Outage Notice", "Scheduled power maintenance on Dec 8, 9 AM - 2 PM in selected areas.", 67),
        ("Community Hall Booking", "Community hall now available for booking online. Visit our website.", None),
        ("Road Safety Week", "Road safety week from Dec 10-17. Special sessions in schools.", None),
        ("Senior Citizen Health Camp", "Free health checkup camp for senior citizens on December 12.", None),
        ("Pothole Repair Initiative", "Report potholes through our app. Repairs within 48 hours guaranteed.", None),
        ("Public Toilet Facilities", "10 new public toilets constructed across the city.", None),
        ("Festival Traffic Advisory", "Heavy traffic expected during festival season. Use public transport.", None),
        ("Water Conservation", "Water conservation drive launched. Report water wastage on helpline.", None),
        ("Building Permit Guidelines", "New simplified guidelines for building permits now available online.", None)
    ]
    
    for title, body, ward in announcements:
        days_ago = random.randint(1, 30)
        cursor.execute("""
            INSERT INTO announcements (ward_number, title, body, date)
            VALUES (%s, %s, %s, %s)
        """, (ward, title, body, datetime.now() - timedelta(days=days_ago)))
    
    print(f"   Created {len(announcements)} announcements")
    
    # 5. Create Reports (officer reports)
    print("5. Creating officer reports...")
    
    report_texts = [
        "Completed inspection of drainage system in Ward 25. Found 3 clogged drains, cleared immediately.",
        "Road repair work in progress. Expected completion by end of week.",
        "Investigated water supply complaint. Issue identified as faulty valve. Repair scheduled.",
        "Street light repair completed for 15 lights in the ward.",
        "Garbage collection restored to normal schedule after vehicle breakdown.",
        "Traffic signal maintenance completed at 3 junctions.",
        "Tree trimming work completed as per schedule.",
        "Public park maintenance work ongoing. New benches installed.",
        "Pothole filling work completed on 5 major roads.",
        "Building violation notice served to illegal construction.",
        "Water quality testing conducted. Results within acceptable limits.",
        "Mosquito fogging drive completed in residential areas.",
        "Footpath repair work initiated on main roads.",
        "Public toilet cleaning schedule implemented.",
        "Sewage line repair completed. No further complaints expected."
    ]
    
    for i in range(40):
        officer_id = random.choice(officer_ids)
        ward = random.randint(1, 198)
        report_text = random.choice(report_texts)
        days_ago = random.randint(1, 60)
        
        cursor.execute("""
            INSERT INTO reports (officer_id, ward_number, report_text, date)
            VALUES (%s, %s, %s, %s)
        """, (officer_id, ward, report_text, datetime.now() - timedelta(days=days_ago)))
    
    print(f"   Created 40 officer reports")
    
    # Commit all changes
    conn.commit()
    
    # Print summary
    print("\n" + "="*60)
    print("DATABASE POPULATED SUCCESSFULLY!")
    print("="*60)
    
    cursor.execute("SELECT COUNT(*) FROM citizens WHERE role = 'citizen'")
    print(f"Citizens: {cursor.fetchone()[0]}")
    
    cursor.execute("SELECT COUNT(*) FROM citizens WHERE role = 'officer'")
    print(f"Officers: {cursor.fetchone()[0]}")
    
    cursor.execute("SELECT COUNT(*) FROM citizens WHERE role = 'admin'")
    print(f"Admins: {cursor.fetchone()[0]}")
    
    cursor.execute("SELECT COUNT(*) FROM complaints")
    print(f"Complaints: {cursor.fetchone()[0]}")
    
    cursor.execute("SELECT COUNT(*) FROM announcements")
    print(f"Announcements: {cursor.fetchone()[0]}")
    
    cursor.execute("SELECT COUNT(*) FROM reports")
    print(f"Reports: {cursor.fetchone()[0]}")
    
    print("\nTest Credentials:")
    print("-" * 60)
    print("Citizens: citizen1@example.com to citizen30@example.com")
    print("Officers: officer1@bangalore.gov.in to officer5@bangalore.gov.in")
    print("Admins: admin1@bangalore.gov.in, admin2@bangalore.gov.in")
    print("Password for all: password123 (citizens), officer123 (officers), admin123 (admins)")
    print("="*60)
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    try:
        populate_database()
    except Exception as e:
        print(f"\nError: {e}")
        import traceback
        traceback.print_exc()
