-- SmartCity InsightHub Database Schema
-- PostgreSQL with pgvector extension for AI-powered semantic search

-- Enable pgvector extension for storing embeddings
-- This extension adds vector data type and similarity search operators
CREATE EXTENSION IF NOT EXISTS vector;

-- ============================================
-- CITIZENS TABLE
-- Stores user accounts (citizens, officers, admins)
-- ============================================
CREATE TABLE IF NOT EXISTS Citizens (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    ward VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'citizen', -- citizen, officer, admin
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster email lookups during login
CREATE INDEX idx_citizens_email ON Citizens(email);
CREATE INDEX idx_citizens_ward ON Citizens(ward);

-- ============================================
-- COMPLAINTS TABLE
-- Core table storing citizen complaints with AI embeddings
-- ============================================
CREATE TABLE IF NOT EXISTS Complaints (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Citizens(id) ON DELETE CASCADE,
    ward VARCHAR(50) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, in_progress, resolved, rejected
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- AI Enhancement: Vector embedding for semantic search
    -- 384 dimensions from all-MiniLM-L6-v2 model
    embedding VECTOR(384)
);

-- Traditional SQL indexes for exact matching
CREATE INDEX idx_complaints_ward ON Complaints(ward);
CREATE INDEX idx_complaints_status ON Complaints(status);
CREATE INDEX idx_complaints_category ON Complaints(category);
CREATE INDEX idx_complaints_date ON Complaints(date DESC);
CREATE INDEX idx_complaints_user ON Complaints(user_id);

-- AI Enhancement: Vector similarity index using HNSW algorithm
-- This enables fast approximate nearest neighbor search
-- HNSW (Hierarchical Navigable Small World) is optimized for high-dimensional vectors
CREATE INDEX idx_complaints_embedding ON Complaints USING hnsw (embedding vector_cosine_ops);

-- ============================================
-- REPORTS TABLE
-- Officer-submitted reports with embeddings
-- ============================================
CREATE TABLE IF NOT EXISTS Reports (
    id SERIAL PRIMARY KEY,
    officer_id INTEGER NOT NULL REFERENCES Citizens(id) ON DELETE CASCADE,
    ward VARCHAR(50) NOT NULL,
    report_text TEXT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- AI Enhancement: Semantic search on reports
    embedding VECTOR(384)
);

CREATE INDEX idx_reports_ward ON Reports(ward);
CREATE INDEX idx_reports_date ON Reports(date DESC);
CREATE INDEX idx_reports_embedding ON Reports USING hnsw (embedding vector_cosine_ops);

-- ============================================
-- ANNOUNCEMENTS TABLE
-- Official city announcements with semantic search
-- ============================================
CREATE TABLE IF NOT EXISTS Announcements (
    id SERIAL PRIMARY KEY,
    ward VARCHAR(50) NOT NULL, -- 'All' for city-wide announcements
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- AI Enhancement: Semantic search for relevant announcements
    embedding VECTOR(384)
);

CREATE INDEX idx_announcements_ward ON Announcements(ward);
CREATE INDEX idx_announcements_date ON Announcements(date DESC);
CREATE INDEX idx_announcements_embedding ON Announcements USING hnsw (embedding vector_cosine_ops);

-- ============================================
-- SERVICES TABLE
-- City services catalog with semantic search
-- ============================================
CREATE TABLE IF NOT EXISTS Services (
    id SERIAL PRIMARY KEY,
    ward VARCHAR(50) NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- active, inactive, maintenance
    
    -- AI Enhancement: Find services by semantic description
    embedding VECTOR(384)
);

CREATE INDEX idx_services_ward ON Services(ward);
CREATE INDEX idx_services_status ON Services(status);
CREATE INDEX idx_services_embedding ON Services USING hnsw (embedding vector_cosine_ops);

-- ============================================
-- HELPER FUNCTION: Compute Similarity Score
-- Converts distance to similarity percentage
-- ============================================
CREATE OR REPLACE FUNCTION similarity_score(embedding1 VECTOR, embedding2 VECTOR)
RETURNS FLOAT AS $$
BEGIN
    -- Cosine distance operator <=> returns value between 0 and 2
    -- We convert to similarity: 1 - distance/2 gives 0-1 range
    RETURN 1 - (embedding1 <=> embedding2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================
-- COMMENTS: Understanding the AI Enhancement
-- ============================================

-- Traditional SQL Query:
-- SELECT * FROM Complaints WHERE description LIKE '%water%' AND ward = 'Ward 5';
-- Problem: Misses "pipeline broken", "tap not working", "no supply"

-- AI-Enhanced SQL Query:
-- SELECT *, 1 - (embedding <=> query_embedding) AS score
-- FROM Complaints
-- WHERE ward = 'Ward 5'
-- ORDER BY score DESC;
-- Benefit: Finds all semantically similar complaints regardless of keywords

-- The <=> operator computes cosine distance between vectors
-- Lower distance = higher similarity
-- We convert to score: 1 - distance = similarity score (0 to 1)

COMMENT ON COLUMN Complaints.embedding IS 'AI-generated 384-dimensional vector for semantic similarity search using all-MiniLM-L6-v2 model';
COMMENT ON INDEX idx_complaints_embedding IS 'HNSW index for fast approximate nearest neighbor search on complaint embeddings';
