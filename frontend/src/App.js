/**
 * Main App Component
 * Handles routing and authentication state
 */

import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { authService } from './services/api';

// Import pages
import Login from './pages/Login';
import Register from './pages/Register';
import CitizenDashboard from './pages/CitizenDashboard';
import OfficerDashboard from './pages/OfficerDashboard';

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // Check authentication status on mount
  useEffect(() => {
    const currentUser = authService.getCurrentUser();
    setUser(currentUser);
    setLoading(false);
  }, []);

  // Protected Route component
  const ProtectedRoute = ({ children, allowedRoles }) => {
    if (loading) {
      return <div className="spinner"></div>;
    }

    if (!authService.isAuthenticated()) {
      return <Navigate to="/login" />;
    }

    if (allowedRoles && !allowedRoles.includes(user?.role)) {
      return <Navigate to="/" />;
    }

    return children;
  };

  // Public Route component (redirect if authenticated)
  const PublicRoute = ({ children }) => {
    if (loading) {
      return <div className="spinner"></div>;
    }

    if (authService.isAuthenticated()) {
      // Redirect based on role
      if (user?.role === 'citizen') {
        return <Navigate to="/citizen/dashboard" />;
      } else {
        return <Navigate to="/officer/dashboard" />;
      }
    }

    return children;
  };

  return (
    <Router>
      <div className="App">
        <Routes>
          {/* Public routes */}
          <Route
            path="/login"
            element={
              <PublicRoute>
                <Login setUser={setUser} />
              </PublicRoute>
            }
          />
          <Route
            path="/register"
            element={
              <PublicRoute>
                <Register />
              </PublicRoute>
            }
          />

          {/* Citizen routes */}
          <Route
            path="/citizen/dashboard"
            element={
              <ProtectedRoute allowedRoles={['citizen']}>
                <CitizenDashboard user={user} setUser={setUser} />
              </ProtectedRoute>
            }
          />

          {/* Officer/Admin routes */}
          <Route
            path="/officer/dashboard"
            element={
              <ProtectedRoute allowedRoles={['officer', 'admin']}>
                <OfficerDashboard user={user} setUser={setUser} />
              </ProtectedRoute>
            }
          />

          {/* Default route */}
          <Route
            path="/"
            element={
              loading ? (
                <div className="spinner"></div>
              ) : authService.isAuthenticated() ? (
                user?.role === 'citizen' ? (
                  <Navigate to="/citizen/dashboard" />
                ) : (
                  <Navigate to="/officer/dashboard" />
                )
              ) : (
                <Navigate to="/login" />
              )
            }
          />

          {/* 404 route */}
          <Route path="*" element={<Navigate to="/" />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
