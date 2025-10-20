from app.core.database import Database

conn = Database.get_connection()
cur = conn.cursor()

# Check citizens table
cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'citizens' ORDER BY ordinal_position")
print('Citizens columns:', [row[0] for row in cur.fetchall()])

# Check complaints table  
cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'complaints' ORDER BY ordinal_position")
print('Complaints columns:', [row[0] for row in cur.fetchall()])

# Check announcements table
cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'announcements' ORDER BY ordinal_position")
print('Announcements columns:', [row[0] for row in cur.fetchall()])

conn.close()
