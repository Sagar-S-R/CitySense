# 🚀 Quick Setup Guide

Follow these steps to get SmartCity InsightHub running on your machine.

## ⚡ Quick Start (5 minutes)

### Step 1: Install PostgreSQL + pgvector

**Windows:**
1. Download PostgreSQL 14+ from https://www.postgresql.org/download/windows/
2. Install with default settings (remember your postgres password!)
3. Install pgvector:
   ```powershell
   # Open PowerShell as Administrator
   git clone https://github.com/pgvector/pgvector.git
   cd pgvector
   # Follow Windows installation guide from pgvector README
   ```

**Linux (Ubuntu/Debian):**
```bash
# Install PostgreSQL
sudo apt update
sudo apt install postgresql postgresql-contrib

# Install pgvector
git clone https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install
```

### Step 2: Create Database

```bash
# Connect to PostgreSQL
psql -U postgres

# In psql prompt:
CREATE DATABASE smartcity_db;
\c smartcity_db
CREATE EXTENSION vector;
\q
```

### Step 3: Setup Backend

```powershell
# Navigate to backend folder
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
# source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
copy .env.example .env  # Windows
# cp .env.example .env  # Linux

# Edit .env file with your PostgreSQL password
notepad .env  # Windows
# nano .env   # Linux
```

Edit `.env`:
```
DB_HOST=localhost
DB_NAME=smartcity_db
DB_USER=postgres
DB_PASSWORD=your_password_here  # ← Change this!
SECRET_KEY=your-secret-key-change-in-production
```

### Step 4: Initialize Database

```bash
# From project root
cd database

# Run schema
psql -U postgres -d smartcity_db -f schema.sql

# Load sample data
psql -U postgres -d smartcity_db -f sample_data.sql

# Generate embeddings (takes ~2 minutes)
python populate_embeddings.py
```

### Step 5: Start Backend

```bash
cd ../backend
uvicorn main:app --reload
```

✅ Backend running at http://localhost:8000

### Step 6: Setup Frontend

**Open a new terminal:**

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start
```

✅ Frontend running at http://localhost:3000

## 🎉 You're Done!

1. Open browser to http://localhost:3000
2. Login with demo account:
   - **Email:** rajesh@email.com
   - **Password:** password123

## 🧪 Test the AI Search

Try these natural language queries in the search bar:

- "water not working"
- "street lights broken"
- "garbage not collected"
- "road damage causing accidents"

Watch how the AI finds semantically similar complaints!

## 🐛 Troubleshooting

### Problem: "psycopg2" installation fails

**Solution (Windows):**
```powershell
pip install psycopg2-binary
```

### Problem: "pgvector extension not found"

**Solution:**
1. Make sure pgvector is installed correctly
2. Restart PostgreSQL service
3. Try creating extension again:
   ```sql
   DROP EXTENSION IF EXISTS vector;
   CREATE EXTENSION vector;
   ```

### Problem: "Port 8000 already in use"

**Solution:**
```bash
# Find and kill the process
# Windows:
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux:
sudo lsof -ti:8000 | xargs kill -9
```

### Problem: "Module 'sentence-transformers' not found"

**Solution:**
```bash
pip install sentence-transformers torch
```

### Problem: Frontend can't connect to backend

**Solution:**
1. Check backend is running on port 8000
2. Check CORS settings in `backend/main.py`
3. Clear browser cache
4. Check browser console for errors

## 📝 Development Workflow

### Making Changes to Backend

1. Edit Python files in `backend/`
2. Server auto-reloads (if using `--reload` flag)
3. Test at http://localhost:8000/docs (FastAPI auto-docs)

### Making Changes to Frontend

1. Edit React files in `frontend/src/`
2. Changes reflect immediately (hot reload)
3. Check browser console for errors

### Adding New Sample Data

1. Edit `database/sample_data.sql`
2. Run:
   ```bash
   psql -U postgres -d smartcity_db -f database/sample_data.sql
   python database/populate_embeddings.py
   ```

## 🔍 Verify Installation

Check if everything is working:

### 1. Database Connection
```bash
psql -U postgres -d smartcity_db -c "SELECT COUNT(*) FROM Complaints;"
```
Should show: 30 (or number of sample complaints)

### 2. Embeddings Generated
```sql
psql -U postgres -d smartcity_db
SELECT COUNT(*) FROM Complaints WHERE embedding IS NOT NULL;
```
Should show: 30 (all complaints have embeddings)

### 3. Backend API
Visit: http://localhost:8000/
Should show: `{"status":"SmartCity InsightHub API is running","version":"1.0"}`

### 4. Frontend
Visit: http://localhost:3000
Should show: Login page

## 🎯 Next Steps

After setup:

1. ✅ Try logging in with different roles (citizen, officer, admin)
2. ✅ Submit a new complaint and see similar suggestions
3. ✅ Test AI search with natural language
4. ✅ View analytics charts in officer dashboard
5. ✅ Explore the code to understand SQL + AI integration

## 📚 Understanding the Code

### Key Files to Study

1. **`backend/main.py`** - See how SQL + vector search work together
2. **`backend/embedding_service.py`** - Understand embedding generation
3. **`database/schema.sql`** - Learn vector storage in PostgreSQL
4. **`frontend/src/pages/CitizenDashboard.js`** - See React state management
5. **`frontend/src/services/api.js`** - Understand API communication

### SQL + AI in Action

Look at this query in `backend/main.py`:

```python
# Traditional SQL
WHERE ward = %s AND status = %s

# Combined with AI
ORDER BY embedding <=> query_embedding
```

This is the core innovation: **Filtering with SQL, Ranking with AI**

## 🎓 Learning Path

1. **Week 1**: Understand basic setup and CRUD operations
2. **Week 2**: Study embedding generation and storage
3. **Week 3**: Analyze vector similarity search queries
4. **Week 4**: Explore hybrid SQL + AI patterns
5. **Week 5**: Implement your own features!

## 💡 Ideas to Extend

- Add more complaint categories
- Implement real-time notifications
- Add image upload for complaints
- Create data visualization dashboard
- Add sentiment analysis
- Implement auto-categorization using AI
- Add multi-language support

## 🆘 Getting Help

If stuck:

1. Check error messages carefully
2. Read the main README.md
3. Search error message online
4. Check backend logs in terminal
5. Check browser console (F12)
6. Review the code comments (heavily documented!)

---

**Ready to explore AI-enhanced databases? Let's go! 🚀**
