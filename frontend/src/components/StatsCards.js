/**
 * Stats Cards Component
 * Display statistics in card format
 */

import React from 'react';

function StatsCards({ stats }) {
  return (
    <div className="stats-grid">
      {stats.map((stat, index) => (
        <div
          key={index}
          className="stat-card"
          style={{
            background: `linear-gradient(135deg, ${stat.color} 0%, ${adjustColor(stat.color, -20)} 100%)`,
          }}
        >
          <div className="stat-label">{stat.label}</div>
          <div className="stat-value">{stat.value}</div>
        </div>
      ))}
    </div>
  );
}

// Helper function to darken color for gradient
function adjustColor(color, percent) {
  const num = parseInt(color.replace('#', ''), 16);
  const amt = Math.round(2.55 * percent);
  const R = (num >> 16) + amt;
  const G = ((num >> 8) & 0x00ff) + amt;
  const B = (num & 0x0000ff) + amt;
  return (
    '#' +
    (
      0x1000000 +
      (R < 255 ? (R < 1 ? 0 : R) : 255) * 0x10000 +
      (G < 255 ? (G < 1 ? 0 : G) : 255) * 0x100 +
      (B < 255 ? (B < 1 ? 0 : B) : 255)
    )
      .toString(16)
      .slice(1)
  );
}

export default StatsCards;
