# 🏙️ SmartCity InsightHub

An AI-powered Smart City Dashboard that combines traditional SQL databases with semantic search capabilities using embeddings. Citizens can submit complaints, officers can manage them, and everyone benefits from intelligent natural language search powered by AI.

## 🎯 Project Overview

This project demonstrates **Database Management Enhanced with AI** by:
- Using PostgreSQL with pgvector extension for storing embeddings
- Implementing semantic similarity search alongside traditional SQL queries
- Converting text to 384-dimensional vectors using SentenceTransformers (all-MiniLM-L6-v2)
- Enabling natural language queries that understand meaning, not just keywords

### The Innovation: SQL + AI

**Traditional SQL:**
```sql
SELECT * FROM Complaints WHERE description LIKE '%water%';
```
❌ Misses: "pipeline broken", "tap not working", "no supply"

**AI-Enhanced SQL:**
```sql
SELECT *, 1 - (embedding <=> query_embedding) AS score
FROM Complaints
ORDER BY score DESC;
```
✅ Finds all semantically similar complaints regardless of exact keywords

## 🏗️ Architecture

```
┌─────────────┐
│   React     │  Frontend (Pure JavaScript, No TypeScript)
│  Frontend   │  - Citizen Dashboard
│             │  - Officer Dashboard
└──────┬──────┘  - AI Search Interface
       │
       │ HTTP/REST
       │
┌──────▼──────┐
│   FastAPI   │  Backend (Python)
│   Backend   │  - JWT Authentication
│             │  - Complaint Management
└──────┬──────┘  - Embedding Generation
       │
       ├─────────────────┐
       │                 │
┌──────▼──────┐   ┌──────▼──────────┐
│ PostgreSQL  │   │ SentenceTransf. │
│ + pgvector  │   │  all-MiniLM-    │
│             │   │    L6-v2        │
└─────────────┘   └─────────────────┘
```

## 📊 Database Schema

### Tables

1. **Citizens** - User accounts (citizens, officers, admins)
2. **Complaints** - Citizen complaints with embeddings
3. **Reports** - Officer reports with embeddings
4. **Announcements** - City announcements with embeddings
5. **Services** - Service catalog with embeddings

### Key Innovation: Vector Storage

Each text field is stored with its embedding:
```sql
CREATE TABLE Complaints (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    embedding VECTOR(384),  -- AI magic here!
    ...
);

-- Vector similarity index for fast search
CREATE INDEX idx_complaints_embedding 
ON Complaints USING hnsw (embedding vector_cosine_ops);
```

## 🚀 Getting Started

### Prerequisites

- **Python 3.9+**
- **PostgreSQL 14+** with pgvector extension
- **Node.js 16+**
- **Git**

### Installation

#### 1. Clone Repository

```bash
git clone <repository-url>
cd CitySense
```

#### 2. Setup Database

Install PostgreSQL and pgvector:

**Ubuntu/Debian:**
```bash
sudo apt-get install postgresql postgresql-contrib
git clone https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install
```

**Windows:**
- Download PostgreSQL from https://www.postgresql.org/download/windows/
- Follow pgvector installation guide: https://github.com/pgvector/pgvector#windows

Create database:
```bash
psql -U postgres
CREATE DATABASE smartcity_db;
\c smartcity_db
CREATE EXTENSION vector;
\q
```

Run schema and sample data:
```bash
psql -U postgres -d smartcity_db -f database/schema.sql
psql -U postgres -d smartcity_db -f database/sample_data.sql
```

#### 3. Setup Backend

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

pip install -r requirements.txt

# Create .env file
copy .env.example .env  # Windows
# cp .env.example .env  # Linux/Mac

# Edit .env with your database credentials
```

Generate embeddings for sample data:
```bash
cd ../database
python populate_embeddings.py
```

Start backend:
```bash
cd ../backend
uvicorn main:app --reload
```

Backend will run on http://localhost:8000

#### 4. Setup Frontend

```bash
cd ../frontend
npm install
npm start
```

Frontend will run on http://localhost:3000

## 👤 Demo Accounts

| Role | Email | Password |
|------|-------|----------|
| Citizen | rajesh@email.com | password123 |
| Officer | officer1@city.gov | password123 |
| Admin | admin@city.gov | password123 |

## 🎨 Features

### For Citizens
- ✅ Register and login
- ✅ Submit complaints with automatic AI categorization
- ✅ View complaint status
- ✅ Natural language search (AI-powered)
- ✅ See similar complaints automatically
- ✅ View ward announcements

### For Officers/Admins
- ✅ View ward/city-wide complaints
- ✅ Update complaint status
- ✅ AI-powered summary dashboard
- ✅ Analytics with charts
- ✅ Semantic search across all complaints
- ✅ Submit official reports

### AI Features
- 🤖 **Semantic Search**: "water problem" finds "pipeline broken", "tap not working"
- 🤖 **Similar Complaints**: Auto-suggest when submitting new complaint
- 🤖 **Smart Categorization**: AI understands complaint context
- 🤖 **Relevance Scoring**: Shows similarity percentage for search results

## 📖 How Embeddings Improve SQL

### Traditional Keyword Search
```python
# Only finds exact keyword matches
SELECT * FROM Complaints 
WHERE description LIKE '%water%';
```

### AI-Enhanced Semantic Search
```python
# Step 1: Convert query to embedding (384D vector)
query = "water not working"
query_embedding = model.encode(query)  # [0.234, -0.123, ...]

# Step 2: Find similar vectors using cosine distance
SELECT id, description, 
       1 - (embedding <=> '[0.234, -0.123, ...]'::vector) AS score
FROM Complaints
WHERE ward = 'Ward 5'
ORDER BY score DESC
LIMIT 5;
```

**Result**: Finds "pipeline burst", "no supply", "tap broken" - all semantically related!

### The <=> Operator

The `<=>` operator computes **cosine distance** between vectors:
- Distance closer to 0 = more similar
- We convert to similarity: `1 - distance` gives score between 0-1
- Higher score = more relevant

## 🧪 Example Queries

### Natural Language Queries That Work

Try these in the search bar:

1. "water not working in my area"
2. "broken street lights creating danger"
3. "garbage collection missed for days"
4. "pothole causing accidents"
5. "no electricity since morning"

The AI understands:
- Synonyms: "water issue" = "water problem" = "no supply"
- Context: "dark streets" = "street lights not working"
- Meaning: "waste piling up" = "garbage not collected"

## 📁 Project Structure

```
CitySense/
├── backend/
│   ├── main.py                 # FastAPI application
│   ├── embedding_service.py    # AI embedding generator
│   ├── requirements.txt        # Python dependencies
│   └── .env.example           # Environment config
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── pages/            # Page components
│   │   ├── services/         # API service layer
│   │   ├── App.js           # Main app
│   │   └── index.js         # Entry point
│   └── package.json
├── database/
│   ├── schema.sql            # Database schema
│   ├── sample_data.sql       # Sample data
│   └── populate_embeddings.py # Embedding generator
└── README.md
```

## 🔒 Security Features

- ✅ JWT token-based authentication
- ✅ Password hashing with bcrypt
- ✅ Role-based access control (citizen, officer, admin)
- ✅ Ward-level data isolation for officers
- ✅ SQL injection prevention (parameterized queries)
- ✅ CORS protection

## 📈 Performance Optimization

1. **HNSW Index**: Fast approximate nearest neighbor search
   - Sub-millisecond vector search even with millions of records
   
2. **Traditional SQL Indexes**: Fast filtering on ward, status, category

3. **Hybrid Queries**: Combine vector similarity with SQL filters
   ```sql
   SELECT * FROM Complaints
   WHERE ward = 'Ward 5'  -- Fast SQL filter
   ORDER BY embedding <=> query_embedding  -- Then vector search
   ```

## 🔮 Future Improvements

- [ ] Add LLM-based complaint summarization (GPT4All/Mistral)
- [ ] Implement notification system
- [ ] Add image upload for complaints
- [ ] Geolocation-based complaint mapping
- [ ] Multi-language support
- [ ] Sentiment analysis on complaints
- [ ] Predictive analytics for complaint trends
- [ ] Mobile app (React Native)

## 🛠️ Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | React (JS) | User interface |
| Backend | FastAPI | REST API server |
| Database | PostgreSQL | Data storage |
| Vector Store | pgvector | Embedding storage |
| AI Model | all-MiniLM-L6-v2 | Text embeddings |
| Auth | JWT | Authentication |
| Charts | Chart.js | Analytics visualization |

## 📚 Learning Resources

### Understanding Embeddings
- [Sentence Transformers Documentation](https://www.sbert.net/)
- [What are Embeddings?](https://platform.openai.com/docs/guides/embeddings)

### PostgreSQL + pgvector
- [pgvector GitHub](https://github.com/pgvector/pgvector)
- [Working with Embeddings in PostgreSQL](https://neon.tech/blog/pgvector-overview)

### FastAPI
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

## 🤝 Contributing

This is an educational project demonstrating SQL + AI integration. Feel free to:
- Add new features
- Improve AI accuracy
- Enhance UI/UX
- Optimize performance
- Add tests

## 📄 License

MIT License - Free to use for educational purposes

## 👨‍💻 Author

Created as a demonstration of modern database management enhanced with AI capabilities.

---

## 🎓 Academic Context

This project showcases:

1. **Database Management**
   - Complex schema design
   - Indexing strategies
   - Query optimization
   - Data integrity

2. **AI Integration**
   - Embedding generation
   - Vector similarity search
   - Semantic retrieval
   - Hybrid SQL + AI queries

3. **Full-Stack Development**
   - RESTful API design
   - Authentication & authorization
   - State management
   - Responsive UI

4. **Real-World Application**
   - Citizen services
   - Government workflows
   - Analytics and reporting
   - Multi-role access

---

**🎯 Key Takeaway**: This project proves that AI doesn't replace SQL—it enhances it. By combining traditional database strengths with semantic understanding, we create more intelligent, user-friendly applications.
