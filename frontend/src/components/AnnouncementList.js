/**
 * Announcement List Component
 * Display list of announcements
 */

import React from 'react';

function AnnouncementList({ announcements }) {
  if (!announcements || announcements.length === 0) {
    return (
      <p className="text-gray text-center" style={{ padding: '2rem' }}>
        No announcements available
      </p>
    );
  }

  return (
    <div>
      {announcements.map((announcement) => (
        <div
          key={announcement.id}
          style={{
            padding: '1rem',
            border: '1px solid #e5e7eb',
            borderRadius: '0.375rem',
            marginBottom: '1rem',
            backgroundColor: '#f9fafb',
          }}
        >
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <h3 style={{ fontSize: '1.125rem', fontWeight: 600, marginBottom: '0.5rem' }}>
              {announcement.title}
            </h3>
            <span className="text-sm text-gray">
              {new Date(announcement.date).toLocaleDateString()}
            </span>
          </div>
          <p className="text-sm text-gray mb-2">{announcement.ward}</p>
          <p>{announcement.body}</p>
        </div>
      ))}
    </div>
  );
}

export default AnnouncementList;
