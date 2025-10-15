"""
Embedding Service
Handles AI-powered text embeddings using SentenceTransformers
"""

from sentence_transformers import SentenceTransformer
import numpy as np

class EmbeddingService:
    """
    Manages text embedding generation using all-MiniLM-L6-v2 model
    Converts text to 384-dimensional vectors for semantic search
    """
    
    def __init__(self, model_name: str = "all-MiniLM-L6-v2"):
        """
        Initialize the embedding model
        Model is loaded once and cached for all requests
        """
        print(f"Loading embedding model: {model_name}")
        self.model = SentenceTransformer(model_name)
        self.dimension = 384  # Output vector dimension
        print(f"Model loaded successfully. Vector dimension: {self.dimension}")
    
    def get_embedding(self, text: str) -> list:
        """
        Convert text to embedding vector
        
        Args:
            text: Input text string
            
        Returns:
            384-dimensional vector as list of floats
        """
        text = text.strip()
        if not text:
            return [0.0] * self.dimension
        
        # Generate normalized embedding
        embedding = self.model.encode(text, normalize_embeddings=True)
        return embedding.tolist()
    
    def get_embeddings_batch(self, texts: list) -> list:
        """
        Generate embeddings for multiple texts efficiently
        
        Args:
            texts: List of text strings
            
        Returns:
            List of embedding vectors
        """
        embeddings = self.model.encode(
            texts, 
            normalize_embeddings=True, 
            show_progress_bar=True
        )
        return [emb.tolist() for emb in embeddings]
    
    def compute_similarity(self, text1: str, text2: str) -> float:
        """
        Compute semantic similarity between two texts
        
        Args:
            text1: First text string
            text2: Second text string
            
        Returns:
            Similarity score between 0 and 1 (1 = identical meaning)
        """
        emb1 = np.array(self.get_embedding(text1))
        emb2 = np.array(self.get_embedding(text2))
        
        # Cosine similarity (dot product of normalized vectors)
        similarity = np.dot(emb1, emb2)
        return float(similarity)
    
    def embedding_to_postgres_string(self, embedding: list) -> str:
        """
        Convert embedding list to PostgreSQL vector format
        
        Args:
            embedding: List of floats
            
        Returns:
            String formatted for PostgreSQL vector type
        """
        return "[" + ",".join(map(str, embedding)) + "]"

# Create global embedding service instance
embedding_service = EmbeddingService()
