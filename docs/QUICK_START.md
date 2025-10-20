# CitySense - Setup & Run Guide

## Database Setup Complete! ✅

All issues have been fixed:
- ✅ Table names updated from Capital to lowercase (Citizens → citizens, Complaints → complaints, etc.)
- ✅ Column names fixed (ward → ward_number)
- ✅ Announcements endpoint fixed (ward type changed from string to int)
- ✅ Frontend updated to handle API responses correctly
- ✅ All emojis removed from frontend for professional look

## Quick Start

### 1. Setup Database (Run Once)

```bash
cd backend
python setup_all.py
```

This will:
- Create all database tables (citizens, complaints, announcements, reports)
- Populate with realistic dummy data
- Create test user accounts

### 2. Start Backend

```bash
cd backend
python -m uvicorn main:app --reload
```

Backend will run on: http://localhost:8000

### 3. Start Frontend

```bash
cd frontend
npm start
```

Frontend will run on: http://localhost:3000

## Test Accounts

### Citizens (30 accounts)
- **Email:** citizen1@example.com to citizen30@example.com
- **Password:** password123
- **Access:** Submit complaints, view own complaints, search

### Officers (5 accounts)
- **Email:** officer1@bangalore.gov.in to officer5@bangalore.gov.in
- **Password:** officer123
- **Access:** View ward complaints, update status, analytics

### Admins (2 accounts)
- **Email:** admin1@bangalore.gov.in, admin2@bangalore.gov.in
- **Password:** admin123
- **Access:** Full system access, create announcements

## Sample Data Included

- **Citizens:** 30 users across different wards
- **Officers:** 5 officers assigned to different wards
- **Admins:** 2 admin accounts
- **Complaints:** 120 complaints with various statuses
  - Pending: ~36
  - In Progress: ~48
  - Resolved: ~36
- **Announcements:** 20 announcements (city-wide and ward-specific)
- **Reports:** 40 officer reports

## Features

### For Citizens:
- Submit new complaints
- View complaint history
- AI-powered semantic search
- Real-time status updates
- Ward-specific announcements

### For Officers:
- View ward-level complaints
- Update complaint status
- AI-generated summaries
- Analytics dashboard
- Submit reports

### For Admins:
- City-wide analytics
- Create announcements
- Full system oversight

## Troubleshooting

### Backend not starting?
- Make sure PostgreSQL is running
- Check database credentials in `.env` file
- Verify tables exist: `python check_schema.py`

### Frontend not loading data?
- Check backend is running on port 8000
- Check browser console for errors
- Verify you're logged in with valid credentials

### Database errors?
- Run `python setup_all.py` again
- Check PostgreSQL connection
- Verify pgvector extension is installed

## Database Schema

### Tables:
- **citizens** - User accounts (citizens, officers, admins)
- **complaints** - Complaint records with AI embeddings
- **announcements** - Official announcements
- **reports** - Officer-submitted reports

### Key Features:
- Vector embeddings for AI-powered semantic search
- Role-based access control
- Ward-based data filtering
- Comprehensive indexing for performance

## API Endpoints

### Authentication
- POST `/auth/register` - Register new user
- POST `/auth/login` - Login and get JWT token

### Complaints
- POST `/complaints/submit` - Submit complaint
- POST `/complaints/search` - AI semantic search
- GET `/complaints/similar/{id}` - Find similar complaints
- PUT `/complaints/update/{id}` - Update status (officer/admin)

### Dashboard
- GET `/dashboard/data` - Role-specific dashboard data
- GET `/dashboard/summary` - AI summary

### Announcements
- GET `/announcements/` - Get announcements (with ward filter)

## Notes

- All passwords are hashed using bcrypt
- JWT tokens expire after 24 hours
- AI search uses 384-dimensional embeddings
- Ward numbers range from 1-198 (Bangalore wards)

---

**Ready to use!** Login and start exploring the system.
