/**
 * Navbar Component
 * Top navigation bar with user info and logout
 */

import React from 'react';
import { authService } from '../services/api';

function Navbar({ user, setUser }) {
  const handleLogout = () => {
    authService.logout();
    setUser(null);
    window.location.href = '/login';
  };

  return (
    <nav className="navbar">
      <div className="navbar-content">
        <h1 className="navbar-title">CitySense</h1>
        <div className="navbar-user">
          <span style={{ marginRight: '1rem' }}>
            <strong>{user.name}</strong> ({user.role})
          </span>
          <button onClick={handleLogout} className="btn btn-secondary">
            Logout
          </button>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
