/**
 * Complaint Form Component
 * Form for submitting new complaints with AI embedding
 */

import React, { useState } from 'react';
import { complaintService } from '../services/api';

function ComplaintForm({ userWard, onSuccess }) {
  const [formData, setFormData] = useState({
    ward: userWard,
    category: 'Water Supply',
    description: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [similarComplaints, setSimilarComplaints] = useState([]);

  const categories = [
    'Water Supply',
    'Electricity',
    'Waste Management',
    'Roads',
    'Health',
    'Parks',
    'Traffic',
    'Other',
  ];

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    setSimilarComplaints([]);

    try {
      const response = await complaintService.submitComplaint(formData);
      
      // Show similar complaints if any
      if (response.similar_complaints && response.similar_complaints.length > 0) {
        setSimilarComplaints(response.similar_complaints);
      }

      // Reset form
      setFormData({
        ward: userWard,
        category: 'Water Supply',
        description: '',
      });

      alert('Complaint submitted successfully!');
      
      if (onSuccess) {
        onSuccess();
      }
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to submit complaint');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      {error && (
        <div className="alert alert-error mb-3">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label className="form-label">Ward</label>
          <input
            type="text"
            name="ward"
            className="form-input"
            value={formData.ward}
            readOnly
            style={{ backgroundColor: '#f3f4f6' }}
          />
        </div>

        <div className="form-group">
          <label className="form-label">Category</label>
          <select
            name="category"
            className="form-select"
            value={formData.category}
            onChange={handleChange}
            required
          >
            {categories.map((cat) => (
              <option key={cat} value={cat}>
                {cat}
              </option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label className="form-label">Description</label>
          <textarea
            name="description"
            className="form-textarea"
            value={formData.description}
            onChange={handleChange}
            required
            placeholder="Describe your complaint in detail..."
            rows="5"
          />
          <p className="text-sm text-gray mt-1">
            Our AI will analyze your complaint and find similar issues automatically
          </p>
        </div>

        <button
          type="submit"
          className="btn btn-primary"
          disabled={loading}
        >
          {loading ? 'Submitting...' : 'Submit Complaint'}
        </button>
      </form>

      {/* Similar Complaints Section */}
      {similarComplaints.length > 0 && (
        <div className="mt-4">
          <h3 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '1rem' }}>
            AI Found Similar Complaints:
          </h3>
          <p className="text-sm text-gray mb-2">
            These complaints have similar meaning to yours (found using semantic search)
          </p>
          {similarComplaints.map((complaint) => (
            <div key={complaint.id} className="similar-item">
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '0.5rem' }}>
                <span className={`badge badge-${complaint.status.replace('_', '-')}`}>
                  {complaint.status.replace('_', ' ').toUpperCase()}
                </span>
                <span className="text-sm text-gray">{complaint.category}</span>
                <span className="similarity-score">
                  {(complaint.similarity_score * 100).toFixed(0)}% similar
                </span>
              </div>
              <p>{complaint.description}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default ComplaintForm;
