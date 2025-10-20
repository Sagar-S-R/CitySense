/**
 * Login Page
 * Handles user authentication
 */

import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { authService } from '../services/api';

function Login({ setUser }) {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  // Handle form input changes
  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const response = await authService.login(formData);
      setUser(response.user);

      // Redirect based on role
      if (response.user.role === 'citizen') {
        navigate('/citizen/dashboard');
      } else {
        navigate('/officer/dashboard');
      }
    } catch (err) {
      // Handle different error formats
      let errorMessage = 'Login failed. Please try again.';
      
      if (err.response?.data?.detail) {
        // FastAPI validation errors can be an array of objects
        if (Array.isArray(err.response.data.detail)) {
          errorMessage = err.response.data.detail
            .map(e => e.msg || JSON.stringify(e))
            .join(', ');
        } else if (typeof err.response.data.detail === 'string') {
          errorMessage = err.response.data.detail;
        } else {
          errorMessage = JSON.stringify(err.response.data.detail);
        }
      }
      
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        <h1 className="auth-title">CitySense Login</h1>

        {error && (
          <div className="alert alert-error">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label className="form-label">Email</label>
            <input
              type="email"
              name="email"
              className="form-input"
              value={formData.email}
              onChange={handleChange}
              required
              placeholder="your@email.com"
            />
          </div>

          <div className="form-group">
            <label className="form-label">Password</label>
            <input
              type="password"
              name="password"
              className="form-input"
              value={formData.password}
              onChange={handleChange}
              required
              placeholder="Enter your password"
            />
          </div>

          <button
            type="submit"
            className="btn btn-primary w-full"
            disabled={loading}
          >
            {loading ? 'Logging in...' : 'Login'}
          </button>
        </form>

        <p className="text-center mt-3 text-sm">
          Don't have an account?{' '}
          <Link to="/register" style={{ color: '#3b82f6', fontWeight: 500 }}>
            Register here
          </Link>
        </p>

        <div className="mt-4 p-4" style={{ backgroundColor: '#f3f4f6', borderRadius: '0.375rem' }}>
          <p className="text-sm text-gray mb-2"><strong>Demo Accounts:</strong></p>
          <p className="text-sm">Citizen: rajesh@email.com / password123</p>
          <p className="text-sm">Officer: officer1@city.gov / password123</p>
          <p className="text-sm">Admin: admin@city.gov / password123</p>
        </div>
      </div>
    </div>
  );
}

export default Login;
