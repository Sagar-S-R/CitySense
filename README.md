# CitySense - Smart City Complaint Management System# 🏙️ SmartCity InsightHub



A modern, AI-powered complaint management system for Bangalore city using PostgreSQL with vector embeddings for intelligent search and citizen engagement.An AI-powered Smart City Dashboard that combines traditional SQL databases with semantic search capabilities using embeddings. Citizens can submit complaints, officers can manage them, and everyone benefits from intelligent natural language search powered by AI.



## Table of Contents## 🎯 Project Overview

- [Overview](#overview)

- [Prerequisites](#prerequisites)This project demonstrates **Database Management Enhanced with AI** by:

- [Complete Setup Guide](#complete-setup-guide)- Using PostgreSQL with pgvector extension for storing embeddings

- [Running the Application](#running-the-application)- Implementing semantic similarity search alongside traditional SQL queries

- [Test Accounts](#test-accounts)- Converting text to 384-dimensional vectors using SentenceTransformers (all-MiniLM-L6-v2)

- [Features](#features)- Enabling natural language queries that understand meaning, not just keywords

- [Technology Stack](#technology-stack)

- [Stopping the Application](#stopping-the-application)### The Innovation: SQL + AI

- [Troubleshooting](#troubleshooting)

**Traditional SQL:**

---```sql

SELECT * FROM Complaints WHERE description LIKE '%water%';

## Overview```

❌ Misses: "pipeline broken", "tap not working", "no supply"

CitySense is an intelligent complaint management platform that leverages:

- **AI-Powered Semantic Search** using vector embeddings**AI-Enhanced SQL:**

- **Role-Based Access Control** (Citizens, Officers, Admins)```sql

- **Real-time Analytics** and dashboardsSELECT *, 1 - (embedding <=> query_embedding) AS score

- **Natural Language Processing** for complaint similarity detectionFROM Complaints

- **PostgreSQL with pgvector** for efficient vector operationsORDER BY score DESC;

```

---✅ Finds all semantically similar complaints regardless of exact keywords



## Prerequisites## 🏗️ Architecture



Before starting, ensure you have the following installed:```

┌─────────────┐

### Required Software│   React     │  Frontend (Pure JavaScript, No TypeScript)

1. **Docker Desktop** (for PostgreSQL with pgvector)│  Frontend   │  - Citizen Dashboard

   - Download: https://www.docker.com/products/docker-desktop/│             │  - Officer Dashboard

   - Version: Latest stable release└──────┬──────┘  - AI Search Interface

       │

2. **Python 3.8+**       │ HTTP/REST

   - Download: https://www.python.org/downloads/       │

   - Verify: `python --version`┌──────▼──────┐

│   FastAPI   │  Backend (Python)

3. **Node.js 16+** and npm│   Backend   │  - JWT Authentication

   - Download: https://nodejs.org/│             │  - Complaint Management

   - Verify: `node --version` and `npm --version`└──────┬──────┘  - Embedding Generation

       │

4. **Git** (optional, for cloning)       ├─────────────────┐

   - Download: https://git-scm.com/downloads/       │                 │

┌──────▼──────┐   ┌──────▼──────────┐

---│ PostgreSQL  │   │ SentenceTransf. │

│ + pgvector  │   │  all-MiniLM-    │

## Complete Setup Guide│             │   │    L6-v2        │

└─────────────┘   └─────────────────┘

Follow these steps in order:```



### Step 1: Start PostgreSQL with pgvector (Docker)## 📊 Database Schema



Open a terminal and run:### Tables



```bash1. **Citizens** - User accounts (citizens, officers, admins)

# Pull and run PostgreSQL with pgvector extension2. **Complaints** - Citizen complaints with embeddings

docker run --name citysense-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bangalore_smartcity -p 5432:5432 -d ankane/pgvector3. **Reports** - Officer reports with embeddings

4. **Announcements** - City announcements with embeddings

# Verify container is running5. **Services** - Service catalog with embeddings

docker ps

```### Key Innovation: Vector Storage



**You should see:** A container named `citysense-db` with status "Up"Each text field is stored with its embedding:

```sql

**Important:** Keep this terminal open or Docker Desktop running in the background.CREATE TABLE Complaints (

    id SERIAL PRIMARY KEY,

---    description TEXT NOT NULL,

    embedding VECTOR(384),  -- AI magic here!

### Step 2: Clone/Navigate to Project Directory    ...

);

```bash

# If cloning from GitHub-- Vector similarity index for fast search

git clone https://github.com/Sagar-S-R/CitySense.gitCREATE INDEX idx_complaints_embedding 

cd CitySenseON Complaints USING hnsw (embedding vector_cosine_ops);

```

# Or navigate to your existing project

cd E:\Sagar\MSRIT SEM5\DBMS\CitySense## 🚀 Getting Started

```

### Prerequisites

---

- **Python 3.9+**

### Step 3: Backend Setup- **PostgreSQL 14+** with pgvector extension

- **Node.js 16+**

#### 3.1: Install Python Dependencies- **Git**



```bash### Installation

# Navigate to backend directory

cd backend#### 1. Clone Repository



# Create virtual environment (recommended)```bash

python -m venv venvgit clone <repository-url>

cd CitySense

# Activate virtual environment```

# On Windows:

venv\Scripts\activate#### 2. Setup Database

# On Mac/Linux:

source venv/bin/activateInstall PostgreSQL and pgvector:



# Install dependencies**Ubuntu/Debian:**

pip install -r requirements.txt```bash

```sudo apt-get install postgresql postgresql-contrib

git clone https://github.com/pgvector/pgvector.git

#### 3.2: Configure Environment Variablescd pgvector

make

Create a `.env` file in the `backend` directory:sudo make install

```

```bash

# backend/.env**Windows:**

DB_HOST=localhost- Download PostgreSQL from https://www.postgresql.org/download/windows/

DB_NAME=bangalore_smartcity- Follow pgvector installation guide: https://github.com/pgvector/pgvector#windows

DB_USER=postgres

DB_PASSWORD=postgresCreate database:

DB_PORT=5432```bash

psql -U postgres

SECRET_KEY=your-super-secret-key-change-this-in-productionCREATE DATABASE smartcity_db;

API_HOST=0.0.0.0\c smartcity_db

API_PORT=8000CREATE EXTENSION vector;

\q

CORS_ORIGINS=http://localhost:3000```

```

Run schema and sample data:

#### 3.3: Setup Database Schema and Data```bash

psql -U postgres -d smartcity_db -f database/schema.sql

Run the all-in-one setup script:psql -U postgres -d smartcity_db -f database/sample_data.sql

```

```bash

python setup_all.py#### 3. Setup Backend

```

```bash

**This will:**cd backend

- ✅ Create all database tables (citizens, complaints, announcements, reports)python -m venv venv

- ✅ Enable pgvector extension

- ✅ Create indexes for performance# Windows

- ✅ Populate with realistic dummy data:venv\Scripts\activate

  - 30 citizens# Linux/Mac

  - 5 officerssource venv/bin/activate

  - 2 admins

  - 120 complaintspip install -r requirements.txt

  - 20 announcements

  - 40 officer reports# Create .env file

copy .env.example .env  # Windows

**Expected Output:**# cp .env.example .env  # Linux/Mac

```

============================================================# Edit .env with your database credentials

CITYSENSE DATABASE SETUP```

============================================================

Generate embeddings for sample data:

Step 1: Creating database schema...```bash

1. Enabling pgvector extension...cd ../database

2. Creating Citizens table...python populate_embeddings.py

3. Creating Complaints table...```

...

✅ Database setup completed successfully!Start backend:

```bash

Step 2: Populating database with dummy data...cd ../backend

...uvicorn main:app --reload

============================================================```

DATABASE POPULATED SUCCESSFULLY!

============================================================Backend will run on http://localhost:8000

```

#### 4. Setup Frontend

---

```bash

### Step 4: Frontend Setupcd ../frontend

npm install

Open a **NEW terminal** (keep backend terminal open):npm start

```

```bash

# Navigate to frontend directoryFrontend will run on http://localhost:3000

cd frontend

## 👤 Demo Accounts

# Install dependencies

npm install| Role | Email | Password |

|------|-------|----------|

# This may take 2-3 minutes| Citizen | rajesh@email.com | password123 |

```| Officer | officer1@city.gov | password123 |

| Admin | admin@city.gov | password123 |

---

## 🎨 Features

## Running the Application

### For Citizens

You need **TWO terminals** running simultaneously:- ✅ Register and login

- ✅ Submit complaints with automatic AI categorization

### Terminal 1: Start Backend Server- ✅ View complaint status

- ✅ Natural language search (AI-powered)

```bash- ✅ See similar complaints automatically

cd backend- ✅ View ward announcements



# Activate virtual environment if not already active### For Officers/Admins

venv\Scripts\activate  # Windows- ✅ View ward/city-wide complaints

# source venv/bin/activate  # Mac/Linux- ✅ Update complaint status

- ✅ AI-powered summary dashboard

# Start backend server- ✅ Analytics with charts

python -m uvicorn main:app --reload- ✅ Semantic search across all complaints

```- ✅ Submit official reports



**Expected Output:**### AI Features

```- 🤖 **Semantic Search**: "water problem" finds "pipeline broken", "tap not working"

INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)- 🤖 **Similar Complaints**: Auto-suggest when submitting new complaint

INFO:     Started reloader process- 🤖 **Smart Categorization**: AI understands complaint context

INFO:     Started server process- 🤖 **Relevance Scoring**: Shows similarity percentage for search results

INFO:     Waiting for application startup.

INFO:     Application startup complete.## 📖 How Embeddings Improve SQL

```

### Traditional Keyword Search

**Backend is now running at:** http://localhost:8000```python

# Only finds exact keyword matches

---SELECT * FROM Complaints 

WHERE description LIKE '%water%';

### Terminal 2: Start Frontend Development Server```



```bash### AI-Enhanced Semantic Search

cd frontend```python

# Step 1: Convert query to embedding (384D vector)

# Start React development serverquery = "water not working"

npm startquery_embedding = model.encode(query)  # [0.234, -0.123, ...]

```

# Step 2: Find similar vectors using cosine distance

**Expected Output:**SELECT id, description, 

```       1 - (embedding <=> '[0.234, -0.123, ...]'::vector) AS score

Compiled successfully!FROM Complaints

WHERE ward = 'Ward 5'

You can now view citysense in the browser.ORDER BY score DESC

LIMIT 5;

  Local:            http://localhost:3000```

  On Your Network:  http://192.168.x.x:3000

```**Result**: Finds "pipeline burst", "no supply", "tap broken" - all semantically related!



**Frontend will automatically open at:** http://localhost:3000### The <=> Operator



---The `<=>` operator computes **cosine distance** between vectors:

- Distance closer to 0 = more similar

## Test Accounts- We convert to similarity: `1 - distance` gives score between 0-1

- Higher score = more relevant

Login with these pre-created accounts:

## 🧪 Example Queries

### 👤 Citizens (Regular Users)

**Email:** `citizen1@example.com` to `citizen30@example.com`  ### Natural Language Queries That Work

**Password:** `password123`

Try these in the search bar:

**What they can do:**

- Submit new complaints1. "water not working in my area"

- View their own complaints2. "broken street lights creating danger"

- Use AI-powered semantic search3. "garbage collection missed for days"

- View announcements4. "pothole causing accidents"

- Track complaint status5. "no electricity since morning"



**Try this account first:** `citizen1@example.com` / `password123`The AI understands:

- Synonyms: "water issue" = "water problem" = "no supply"

---- Context: "dark streets" = "street lights not working"

- Meaning: "waste piling up" = "garbage not collected"

### 👮 Officers (Ward Officers)

**Email:** `officer1@bangalore.gov.in` to `officer5@bangalore.gov.in`  ## 📁 Project Structure

**Password:** `officer123`

```

**What they can do:**CitySense/

- View all complaints in their ward├── backend/

- Update complaint status (pending → in_progress → resolved)│   ├── main.py                 # FastAPI application

- View analytics and AI summaries│   ├── embedding_service.py    # AI embedding generator

- Submit reports│   ├── requirements.txt        # Python dependencies

- Search complaints using AI│   └── .env.example           # Environment config

├── frontend/

**Try this:** `officer1@bangalore.gov.in` / `officer123`│   ├── public/

│   ├── src/

---│   │   ├── components/        # React components

│   │   ├── pages/            # Page components

### 👨‍💼 Admins (System Administrators)│   │   ├── services/         # API service layer

**Email:** `admin1@bangalore.gov.in`, `admin2@bangalore.gov.in`  │   │   ├── App.js           # Main app

**Password:** `admin123`│   │   └── index.js         # Entry point

│   └── package.json

**What they can do:**├── database/

- View city-wide data and analytics│   ├── schema.sql            # Database schema

- Create announcements (ward-specific or city-wide)│   ├── sample_data.sql       # Sample data

- Full system access│   └── populate_embeddings.py # Embedding generator

- Monitor all complaints across all wards└── README.md

```

**Try this:** `admin1@bangalore.gov.in` / `admin123`

## 🔒 Security Features

---

- ✅ JWT token-based authentication

## Features- ✅ Password hashing with bcrypt

- ✅ Role-based access control (citizen, officer, admin)

### 🎯 Core Features- ✅ Ward-level data isolation for officers

- ✅ SQL injection prevention (parameterized queries)

1. **AI-Powered Semantic Search**- ✅ CORS protection

   - Natural language query support

   - Vector similarity search using embeddings## 📈 Performance Optimization

   - Find similar complaints automatically

   - Example: "water problem in my area" finds related issues1. **HNSW Index**: Fast approximate nearest neighbor search

   - Sub-millisecond vector search even with millions of records

2. **Role-Based Access Control**   

   - Citizens: Personal complaint management2. **Traditional SQL Indexes**: Fast filtering on ward, status, category

   - Officers: Ward-level operations

   - Admins: System-wide control3. **Hybrid Queries**: Combine vector similarity with SQL filters

   ```sql

3. **Real-time Dashboards**   SELECT * FROM Complaints

   - Live statistics and charts   WHERE ward = 'Ward 5'  -- Fast SQL filter

   - Ward-wise complaint distribution   ORDER BY embedding <=> query_embedding  -- Then vector search

   - Status breakdown (pending/in-progress/resolved)   ```

   - Category analysis

## 🔮 Future Improvements

4. **Intelligent Complaint Matching**

   - Automatic detection of similar complaints- [ ] Add LLM-based complaint summarization (GPT4All/Mistral)

   - AI suggests related issues during submission- [ ] Implement notification system

   - Helps prevent duplicate complaints- [ ] Add image upload for complaints

- [ ] Geolocation-based complaint mapping

5. **Comprehensive Analytics**- [ ] Multi-language support

   - Trend analysis over time- [ ] Sentiment analysis on complaints

   - Category-wise distribution- [ ] Predictive analytics for complaint trends

   - Resolution rate tracking- [ ] Mobile app (React Native)

   - Ward-wise performance metrics

## 🛠️ Technology Stack

---

| Layer | Technology | Purpose |

## Technology Stack|-------|-----------|---------|

| Frontend | React (JS) | User interface |

### Backend| Backend | FastAPI | REST API server |

- **Framework:** FastAPI (Python)| Database | PostgreSQL | Data storage |

- **Database:** PostgreSQL 17 with pgvector extension| Vector Store | pgvector | Embedding storage |

- **Authentication:** JWT tokens with bcrypt password hashing| AI Model | all-MiniLM-L6-v2 | Text embeddings |

- **AI/ML:** Sentence transformers for embeddings| Auth | JWT | Authentication |

- **API:** RESTful API with automatic OpenAPI documentation| Charts | Chart.js | Analytics visualization |



### Frontend## 📚 Learning Resources

- **Framework:** React.js

- **HTTP Client:** Axios### Understanding Embeddings

- **Styling:** Custom CSS with modern design- [Sentence Transformers Documentation](https://www.sbert.net/)

- **State Management:** React Hooks- [What are Embeddings?](https://platform.openai.com/docs/guides/embeddings)



### Database & AI### PostgreSQL + pgvector

- **Vector Storage:** pgvector extension for PostgreSQL- [pgvector GitHub](https://github.com/pgvector/pgvector)

- **Embeddings:** 384-dimensional vectors (all-MiniLM-L6-v2 model)- [Working with Embeddings in PostgreSQL](https://neon.tech/blog/pgvector-overview)

- **Search Algorithm:** HNSW (Hierarchical Navigable Small World) for fast similarity search

- **Indexing:** Cosine similarity for semantic matching### FastAPI

- [FastAPI Documentation](https://fastapi.tiangolo.com/)

### DevOps

- **Containerization:** Docker for PostgreSQL## 🤝 Contributing

- **Development:** Hot reload for both frontend and backend

- **Environment:** Environment variables for configurationThis is an educational project demonstrating SQL + AI integration. Feel free to:

- Add new features

---- Improve AI accuracy

- Enhance UI/UX

## Stopping the Application- Optimize performance

- Add tests

### Stop Backend Server

In the backend terminal:## 📄 License

- Press `CTRL + C`

- Wait for "Shutting down" messageMIT License - Free to use for educational purposes



### Stop Frontend Server## 👨‍💻 Author

In the frontend terminal:

- Press `CTRL + C`Created as a demonstration of modern database management enhanced with AI capabilities.

- Type `Y` when asked to confirm

---

### Stop PostgreSQL Docker Container

## 🎓 Academic Context

```bash

# Stop the container (data is preserved)This project showcases:

docker stop citysense-db

1. **Database Management**

# To remove the container (WARNING: deletes all data)   - Complex schema design

docker rm citysense-db   - Indexing strategies

   - Query optimization

# To stop and remove in one command   - Data integrity

docker stop citysense-db && docker rm citysense-db

```2. **AI Integration**

   - Embedding generation

### Restart Everything Later   - Vector similarity search

   - Semantic retrieval

```bash   - Hybrid SQL + AI queries

# Start PostgreSQL container (if stopped)

docker start citysense-db3. **Full-Stack Development**

   - RESTful API design

# Start backend (Terminal 1)   - Authentication & authorization

cd backend   - State management

venv\Scripts\activate   - Responsive UI

python -m uvicorn main:app --reload

4. **Real-World Application**

# Start frontend (Terminal 2)   - Citizen services

cd frontend   - Government workflows

npm start   - Analytics and reporting

```   - Multi-role access



------



## Troubleshooting**🎯 Key Takeaway**: This project proves that AI doesn't replace SQL—it enhances it. By combining traditional database strengths with semantic understanding, we create more intelligent, user-friendly applications.


### Problem: Docker container won't start

**Error:** `port 5432 already in use`

**Solution:**
```bash
# Check what's using port 5432
netstat -ano | findstr :5432

# Kill the process or stop local PostgreSQL service
# Or use a different port in docker:
docker run --name citysense-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bangalore_smartcity -p 5433:5432 -d ankane/pgvector

# Update .env file: DB_PORT=5433
```

---

### Problem: Backend won't start

**Error:** `ModuleNotFoundError: No module named 'fastapi'`

**Solution:**
```bash
# Make sure virtual environment is activated
venv\Scripts\activate

# Reinstall dependencies
pip install -r requirements.txt
```

---

### Problem: Frontend won't start

**Error:** `npm ERR! missing script: start`

**Solution:**
```bash
# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
npm start
```

---

### Problem: Database connection error

**Error:** `could not connect to server`

**Solution:**
```bash
# Check if Docker container is running
docker ps

# If not running, start it
docker start citysense-db

# Check container logs
docker logs citysense-db

# Verify connection settings in .env file match Docker setup
```

---

### Problem: "No data" in dashboard

**Solution:**
```bash
# Run the data population script again
cd backend
python populate_data.py

# Or run complete setup
python setup_all.py
```

---

### Problem: 401 Unauthorized errors

**Solution:**
- Logout and login again
- JWT token may have expired (valid for 24 hours)
- Check browser console for error details
- Clear browser localStorage and login again

---

### Problem: Search not working

**Cause:** AI embeddings not generated

**Solution:**
```bash
# Regenerate embeddings (if needed)
cd database
python populate_embeddings.py
```

---

## API Documentation

Once the backend is running, access the interactive API docs:

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc

These provide:
- Complete API endpoint documentation
- Interactive request testing
- Request/response schemas
- Authentication examples

---

## Project Structure

```
CitySense/
├── backend/
│   ├── app/
│   │   ├── core/          # Database, security, config
│   │   ├── models/        # Pydantic models
│   │   ├── routes/        # API endpoints
│   │   ├── services/      # Business logic
│   │   └── utils/         # Utility functions
│   ├── main.py            # FastAPI application entry
│   ├── requirements.txt   # Python dependencies
│   ├── setup_all.py       # Complete database setup
│   └── .env               # Environment variables
├── frontend/
│   ├── public/            # Static files
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── pages/         # Page components
│   │   ├── services/      # API client
│   │   └── App.js         # Main React component
│   └── package.json       # Node dependencies
├── database/
│   ├── schema.sql         # Database schema
│   └── sample_data.sql    # Sample data
├── docs/                  # Documentation
└── README.md              # This file
```

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## License

This project is developed as part of MSRIT DBMS coursework.

---

## Contact

**Developer:** Sagar S R  
**Institution:** MSRIT  
**Course:** DBMS (Semester 5)  
**GitHub:** [@Sagar-S-R](https://github.com/Sagar-S-R)

---

## Acknowledgments

- PostgreSQL and pgvector teams for excellent vector search capabilities
- FastAPI framework for modern Python API development
- React team for the powerful frontend framework
- Bangalore BBMP for inspiration on city complaint systems

---

**Happy Coding! 🚀**

If you encounter any issues not covered in this README, please open an issue on GitHub.
