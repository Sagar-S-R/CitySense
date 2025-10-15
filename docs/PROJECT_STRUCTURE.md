# 📁 Project Structure Overview

Complete file structure with explanations for SmartCity InsightHub.

```
CitySense/
│
├── 📂 backend/                           # Python FastAPI Backend
│   ├── main.py                          # Main API application
│   │                                    # - All API routes (login, complaints, search)
│   │                                    # - JWT authentication
│   │                                    # - SQL + Vector search queries
│   │
│   ├── embedding_service.py             # AI Embedding Generator
│   │                                    # - Loads SentenceTransformers model
│   │                                    # - Converts text → 384D vectors
│   │                                    # - Computes similarity scores
│   │
│   ├── requirements.txt                 # Python Dependencies
│   │                                    # - fastapi, uvicorn (web server)
│   │                                    # - psycopg2 (PostgreSQL)
│   │                                    # - sentence-transformers (AI)
│   │                                    # - jwt, passlib (auth)
│   │
│   └── .env.example                     # Environment Config Template
│                                        # - Database credentials
│                                        # - Secret keys
│                                        # - CORS settings
│
├── 📂 frontend/                          # React Frontend (JavaScript)
│   │
│   ├── 📂 public/
│   │   └── index.html                   # HTML entry point
│   │
│   ├── 📂 src/
│   │   │
│   │   ├── 📂 components/               # Reusable React Components
│   │   │   ├── Navbar.js               # Top navigation bar
│   │   │   ├── ComplaintForm.js        # Complaint submission form
│   │   │   ├── ComplaintList.js        # Table of complaints
│   │   │   ├── SearchBar.js            # AI search input
│   │   │   ├── AnnouncementList.js     # Announcements display
│   │   │   ├── StatsCards.js           # Dashboard statistics cards
│   │   │   └── AnalyticsChart.js       # Chart.js visualizations
│   │   │
│   │   ├── 📂 pages/                    # Full Page Components
│   │   │   ├── Login.js                # Login page
│   │   │   ├── Register.js             # Registration page
│   │   │   ├── CitizenDashboard.js     # Citizen main dashboard
│   │   │   └── OfficerDashboard.js     # Officer/Admin dashboard
│   │   │
│   │   ├── 📂 services/
│   │   │   └── api.js                  # Backend API Communication
│   │   │                               # - Axios HTTP client
│   │   │                               # - Auth services
│   │   │                               # - Complaint services
│   │   │                               # - Dashboard services
│   │   │
│   │   ├── App.js                      # Main App Component
│   │   │                               # - Routing setup
│   │   │                               # - Protected routes
│   │   │                               # - Authentication state
│   │   │
│   │   ├── index.js                    # React Entry Point
│   │   │                               # - ReactDOM.render()
│   │   │
│   │   └── index.css                   # Global Styles
│   │                                   # - TailwindCSS-inspired utilities
│   │                                   # - Custom component styles
│   │
│   └── package.json                     # Node.js Dependencies
│                                        # - react, react-dom
│                                        # - react-router-dom (routing)
│                                        # - axios (HTTP)
│                                        # - chart.js (analytics)
│
├── 📂 database/                          # Database Files
│   ├── schema.sql                       # PostgreSQL Schema
│   │                                    # - CREATE TABLE statements
│   │                                    # - Vector columns (VECTOR(384))
│   │                                    # - HNSW indexes for speed
│   │                                    # - Comments explaining AI integration
│   │
│   ├── sample_data.sql                  # Sample Data Inserts
│   │                                    # - 10 citizens (various roles)
│   │                                    # - 30 complaints (diverse categories)
│   │                                    # - 10 announcements
│   │                                    # - 8 reports
│   │                                    # - 12 services
│   │
│   └── populate_embeddings.py           # Embedding Generator Script
│                                        # - Reads all text data
│                                        # - Generates embeddings
│                                        # - Updates database
│                                        # - Run once after importing data
│
├── 📄 README.md                          # Main Documentation
│                                        # - Project overview
│                                        # - Architecture diagram
│                                        # - Setup instructions
│                                        # - Feature list
│                                        # - SQL + AI explanation
│
├── 📄 SETUP.md                           # Quick Setup Guide
│                                        # - Step-by-step installation
│                                        # - Troubleshooting
│                                        # - Verification steps
│                                        # - Getting started tips
│
├── 📄 API_REFERENCE.md                   # API Documentation
│                                        # - All endpoints
│                                        # - Request/response examples
│                                        # - cURL commands
│                                        # - Error codes
│
├── 📄 AI_EXPLAINED.md                    # AI Concepts Guide
│                                        # - What are embeddings?
│                                        # - How vector search works
│                                        # - SQL + AI integration
│                                        # - Performance considerations
│
└── 📄 .gitignore                         # Git Ignore Rules
                                         # - Python cache
                                         # - Node modules
                                         # - Environment files
                                         # - IDE files
```

---

## 🎯 Key Files to Understand

### For Backend Development

1. **`backend/main.py`** (500 lines)
   - All API routes
   - SQL queries
   - Vector search implementation
   - **Start here to understand SQL + AI**

2. **`backend/embedding_service.py`** (100 lines)
   - AI model loading
   - Text → vector conversion
   - Similarity computation
   - **Start here to understand embeddings**

### For Frontend Development

3. **`frontend/src/App.js`** (100 lines)
   - Routing configuration
   - Protected routes
   - Authentication flow
   - **Start here to understand app structure**

4. **`frontend/src/pages/CitizenDashboard.js`** (200 lines)
   - Main citizen interface
   - State management
   - API calls
   - **Start here to understand React patterns**

### For Database Understanding

5. **`database/schema.sql`** (150 lines)
   - Table definitions
   - Vector columns
   - Indexes (including HNSW)
   - **Start here to understand data model**

6. **`database/sample_data.sql`** (200 lines)
   - Realistic city data
   - Multiple categories
   - Various wards
   - **Start here to understand data scope**

---

## 📊 File Size Breakdown

```
Total Project Size: ~1.5 MB (excluding dependencies)

Backend Code:        ~600 lines
Frontend Code:      ~1500 lines
Database Scripts:    ~350 lines
Documentation:      ~2000 lines
Configuration:       ~100 lines
───────────────────────────────
Total Source:       ~4550 lines
```

---

## 🔄 Data Flow

### 1. User Submits Complaint

```
User (Browser)
    ↓ HTTP POST
Frontend (React)
    ↓ Axios
Backend (FastAPI)
    ↓ Generate Embedding
Embedding Service (SentenceTransformers)
    ↓ [0.234, -0.123, ...]
Backend
    ↓ SQL INSERT
PostgreSQL + pgvector
    ↓ Return Similar
Backend
    ↓ JSON Response
Frontend
    ↓ Display
User sees confirmation + similar complaints
```

### 2. User Searches with AI

```
User types: "water not working"
    ↓
Frontend sends query
    ↓
Backend converts to embedding
    ↓
SQL: ORDER BY embedding <=> query_embedding
    ↓
PostgreSQL returns top matches
    ↓
Frontend displays with similarity scores
```

---

## 🗂️ Component Responsibilities

### Backend Components

| File | Lines | Responsibility |
|------|-------|---------------|
| `main.py` | 500 | API routes, business logic |
| `embedding_service.py` | 100 | AI embeddings |

**Total Backend:** ~600 lines

### Frontend Components

| Component | Lines | Responsibility |
|-----------|-------|---------------|
| `App.js` | 100 | Routing, auth state |
| `Login.js` | 100 | User authentication |
| `Register.js` | 100 | User registration |
| `CitizenDashboard.js` | 200 | Citizen main view |
| `OfficerDashboard.js` | 250 | Officer main view |
| `ComplaintForm.js` | 150 | Complaint submission |
| `ComplaintList.js` | 100 | Display complaints table |
| `SearchBar.js` | 50 | AI search input |
| `Navbar.js` | 50 | Navigation bar |
| `StatsCards.js` | 80 | Statistics display |
| `AnalyticsChart.js` | 70 | Chart.js wrapper |
| `AnnouncementList.js` | 70 | Announcements display |
| `api.js` | 200 | Backend communication |

**Total Frontend:** ~1,500 lines

### Database Scripts

| File | Lines | Responsibility |
|------|-------|---------------|
| `schema.sql` | 150 | Table definitions |
| `sample_data.sql` | 200 | Sample data inserts |
| `populate_embeddings.py` | 100 | Generate embeddings |

**Total Database:** ~450 lines

---

## 🎨 Styling Approach

### CSS Architecture

```
index.css (Global Styles)
├── Reset styles
├── Utility classes (.btn, .card, .badge)
├── Layout utilities (.grid, .flex)
├── Component styles (.navbar, .form-input)
└── Responsive breakpoints (@media)
```

**Philosophy:** TailwindCSS-inspired utility classes without the build step.

---

## 🔐 Security Layers

```
┌─────────────────────┐
│   Frontend          │ ← Input validation
└──────────┬──────────┘
           │ HTTPS
┌──────────▼──────────┐
│   Backend           │ ← JWT verification
│   - Token check     │ ← Role authorization
│   - Role check      │ ← SQL injection prevention
└──────────┬──────────┘
           │
┌──────────▼──────────┐
│   Database          │ ← Encrypted at rest
│   - Constraints     │ ← Foreign keys
│   - Indexes         │ ← Data integrity
└─────────────────────┘
```

---

## 📦 Dependencies

### Backend Dependencies

```
fastapi==0.104.1              # Web framework
uvicorn==0.24.0              # ASGI server
psycopg2-binary==2.9.9       # PostgreSQL driver
python-jose==3.3.0           # JWT tokens
passlib==1.7.4               # Password hashing
sentence-transformers==2.2.2  # AI embeddings
torch==2.1.0                 # Neural network backend
```

### Frontend Dependencies

```
react==18.2.0                # UI library
react-router-dom==6.20.0     # Routing
axios==1.6.2                 # HTTP client
chart.js==4.4.0              # Charts
react-chartjs-2==5.2.0       # Chart.js React wrapper
```

---

## 🚀 Build & Deploy

### Development

```bash
# Backend
cd backend
uvicorn main:app --reload

# Frontend
cd frontend
npm start
```

### Production

```bash
# Backend
uvicorn main:app --host 0.0.0.0 --port 8000

# Frontend
npm run build
# Serve build/ folder with nginx/apache
```

---

## 📈 Scalability Considerations

### Current Setup (Good for)
- ✅ 1,000 - 10,000 complaints
- ✅ 100 - 1,000 daily users
- ✅ Single server deployment
- ✅ Ward-level queries

### To Scale Up (Changes needed)
- 📊 Add database connection pooling
- 📊 Implement caching (Redis)
- 📊 Use CDN for frontend
- 📊 Load balancer for backend
- 📊 Database replication
- 📊 Separate embedding service

---

## 🎓 Learning Path

**Week 1: Setup & Basic Understanding**
- Set up project
- Run and test features
- Read `README.md` and `SETUP.md`

**Week 2: Backend Deep Dive**
- Study `main.py`
- Understand FastAPI patterns
- Learn SQL queries
- Read `API_REFERENCE.md`

**Week 3: AI & Embeddings**
- Study `embedding_service.py`
- Understand vector math
- Experiment with similarity
- Read `AI_EXPLAINED.md`

**Week 4: Frontend & UX**
- Study React components
- Understand state management
- Learn API integration
- Customize UI

**Week 5: Database & Performance**
- Study schema design
- Understand indexes
- Optimize queries
- Test scalability

---

## 🔧 Customization Guide

### Add New Complaint Category

1. Update `database/sample_data.sql`:
   ```sql
   -- Add to categories list
   ```

2. Update `frontend/src/components/ComplaintForm.js`:
   ```javascript
   const categories = [..., 'New Category'];
   ```

### Add New User Role

1. Update `database/schema.sql`:
   ```sql
   -- Update role comment
   ```

2. Update `backend/main.py`:
   ```python
   # Add role check in get_current_user
   ```

3. Create new dashboard page in frontend

### Modify Embedding Model

1. Change model in `backend/embedding_service.py`:
   ```python
   self.model = SentenceTransformer('different-model-name')
   ```

2. Update vector dimension in `database/schema.sql`:
   ```sql
   embedding VECTOR(768)  -- if new model uses 768D
   ```

---

**Ready to explore? Start with `SETUP.md` and then dive into the code! 🚀**
