# 📋 API Reference - SmartCity InsightHub

Quick reference for all backend API endpoints.

## 🔐 Authentication

### Register User
```http
POST /registerUser
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@email.com",
  "password": "password123",
  "ward": "Ward 1",
  "role": "citizen"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "user_id": 17
}
```

### Login
```http
POST /login
Content-Type: application/json

{
  "email": "john@email.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "bearer",
  "user": {
    "id": 17,
    "name": "John Doe",
    "email": "john@email.com",
    "role": "citizen",
    "ward": "Ward 1"
  }
}
```

## 📝 Complaints

### Submit Complaint
```http
POST /submitComplaint
Authorization: Bearer <token>
Content-Type: application/json

{
  "ward": "Ward 1",
  "category": "Water Supply",
  "description": "Water not coming since yesterday"
}
```

**Response:**
```json
{
  "message": "Complaint submitted successfully",
  "complaint_id": 45,
  "similar_complaints": [
    {
      "id": 12,
      "description": "Pipeline broken causing no water",
      "category": "Water Supply",
      "status": "in_progress",
      "similarity_score": 0.87
    }
  ]
}
```

### Search Complaints (AI-Powered)
```http
POST /searchComplaints
Authorization: Bearer <token>
Content-Type: application/json

{
  "query": "water problem in my area",
  "ward": "Ward 1",
  "limit": 5
}
```

**Response:**
```json
{
  "results": [
    {
      "id": 12,
      "ward": "Ward 1",
      "category": "Water Supply",
      "description": "Pipeline broken causing no water",
      "status": "in_progress",
      "date": "2025-10-13T10:30:00",
      "citizen_name": "John Doe",
      "relevance_score": 0.92
    }
  ],
  "query": "water problem in my area",
  "total_found": 3
}
```

### Get Similar Issues
```http
GET /getSimilarIssues/12
Authorization: Bearer <token>
```

**Response:**
```json
{
  "complaint_id": 12,
  "similar_issues": [
    {
      "id": 15,
      "description": "No water supply since morning",
      "category": "Water Supply",
      "status": "pending",
      "similarity_score": 0.89
    }
  ]
}
```

### Update Complaint Status (Officers only)
```http
POST /updateComplaintStatus
Authorization: Bearer <token>
Content-Type: application/json

{
  "complaint_id": 12,
  "status": "resolved"
}
```

**Response:**
```json
{
  "message": "Status updated successfully"
}
```

## 📊 Dashboard

### Get Dashboard Data
```http
GET /getDashboardData
Authorization: Bearer <token>
```

**Citizen Response:**
```json
{
  "my_complaints_by_status": {
    "pending": 2,
    "in_progress": 1,
    "resolved": 3
  },
  "recent_complaints": [...]
}
```

**Officer Response:**
```json
{
  "complaints_by_status": {
    "pending": 15,
    "in_progress": 8,
    "resolved": 42
  },
  "complaints_by_category": [
    {"category": "Water Supply", "count": 12},
    {"category": "Electricity", "count": 8}
  ],
  "recent_complaints": [...]
}
```

### Get AI Summary
```http
GET /getSummary
Authorization: Bearer <token>
```

**Response:**
```json
{
  "summary": {
    "total_complaints_this_month": 45,
    "resolution_rate": 72.5,
    "top_unresolved_issues": [
      {"category": "Water Supply", "count": 8},
      {"category": "Roads", "count": 6},
      {"category": "Electricity", "count": 4}
    ]
  }
}
```

## 📢 Announcements

### Get Announcements
```http
GET /announcements?ward=Ward%201&limit=10
```

**Response:**
```json
{
  "announcements": [
    {
      "id": 1,
      "ward": "Ward 1",
      "title": "Water Supply Maintenance",
      "body": "Water supply will be disrupted...",
      "date": "2025-10-13T10:00:00"
    }
  ]
}
```

### Search Announcements (AI-Powered)
```http
POST /searchAnnouncements
Content-Type: application/json

{
  "query": "waste management updates",
  "ward": "Ward 1",
  "limit": 5
}
```

**Response:**
```json
{
  "results": [
    {
      "id": 2,
      "ward": "Ward 1",
      "title": "New Waste Collection Schedule",
      "body": "Garbage collection timings changed...",
      "date": "2025-10-10T10:00:00",
      "relevance_score": 0.94
    }
  ]
}
```

## 📄 Reports (Officers only)

### Submit Report
```http
POST /submitReport
Authorization: Bearer <token>
Content-Type: application/json

{
  "ward": "Ward 1",
  "report_text": "Completed inspection of water complaints..."
}
```

**Response:**
```json
{
  "message": "Report submitted successfully",
  "report_id": 9
}
```

## 🔧 Utility

### Health Check
```http
GET /
```

**Response:**
```json
{
  "status": "SmartCity InsightHub API is running",
  "version": "1.0"
}
```

## 🚨 Error Responses

### 401 Unauthorized
```json
{
  "detail": "Token expired"
}
```

### 403 Forbidden
```json
{
  "detail": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "detail": "Complaint not found"
}
```

### 500 Internal Server Error
```json
{
  "detail": "Database connection failed"
}
```

## 📝 Notes

### Authentication
- All protected endpoints require `Authorization: Bearer <token>` header
- Tokens expire after 24 hours
- Tokens obtained from `/login` endpoint

### Roles
- **citizen**: Can only access their own complaints
- **officer**: Can access all complaints in their ward
- **admin**: Can access all complaints city-wide

### Search Query Tips
- Use natural language: "water not working", "broken lights"
- AI understands synonyms and context
- Relevance score closer to 1.0 = more relevant

### Status Values
- `pending`: New complaint, not yet reviewed
- `in_progress`: Being worked on
- `resolved`: Issue fixed
- `rejected`: Invalid or duplicate complaint

### Category Values
- Water Supply
- Electricity
- Waste Management
- Roads
- Health
- Parks
- Traffic
- Other

## 🔍 Testing with cURL

### Login Example
```bash
curl -X POST http://localhost:8000/login \
  -H "Content-Type: application/json" \
  -d '{"email":"rajesh@email.com","password":"password123"}'
```

### Submit Complaint Example
```bash
curl -X POST http://localhost:8000/submitComplaint \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "ward": "Ward 1",
    "category": "Water Supply",
    "description": "No water since yesterday"
  }'
```

### Search Example
```bash
curl -X POST http://localhost:8000/searchComplaints \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "query": "water problem",
    "ward": "Ward 1",
    "limit": 5
  }'
```

## 📚 Interactive Documentation

Visit http://localhost:8000/docs for interactive Swagger UI documentation where you can test all endpoints directly in your browser!
