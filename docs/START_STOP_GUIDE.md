# Quick Start/Stop Guide for CitySense

## 🛑 STOPPING THE APPLICATION

### Step 1: Stop Backend Server
In the backend terminal window:
```
Press CTRL + C
```
Wait for the message: `INFO: Shutting down`

---

### Step 2: Stop Frontend Server
In the frontend terminal window:
```
Press CTRL + C
```
When prompted `Terminate batch job (Y/N)?`, type:
```
Y
```

---

### Step 3: Stop PostgreSQL Docker Container

Open a new terminal (PowerShell/CMD) and run:

```bash
# Stop the container (keeps data safe)
docker stop smartcity-postgres
```

**That's it!** Your data is preserved and you can restart later.

---

### Optional: Remove Docker Container Completely

⚠️ **WARNING: This deletes ALL your data!**

```bash
# Stop and remove container
docker stop smartcity-postgres
docker rm smartcity-postgres

# Verify it's gone
docker ps -a
```

---

## ▶️ STARTING THE APPLICATION (Next Time)

### Step 1: Start Docker Container

Open terminal and run:

```bash
# If container exists (just stopped)
docker start smartcity-postgres

# If container was removed, create new one
docker run --name smartcity-postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bangalore_smartcity -p 5432:5432 -d ankane/pgvector
```

**Verify it's running:**
```bash
docker ps
```
You should see `smartcity-postgres` with status "Up"

---

### Step 2: Start Backend Server

Open **Terminal 1:**

```bash
# Navigate to backend folder
cd "E:\Sagar\MSRIT SEM5\DBMS\CitySense\backend"

# Activate virtual environment
venv\Scripts\activate

# Start backend
python -m uvicorn main:app --reload
```

**Expected Output:**
```
INFO: Uvicorn running on http://127.0.0.1:8000
INFO: Application startup complete.
```

✅ **Backend is now running!**

---

### Step 3: Start Frontend Server

Open **Terminal 2:**

```bash
# Navigate to frontend folder
cd "E:\Sagar\MSRIT SEM5\DBMS\CitySense\frontend"

# Start frontend
npm start
```

**Expected Output:**
```
Compiled successfully!
Local: http://localhost:3000
```

✅ **Frontend will auto-open in browser!**

---

## 📋 CHECKLIST

### Stopping (End of Day):
- [ ] Stop Backend (CTRL + C in Terminal 1)
- [ ] Stop Frontend (CTRL + C in Terminal 2, then Y)
- [ ] Stop Docker (`docker stop smartcity-postgres`)

### Starting (Next Day):
- [ ] Start Docker (`docker start smartcity-postgres`)
- [ ] Start Backend (Terminal 1: `python -m uvicorn main:app --reload`)
- [ ] Start Frontend (Terminal 2: `npm start`)
- [ ] Open http://localhost:3000

---

## ❓ TROUBLESHOOTING

### Docker container won't start?
```bash
# Check if container exists
docker ps -a

# If exists but stopped, start it
docker start smartcity-postgres

# If doesn't exist, create new one
docker run --name smartcity-postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bangalore_smartcity -p 5432:5432 -d ankane/pgvector
```

### Backend shows "database connection error"?
```bash
# Make sure Docker is running
docker ps

# Restart Docker container
docker restart smartcity-postgres

# Wait 5 seconds, then start backend again
```

### Frontend won't start?
```bash
# Make sure you're in frontend directory
cd frontend

# Try reinstalling
npm install

# Then start
npm start
```

### Port 5432 already in use?
```bash
# Find what's using the port
netstat -ano | findstr :5432

# Stop local PostgreSQL service if running
# Or use different port:
docker run --name smartcity-postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bangalore_smartcity -p 5433:5432 -d ankane/pgvector

# Update backend/.env file: DB_PORT=5433
```

---

## 🔄 COMMON WORKFLOW

### Daily Development:
1. **Morning:** Start Docker → Start Backend → Start Frontend
2. **Work:** Make changes, test features
3. **Evening:** Stop Frontend → Stop Backend → Stop Docker

### After Long Break:
1. Start Docker: `docker start smartcity-postgres`
2. Verify data: Backend should still have all complaints/users
3. If data is missing: Run `python populate_data.py` again

---

## 📝 IMPORTANT NOTES

✅ **Data is Safe When:**
- You use `docker stop` (not `docker rm`)
- Docker container exists (check with `docker ps -a`)

❌ **Data is Lost When:**
- You use `docker rm smartcity-postgres`
- You delete the Docker container
- You recreate container with same name

### To Preserve Data:
Always use:
```bash
docker stop smartcity-postgres  # ✅ Good
```

Never use (unless you want fresh start):
```bash
docker rm smartcity-postgres    # ❌ Deletes data
```

---

## 🎯 ONE-LINE COMMANDS

### Stop Everything:
```bash
docker stop smartcity-postgres
```
(Plus CTRL+C in both terminals)

### Start Everything:
```bash
# Terminal 1 (background - Docker)
docker start smartcity-postgres

# Terminal 2 (Backend)
cd backend && venv\Scripts\activate && python -m uvicorn main:app --reload

# Terminal 3 (Frontend)
cd frontend && npm start
```

---

## 🆘 NUCLEAR OPTION (Fresh Start)

If everything is broken and you want to start completely fresh:

```bash
# 1. Stop and remove everything
docker stop smartcity-postgres
docker rm smartcity-postgres

# 2. Recreate database
docker run --name smartcity-postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=bangalore_smartcity -p 5432:5432 -d ankane/pgvector

# 3. Setup database again
cd backend
python setup_all.py

# 4. Start backend
python -m uvicorn main:app --reload

# 5. Start frontend (new terminal)
cd frontend
npm start
```

---

**That's it! Bookmark this file for quick reference.**

**File Location:** `E:\Sagar\MSRIT SEM5\DBMS\CitySense\START_STOP_GUIDE.md`
