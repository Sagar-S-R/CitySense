/**
 * Officer Dashboard
 * Dashboard for officers and admins to manage ward complaints and view analytics
 */

import React, { useState, useEffect } from 'react';
import { dashboardService, complaintService } from '../services/api';
import Navbar from '../components/Navbar';
import SearchBar from '../components/SearchBar';
import ComplaintList from '../components/ComplaintList';
import StatsCards from '../components/StatsCards';
import AnalyticsChart from '../components/AnalyticsChart';

function OfficerDashboard({ user, setUser }) {
  const [dashboardData, setDashboardData] = useState(null);
  const [summary, setSummary] = useState(null);
  const [searchResults, setSearchResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview'); // overview, search, analytics

  // Fetch dashboard data on mount
  useEffect(() => {
    fetchDashboardData();
    fetchSummary();
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

  const fetchSummary = async () => {
    try {
      const data = await dashboardService.getSummary();
      setSummary(data.summary);
    } catch (error) {
      console.error('Error fetching summary:', error);
    }
  };

  // Handle search
  const handleSearch = async (query) => {
    try {
      const results = await complaintService.searchComplaints(
        query,
        user.role === 'officer' ? user.ward : null
      );
      setSearchResults(results.results || []);
    } catch (error) {
      console.error('Error searching complaints:', error);
    }
  };

  // Handle status update
  const handleStatusUpdate = async (complaintId, newStatus) => {
    try {
      await complaintService.updateStatus(complaintId, newStatus);
      fetchDashboardData(); // Refresh data
      alert('Status updated successfully!');
    } catch (error) {
      console.error('Error updating status:', error);
      alert('Failed to update status');
    }
  };

  if (loading) {
    return <div className="spinner"></div>;
  }

  // Calculate stats
  const stats = dashboardData?.complaints_by_status || {};
  const totalComplaints = Object.values(stats).reduce((sum, count) => sum + count, 0);

  return (
    <div>
      <Navbar user={user} setUser={setUser} />
      
      <div className="container" style={{ paddingTop: '2rem', paddingBottom: '2rem' }}>
        <h1 style={{ fontSize: '2rem', fontWeight: 'bold', marginBottom: '1rem' }}>
          {user.role === 'admin' ? 'Admin' : 'Officer'} Dashboard
        </h1>
        <p className="text-gray mb-4">
          {user.role === 'admin' ? 'City-wide Overview' : `Ward: ${user.ward}`}
        </p>

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
              Overview
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
              AI Search
            </button>
            <button
              onClick={() => setActiveTab('analytics')}
              style={{
                padding: '0.75rem 1.5rem',
                border: 'none',
                background: 'none',
                cursor: 'pointer',
                fontWeight: 500,
                borderBottom: activeTab === 'analytics' ? '2px solid #3b82f6' : 'none',
                color: activeTab === 'analytics' ? '#3b82f6' : '#6b7280',
              }}
            >
              Analytics
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

            {/* AI Summary */}
            {summary && (
              <div className="card">
                <h2 className="card-title">AI-Generated Summary</h2>
                <div className="grid grid-2">
                  <div>
                    <p className="text-sm text-gray">Total Complaints This Month</p>
                    <p style={{ fontSize: '2rem', fontWeight: 'bold', color: '#3b82f6' }}>
                      {summary.total_complaints_this_month}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-gray">Resolution Rate</p>
                    <p style={{ fontSize: '2rem', fontWeight: 'bold', color: '#10b981' }}>
                      {summary.resolution_rate}%
                    </p>
                  </div>
                </div>
                
                {summary.top_unresolved_issues && summary.top_unresolved_issues.length > 0 && (
                  <div className="mt-3">
                    <p className="text-sm text-gray mb-2">Top Unresolved Issues:</p>
                    <ul style={{ listStyle: 'none', padding: 0 }}>
                      {summary.top_unresolved_issues.map((issue, index) => (
                        <li
                          key={index}
                          style={{
                            padding: '0.5rem',
                            backgroundColor: '#f9fafb',
                            borderRadius: '0.375rem',
                            marginBottom: '0.5rem',
                          }}
                        >
                          <strong>{issue.category}</strong>: {issue.count} complaints
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}

            {/* Recent Complaints with Status Update */}
            <div className="card">
              <h2 className="card-title">Recent Complaints</h2>
              <ComplaintList
                complaints={dashboardData?.recent_complaints || []}
                showCitizenName={true}
                onStatusUpdate={handleStatusUpdate}
                canUpdateStatus={true}
              />
            </div>
          </>
        )}

        {/* Search Tab */}
        {activeTab === 'search' && (
          <>
            <div className="card">
              <h2 className="card-title">AI-Powered Semantic Search</h2>
              <p className="text-sm text-gray mb-3">
                Search using natural language to find similar complaints across your ward.
                Our AI uses embeddings to understand semantic meaning.
              </p>
              <SearchBar onSearch={handleSearch} />
            </div>

            {searchResults.length > 0 && (
              <div className="card">
                <h2 className="card-title">Search Results ({searchResults.length})</h2>
                <div>
                  {searchResults.map((result) => (
                    <div key={result.id} className="similar-item">
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                        <div style={{ flex: 1 }}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.5rem', flexWrap: 'wrap' }}>
                            <span className={`badge badge-${result.status.replace('_', '-')}`}>
                              {result.status.replace('_', ' ').toUpperCase()}
                            </span>
                            <span className="text-sm text-gray">{result.category}</span>
                            <span className="text-sm text-gray">By: {result.citizen_name}</span>
                            <span className="similarity-score">
                              {(result.relevance_score * 100).toFixed(0)}% relevant
                            </span>
                          </div>
                          <p>{result.description}</p>
                          <p className="text-sm text-gray mt-1">
                            {result.ward} • {new Date(result.date).toLocaleDateString()}
                          </p>
                        </div>
                        <div>
                          <select
                            value={result.status}
                            onChange={(e) => handleStatusUpdate(result.id, e.target.value)}
                            className="form-select"
                            style={{ minWidth: '120px' }}
                          >
                            <option value="pending">Pending</option>
                            <option value="in_progress">In Progress</option>
                            <option value="resolved">Resolved</option>
                            <option value="rejected">Rejected</option>
                          </select>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        )}

        {/* Analytics Tab */}
        {activeTab === 'analytics' && (
          <>
            {/* Category Chart */}
            {dashboardData?.complaints_by_category && (
              <div className="card">
                <h2 className="card-title">Complaints by Category</h2>
                <AnalyticsChart
                  type="bar"
                  data={{
                    labels: dashboardData.complaints_by_category.map(c => c.category),
                    datasets: [{
                      label: 'Number of Complaints',
                      data: dashboardData.complaints_by_category.map(c => c.count),
                      backgroundColor: 'rgba(59, 130, 246, 0.5)',
                      borderColor: 'rgba(59, 130, 246, 1)',
                      borderWidth: 1,
                    }],
                  }}
                />
              </div>
            )}

            {/* Status Distribution */}
            <div className="card">
              <h2 className="card-title">Status Distribution</h2>
              <AnalyticsChart
                type="doughnut"
                data={{
                  labels: Object.keys(stats).map(s => s.replace('_', ' ').toUpperCase()),
                  datasets: [{
                    data: Object.values(stats),
                    backgroundColor: [
                      'rgba(251, 191, 36, 0.5)',
                      'rgba(59, 130, 246, 0.5)',
                      'rgba(16, 185, 129, 0.5)',
                      'rgba(239, 68, 68, 0.5)',
                    ],
                    borderColor: [
                      'rgba(251, 191, 36, 1)',
                      'rgba(59, 130, 246, 1)',
                      'rgba(16, 185, 129, 1)',
                      'rgba(239, 68, 68, 1)',
                    ],
                    borderWidth: 1,
                  }],
                }}
              />
            </div>
          </>
        )}
      </div>
    </div>
  );
}

export default OfficerDashboard;
