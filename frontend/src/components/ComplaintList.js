/**
 * Complaint List Component
 * Display list of complaints with optional status update
 */

import React from 'react';

function ComplaintList({ complaints, showCitizenName = false, onStatusUpdate = null, canUpdateStatus = false }) {
  if (!complaints || complaints.length === 0) {
    return (
      <p className="text-gray text-center" style={{ padding: '2rem' }}>
        No complaints found
      </p>
    );
  }

  return (
    <div className="table-container" style={{ overflowX: 'auto' }}>
      <table className="table">
        <thead>
          <tr>
            <th>ID</th>
            {showCitizenName && <th>Citizen</th>}
            <th>Ward</th>
            <th>Category</th>
            <th>Description</th>
            <th>Status</th>
            <th>Date</th>
            {canUpdateStatus && <th>Action</th>}
          </tr>
        </thead>
        <tbody>
          {complaints.map((complaint) => (
            <tr key={complaint.id}>
              <td>{complaint.id}</td>
              {showCitizenName && <td>{complaint.citizen_name}</td>}
              <td>{complaint.ward || '-'}</td>
              <td>{complaint.category}</td>
              <td style={{ maxWidth: '300px' }}>
                {complaint.description.substring(0, 100)}
                {complaint.description.length > 100 ? '...' : ''}
              </td>
              <td>
                <span className={`badge badge-${complaint.status.replace('_', '-')}`}>
                  {complaint.status.replace('_', ' ').toUpperCase()}
                </span>
              </td>
              <td>{new Date(complaint.date).toLocaleDateString()}</td>
              {canUpdateStatus && (
                <td>
                  <select
                    value={complaint.status}
                    onChange={(e) => onStatusUpdate(complaint.id, e.target.value)}
                    className="form-select"
                    style={{ minWidth: '120px', fontSize: '0.875rem', padding: '0.375rem' }}
                  >
                    <option value="pending">Pending</option>
                    <option value="in_progress">In Progress</option>
                    <option value="resolved">Resolved</option>
                    <option value="rejected">Rejected</option>
                  </select>
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default ComplaintList;
