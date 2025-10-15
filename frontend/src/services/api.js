/**
 * API Service - Handles all backend communication
 * Manages authentication, complaints, search, and dashboard data
 */

import axios from 'axios';

// Base URL for backend API
const API_BASE_URL = 'http://localhost:8000';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token to all requests
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle common errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid - logout user
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

/**
 * Authentication Services
 */
export const authService = {
  /**
   * Register a new user
   */
  register: async (userData) => {
    const response = await api.post('/registerUser', userData);
    return response.data;
  },

  /**
   * Login user and store token
   */
  login: async (credentials) => {
    const response = await api.post('/login', credentials);
    if (response.data.access_token) {
      localStorage.setItem('token', response.data.access_token);
      localStorage.setItem('user', JSON.stringify(response.data.user));
    }
    return response.data;
  },

  /**
   * Logout user
   */
  logout: () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  },

  /**
   * Get current user from localStorage
   */
  getCurrentUser: () => {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  },

  /**
   * Check if user is authenticated
   */
  isAuthenticated: () => {
    return !!localStorage.getItem('token');
  },
};

/**
 * Complaint Services
 */
export const complaintService = {
  /**
   * Submit a new complaint
   */
  submitComplaint: async (complaintData) => {
    const response = await api.post('/submitComplaint', complaintData);
    return response.data;
  },

  /**
   * Search complaints using natural language query
   * This uses AI embeddings for semantic search
   */
  searchComplaints: async (query, ward = null, limit = 5) => {
    const response = await api.post('/searchComplaints', {
      query,
      ward,
      limit,
    });
    return response.data;
  },

  /**
   * Get complaints similar to a specific complaint
   * Uses vector similarity search
   */
  getSimilarIssues: async (complaintId) => {
    const response = await api.get(`/getSimilarIssues/${complaintId}`);
    return response.data;
  },

  /**
   * Update complaint status (officer/admin only)
   */
  updateStatus: async (complaintId, status) => {
    const response = await api.post('/updateComplaintStatus', {
      complaint_id: complaintId,
      status,
    });
    return response.data;
  },
};

/**
 * Dashboard Services
 */
export const dashboardService = {
  /**
   * Get dashboard data (role-specific)
   * Citizens see their own complaints
   * Officers see ward-level data
   * Admins see city-wide data
   */
  getDashboardData: async () => {
    const response = await api.get('/getDashboardData');
    return response.data;
  },

  /**
   * Get AI-powered summary
   * Uses SQL aggregations for insights
   */
  getSummary: async () => {
    const response = await api.get('/getSummary');
    return response.data;
  },
};

/**
 * Announcement Services
 */
export const announcementService = {
  /**
   * Get announcements for a ward
   */
  getAnnouncements: async (ward = null, limit = 10) => {
    const params = new URLSearchParams();
    if (ward) params.append('ward', ward);
    params.append('limit', limit);
    
    const response = await api.get(`/announcements?${params.toString()}`);
    return response.data;
  },

  /**
   * Search announcements using semantic search
   */
  searchAnnouncements: async (query, ward = null, limit = 5) => {
    const response = await api.post('/searchAnnouncements', {
      query,
      ward,
      limit,
    });
    return response.data;
  },
};

/**
 * Report Services (Officers only)
 */
export const reportService = {
  /**
   * Submit a new report
   */
  submitReport: async (reportData) => {
    const response = await api.post('/submitReport', reportData);
    return response.data;
  },
};

export default api;
