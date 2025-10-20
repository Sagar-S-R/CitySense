/**
 * Register Page
 * Handles new user registration
 */

import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { authService } from '../services/api';

function Register() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    ward: 1,
    role: 'citizen',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  // Ward options (1-198 for Bangalore)
  const wards = Array.from({ length: 198 }, (_, i) => i + 1);

  // Handle form input changes
  const handleChange = (e) => {
    const value = e.target.name === 'ward' ? parseInt(e.target.value) : e.target.value;
    setFormData({
      ...formData,
      [e.target.name]: value,
    });
  };

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await authService.register(formData);
      // Redirect to login after successful registration
      navigate('/login');
    } catch (err) {
      // Handle different error formats
      let errorMessage = 'Registration failed. Please try again.';
      
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
        <h1 className="auth-title">Create Account</h1>

        {error && (
          <div className="alert alert-error">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label className="form-label">Full Name</label>
            <input
              type="text"
              name="name"
              className="form-input"
              value={formData.name}
              onChange={handleChange}
              required
              placeholder="Your full name"
            />
          </div>

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
              minLength="6"
              placeholder="Minimum 6 characters"
            />
          </div>

          <div className="form-group">
            <label className="form-label">Ward Number</label>
            <select
              name="ward"
              className="form-select"
              value={formData.ward}
              onChange={handleChange}
              required
            >
              {wards.map((wardNum) => (
                <option key={wardNum} value={wardNum}>
                  Ward {wardNum}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label className="form-label">Role</label>
            <select
              name="role"
              className="form-select"
              value={formData.role}
              onChange={handleChange}
              required
            >
              <option value="citizen">Citizen</option>
              <option value="officer">Officer</option>
            </select>
          </div>

          <button
            type="submit"
            className="btn btn-primary w-full"
            disabled={loading}
          >
            {loading ? 'Creating account...' : 'Register'}
          </button>
        </form>

        <p className="text-center mt-3 text-sm">
          Already have an account?{' '}
          <Link to="/login" style={{ color: '#3b82f6', fontWeight: 500 }}>
            Login here
          </Link>
        </p>
      </div>
    </div>
  );
}

export default Register;
