/**
 * Citizen Dashboard
 * Main dashboard for citizens to submit complaints, view status, and search
 */

import React, { useState, useEffect } from 'react';
import { authService, complaintService, dashboardService, announcementService } from '../services/api';
import Navbar from '../components/Navbar';
import ComplaintForm from '../components/ComplaintForm';
import SearchBar from '../components/SearchBar';
import ComplaintList from '../components/ComplaintList';
import AnnouncementList from '../components/AnnouncementList';
import StatsCards from '../components/StatsCards';

function CitizenDashboard({ user, setUser }) {
  const [dashboardData, setDashboardData] = useState(null);
  const [announcements, setAnnouncements] = useState([]);
  const [searchResults, setSearchResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview'); // overview, submit, search

  // Fetch dashboard data on mount
  useEffect(() => {
    fetchDashboardData();
    fetchAnnouncements();
  }, []);

  const fetchDashboardData = async () => {
    try {
      const data = await dashboardService.getDashboardData();
      setDashboardData(data);
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchAnnouncements = async () => {
    try {
      const data = await announcementService.getAnnouncements(user.ward, 5);
      setAnnouncements(data.announcements);
    } catch (error) {
      console.error('Error fetching announcements:', error);
    }
  };

  // Handle complaint submission success
  const handleComplaintSubmitted = () => {
    fetchDashboardData(); // Refresh data
    setActiveTab('overview'); // Switch to overview tab
  };

  // Handle search
  const handleSearch = async (query) => {
    try {
      const results = await complaintService.searchComplaints(query, user.ward);
      setSearchResults(results.results || []);
    } catch (error) {
      console.error('Error searching complaints:', error);
    }
  };

  if (loading) {
    return <div className="spinner"></div>;
  }

  // Calculate stats
  const stats = dashboardData?.my_complaints_by_status || {};
  const totalComplaints = Object.values(stats).reduce((sum, count) => sum + count, 0);

  return (
    <div>
      <Navbar user={user} setUser={setUser} />
      
      <div className="container" style={{ paddingTop: '2rem', paddingBottom: '2rem' }}>
        <h1 style={{ fontSize: '2rem', fontWeight: 'bold', marginBottom: '1rem' }}>
          Welcome, {user.name}!
        </h1>
        <p className="text-gray mb-4">Ward: {user.ward}</p>

        {/* Tab Navigation */}
        <div style={{ marginBottom: '2rem', borderBottom: '2px solid #e5e7eb' }}>
          <div style={{ display: 'flex', gap: '1rem' }}>
            <button
              onClick={() => setActiveTab('overview')}
              style={{
                padding: '0.75rem 1.5rem',
                border: 'none',
                background: 'none',
                cursor: 'pointer',
                fontWeight: 500,
                borderBottom: activeTab === 'overview' ? '2px solid #3b82f6' : 'none',
                color: activeTab === 'overview' ? '#3b82f6' : '#6b7280',
              }}
            >
              📊 Overview
            </button>
            <button
              onClick={() => setActiveTab('submit')}
              style={{
                padding: '0.75rem 1.5rem',
                border: 'none',
                background: 'none',
                cursor: 'pointer',
                fontWeight: 500,
                borderBottom: activeTab === 'submit' ? '2px solid #3b82f6' : 'none',
                color: activeTab === 'submit' ? '#3b82f6' : '#6b7280',
              }}
            >
              ✍️ Submit Complaint
            </button>
            <button
              onClick={() => setActiveTab('search')}
              style={{
                padding: '0.75rem 1.5rem',
                border: 'none',
                background: 'none',
                cursor: 'pointer',
                fontWeight: 500,
                borderBottom: activeTab === 'search' ? '2px solid #3b82f6' : 'none',
                color: activeTab === 'search' ? '#3b82f6' : '#6b7280',
              }}
            >
              🔍 AI Search
            </button>
          </div>
        </div>

        {/* Overview Tab */}
        {activeTab === 'overview' && (
          <>
            {/* Stats Cards */}
            <StatsCards
              stats={[
                { label: 'Total Complaints', value: totalComplaints, color: '#3b82f6' },
                { label: 'Pending', value: stats.pending || 0, color: '#f59e0b' },
                { label: 'In Progress', value: stats.in_progress || 0, color: '#3b82f6' },
                { label: 'Resolved', value: stats.resolved || 0, color: '#10b981' },
              ]}
            />

            {/* Recent Complaints */}
            <div className="card">
              <h2 className="card-title">My Recent Complaints</h2>
              <ComplaintList complaints={dashboardData?.recent_complaints || []} />
            </div>

            {/* Announcements */}
            <div className="card">
              <h2 className="card-title">📢 Latest Announcements</h2>
              <AnnouncementList announcements={announcements} />
            </div>
          </>
        )}

        {/* Submit Complaint Tab */}
        {activeTab === 'submit' && (
          <div className="card">
            <h2 className="card-title">Submit New Complaint</h2>
            <ComplaintForm
              userWard={user.ward}
              onSuccess={handleComplaintSubmitted}
            />
          </div>
        )}

        {/* Search Tab */}
        {activeTab === 'search' && (
          <>
            <div className="card">
              <h2 className="card-title">🤖 AI-Powered Semantic Search</h2>
              <p className="text-sm text-gray mb-3">
                Search using natural language. Our AI understands meaning, not just keywords.
                Try: "water problem in my area" or "broken street lights"
              </p>
              <SearchBar onSearch={handleSearch} />
            </div>

            {searchResults.length > 0 && (
              <div className="card">
                <h2 className="card-title">Search Results</h2>
                <div>
                  {searchResults.map((result) => (
                    <div key={result.id} className="similar-item">
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                        <div style={{ flex: 1 }}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.5rem' }}>
                            <span className={`badge badge-${result.status.replace('_', '-')}`}>
                              {result.status.replace('_', ' ').toUpperCase()}
                            </span>
                            <span className="text-sm text-gray">{result.category}</span>
                            <span className="similarity-score">
                              {(result.relevance_score * 100).toFixed(0)}% match
                            </span>
                          </div>
                          <p>{result.description}</p>
                          <p className="text-sm text-gray mt-1">
                            {result.ward} • {new Date(result.date).toLocaleDateString()}
                          </p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

export default CitizenDashboard;
