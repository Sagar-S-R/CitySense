# 🤖 Understanding AI in SmartCity InsightHub

A beginner-friendly guide to how AI enhances our SQL database.

## 📚 Table of Contents

1. [What are Embeddings?](#what-are-embeddings)
2. [How Embeddings Work](#how-embeddings-work)
3. [Vector Similarity Search](#vector-similarity-search)
4. [SQL + AI Integration](#sql--ai-integration)
5. [Real Examples](#real-examples)
6. [Performance Considerations](#performance-considerations)

---

## What are Embeddings?

### Simple Explanation

**Embeddings convert text into numbers that computers can understand and compare.**

Think of it like this:
- You can't easily compare "water problem" and "pipeline broken" as text
- But if you convert them to coordinates in space, you can measure the distance
- Words with similar meanings end up close together in this space

### Technical Explanation

An embedding is a **dense vector representation** of text:
- Text → Model → 384 numbers (our vector)
- Similar texts → Similar vectors
- `"water issue"` → `[0.234, -0.123, 0.456, ...]`
- `"pipeline broken"` → `[0.229, -0.119, 0.461, ...]` (very close!)

### Why 384 Dimensions?

The model `all-MiniLM-L6-v2` produces 384-dimensional vectors because:
1. **Not too small**: Captures nuanced meaning
2. **Not too large**: Fast to compute and store
3. **Optimized**: Trained on millions of text pairs

---

## How Embeddings Work

### Step-by-Step Process

#### 1. Text Input
```
"Water not coming from tap since yesterday morning"
```

#### 2. Tokenization
Break into smaller pieces:
```
["Water", "not", "coming", "from", "tap", "since", "yesterday", "morning"]
```

#### 3. Neural Network Processing
Pass through transformer model layers:
- **Attention Mechanism**: Understands which words relate to each other
- **Context Building**: "water" + "tap" → plumbing context
- **Meaning Extraction**: Identifies the core problem

#### 4. Vector Output
```python
[0.234, -0.123, 0.456, 0.789, ..., 0.321]  # 384 numbers total
```

### Visualization

```
High-dimensional space (384D):

"water not working"     ●
"pipeline broken"       ● ← Close together!
"tap issue"            ●

"street light out"              ● ← Far away
```

---

## Vector Similarity Search

### How We Compare Vectors

#### Cosine Similarity

Measures the **angle** between two vectors, not their magnitude.

```
Vector A: [1, 2, 3]
Vector B: [2, 4, 6]  ← Same direction, just scaled

Cosine Similarity = 1.0 (identical direction)
```

**Formula:**
```
similarity = (A · B) / (||A|| × ||B||)
```

Where:
- `A · B` = dot product
- `||A||` = magnitude of A

#### In Our System

We use PostgreSQL's `<=>` operator which computes **cosine distance**:

```sql
embedding1 <=> embedding2
```

- Returns: 0 to 2
- 0 = identical vectors
- 2 = completely opposite

We convert to similarity:
```sql
1 - (embedding1 <=> embedding2) AS similarity_score
```

Now:
- 1.0 = perfect match
- 0.5 = somewhat similar
- 0.0 = not similar at all

---

## SQL + AI Integration

### Traditional SQL (Before AI)

```sql
-- Exact keyword matching only
SELECT * FROM Complaints
WHERE description LIKE '%water%'
  AND ward = 'Ward 1';
```

**Problems:**
- Misses synonyms: "pipeline", "tap", "supply"
- Misses context: "no H2O" won't match
- Can't understand meaning: "dry taps since morning" won't match

### AI-Enhanced SQL (Our System)

```sql
-- Step 1: Get query embedding
query_embedding = model.encode("water not working")
-- → [0.234, -0.123, 0.456, ...]

-- Step 2: Find similar vectors in database
SELECT 
  id,
  description,
  1 - (embedding <=> '[0.234,-0.123,0.456,...]'::vector) AS score
FROM Complaints
WHERE ward = 'Ward 1'  -- Still use SQL filters!
ORDER BY score DESC
LIMIT 5;
```

**Advantages:**
✅ Finds "pipeline broken", "no supply", "tap issue"
✅ Understands semantic meaning
✅ Works with any phrasing
✅ Combines with traditional SQL filters

---

## Real Examples

### Example 1: Water Complaints

**User Query:** *"water not working in my area"*

**What Happens:**

1. **Convert to embedding:**
   ```python
   query_emb = [0.234, -0.123, 0.456, ..., 0.321]
   ```

2. **Search database:**
   ```sql
   SELECT description, 
          1 - (embedding <=> '[0.234,...]'::vector) AS score
   FROM Complaints
   WHERE ward = 'Ward 5'
   ORDER BY score DESC
   LIMIT 5;
   ```

3. **Results with scores:**
   ```
   0.92 - "Pipeline burst, no water supply"
   0.88 - "Tap not working since morning"
   0.85 - "Water shortage in building"
   0.79 - "Low water pressure issues"
   0.72 - "Dirty water coming from taps"
   ```

### Example 2: Understanding Synonyms

**Database contains:**
- "Electricity outage for 6 hours"
- "Power cut affecting entire street"
- "No current since morning"

**User searches:** *"no electricity"*

**All three match!** Because embeddings understand:
- electricity = power = current
- outage = cut = no [supply]

### Example 3: Context Understanding

**User:** *"dark streets at night"*

**Matches:** "Street lights not working"

Why? The model understands:
- dark + night + streets → lighting issue
- Context implies street lights
- Semantic relationship captured

---

## Performance Considerations

### Storage

Each embedding takes:
```
384 dimensions × 4 bytes (float) = 1,536 bytes ≈ 1.5 KB
```

For 1 million complaints:
```
1,000,000 × 1.5 KB = 1.5 GB for embeddings alone
```

**Optimization:** Use HNSW index (see below)

### Search Speed

#### Without Index
- Linear scan: O(n) - check every record
- 1 million records ≈ 2-3 seconds

#### With HNSW Index
- Approximate search: O(log n)
- 1 million records ≈ 10-50 milliseconds

### HNSW Index Explained

**HNSW** = Hierarchical Navigable Small World

```
Layer 2:  ●————————●  (sparse, long jumps)
          |        |
Layer 1:  ●——●——●——●  (medium density)
          |  |  |  |
Layer 0:  ●●●●●●●●●●  (all points, fine search)
```

**How it works:**
1. Start at top layer (sparse)
2. Jump to nearest neighbors quickly
3. Descend layers, narrowing search
4. Fine-tune at bottom layer
5. Result: Very fast approximate nearest neighbor search

**Trade-off:**
- 100% accuracy → slow (exact search)
- 99% accuracy → very fast (HNSW)
- For our use case, 99% is perfect!

---

## Code Walkthrough

### Generating Embeddings

```python
# embedding_service.py

from sentence_transformers import SentenceTransformer

class EmbeddingService:
    def __init__(self):
        # Load model once (cached after first load)
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
    
    def get_embedding(self, text):
        # Convert text → 384D vector
        embedding = self.model.encode(text, normalize_embeddings=True)
        return embedding.tolist()
```

### Storing in Database

```python
# main.py

# Generate embedding
embedding = embedding_service.get_embedding(complaint.description)

# Convert to PostgreSQL vector format
embedding_str = "[" + ",".join(map(str, embedding)) + "]"

# Store in database
cursor.execute(
    """
    INSERT INTO Complaints (description, embedding, ...)
    VALUES (%s, %s::vector, ...)
    """,
    (complaint.description, embedding_str, ...)
)
```

### Searching with Vectors

```python
# Generate query embedding
query_emb = embedding_service.get_embedding("water problem")
emb_str = "[" + ",".join(map(str, query_emb)) + "]"

# Search database
cursor.execute(
    """
    SELECT id, description,
           1 - (embedding <=> %s::vector) AS score
    FROM Complaints
    WHERE ward = %s
    ORDER BY score DESC
    LIMIT 5
    """,
    (emb_str, "Ward 5")
)
```

---

## Why This Matters

### Before AI (Traditional SQL)

**Query:** "water problem"

**Results:**
- Finds: "water problem", "water issues"
- Misses: "pipeline broken", "no supply", "tap not working"
- **Success Rate: ~30%**

### After AI (Our System)

**Query:** "water problem"

**Results:**
- Finds: All of the above + semantically similar
- Understands: synonyms, context, meaning
- **Success Rate: ~90%**

### Real-World Impact

**Citizen Benefits:**
- Better search results
- See similar complaints automatically
- Find solutions faster

**Officer Benefits:**
- Group similar complaints
- Identify patterns
- More efficient resolution

**System Benefits:**
- Reduced duplicate complaints
- Better analytics
- Smarter automation

---

## Learning Resources

### Beginner Level
1. [What are word embeddings?](https://machinelearningmastery.com/what-are-word-embeddings/)
2. [Visual introduction to embeddings](https://www.tensorflow.org/text/guide/word_embeddings)

### Intermediate Level
3. [Sentence Transformers documentation](https://www.sbert.net/)
4. [Understanding cosine similarity](https://www.machinelearningplus.com/nlp/cosine-similarity/)

### Advanced Level
5. [HNSW algorithm paper](https://arxiv.org/abs/1603.09320)
6. [pgvector internals](https://github.com/pgvector/pgvector)

---

## Try It Yourself

### Experiment 1: Compare Embeddings

```python
from embedding_service import EmbeddingService

service = EmbeddingService()

# Get embeddings
emb1 = service.get_embedding("water not working")
emb2 = service.get_embedding("pipeline broken")
emb3 = service.get_embedding("street light out")

# Compare
print(service.compute_similarity("water not working", "pipeline broken"))
# Output: ~0.85 (very similar!)

print(service.compute_similarity("water not working", "street light out"))
# Output: ~0.30 (not similar)
```

### Experiment 2: Visualize (2D projection)

```python
# Install: pip install scikit-learn matplotlib
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt

texts = [
    "water not working",
    "pipeline broken",
    "no water supply",
    "street light out",
    "dark at night",
    "garbage not collected",
]

embeddings = [service.get_embedding(t) for t in texts]

# Reduce 384D → 2D
tsne = TSNE(n_components=2)
embeddings_2d = tsne.fit_transform(embeddings)

# Plot
plt.scatter(embeddings_2d[:, 0], embeddings_2d[:, 1])
for i, txt in enumerate(texts):
    plt.annotate(txt, (embeddings_2d[i, 0], embeddings_2d[i, 1]))
plt.show()
```

You'll see water-related complaints cluster together!

---

## Summary

🔑 **Key Takeaways:**

1. **Embeddings = Text as Numbers**
   - Convert text → vectors
   - Similar meaning → similar vectors

2. **Vector Search = Semantic Understanding**
   - Find by meaning, not just keywords
   - Use cosine similarity

3. **SQL + AI = Best of Both Worlds**
   - SQL for filtering, constraints, transactions
   - AI for semantic search and ranking

4. **Fast & Scalable**
   - HNSW index for speed
   - Works with millions of records

5. **Real-World Impact**
   - Better user experience
   - Smarter applications
   - More efficient systems

---

**The future of databases is hybrid: Traditional SQL for structure, AI for understanding. This project shows you how!** 🚀
