-- ============================================================================================================
-- SMARTCITY INSIGHTHUB - COMPREHENSIVE BANGALORE DATABASE SCHEMA
-- PostgreSQL 17 + pgvector for AI-powered semantic search across all city domains
-- ============================================================================================================

-- Enable pgvector extension for AI embeddings
CREATE EXTENSION IF NOT EXISTS vector;

-- ============================================================================================================
-- 1. CORE: CITIZENS & AUTHENTICATION
-- ============================================================================================================

CREATE TABLE IF NOT EXISTS Citizens (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    ward_number INTEGER,
    zone VARCHAR(50),
    address TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'citizen', -- citizen, officer, admin
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

CREATE INDEX idx_citizens_email ON Citizens(email);
CREATE INDEX idx_citizens_ward ON Citizens(ward_number);
CREATE INDEX idx_citizens_zone ON Citizens(zone);

-- ============================================================================================================
-- 2. WARD & ZONE MANAGEMENT
-- ============================================================================================================

CREATE TABLE IF NOT EXISTS Wards (
    ward_number INTEGER PRIMARY KEY,
    ward_name VARCHAR(100) NOT NULL,
    zone VARCHAR(50) NOT NULL,
    major_areas TEXT[], -- Array of major areas/localities
    population INTEGER,
    area_sq_km DECIMAL(10, 2),
    corporation VARCHAR(50)
);

CREATE INDEX idx_wards_zone ON Wards(zone);
CREATE INDEX idx_wards_name ON Wards(ward_name);

-- ============================================================================================================
-- 3. INFRASTRUCTURE
-- ============================================================================================================

-- Roads & Streets
CREATE TABLE IF NOT EXISTS Roads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    road_type VARCHAR(50), -- Highway, Main Road, Inner Road
    surface_type VARCHAR(50), -- Asphalt, Concrete, Gravel
    construction_year INTEGER,
    last_maintenance_date DATE,
    condition_rating VARCHAR(20), -- Excellent, Good, Fair, Poor, Critical
    lane_count INTEGER,
    speed_limit INTEGER,
    length_km DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_roads_ward ON Roads(ward_number);
CREATE INDEX idx_roads_condition ON Roads(condition_rating);
CREATE INDEX idx_roads_embedding ON Roads USING hnsw (embedding vector_cosine_ops);

-- Bridges & Flyovers
CREATE TABLE IF NOT EXISTS Bridges (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    bridge_type VARCHAR(50), -- Flyover, Underpass, Bridge
    span_length_m DECIMAL(10, 2),
    material VARCHAR(50), -- Steel, Concrete, Composite
    built_year INTEGER,
    last_inspection_date DATE,
    status VARCHAR(20), -- Operational, Under Maintenance, Closed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_bridges_ward ON Bridges(ward_number);
CREATE INDEX idx_bridges_embedding ON Bridges USING hnsw (embedding vector_cosine_ops);

-- Public Facilities (Schools, Hospitals, Libraries, etc.)
CREATE TABLE IF NOT EXISTS PublicFacilities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    facility_type VARCHAR(50), -- School, Hospital, Library, Park, Community Center
    address TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    capacity INTEGER,
    opening_date DATE,
    operating_hours VARCHAR(50),
    status VARCHAR(20), -- Operational, Under Construction, Closed
    contact_phone VARCHAR(15),
    contact_email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_facilities_type ON PublicFacilities(facility_type);
CREATE INDEX idx_facilities_ward ON PublicFacilities(ward_number);
CREATE INDEX idx_facilities_embedding ON PublicFacilities USING hnsw (embedding vector_cosine_ops);

-- Street Lights
CREATE TABLE IF NOT EXISTS StreetLights (
    id SERIAL PRIMARY KEY,
    location TEXT NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    light_type VARCHAR(50), -- LED, Sodium Vapor, Halogen
    installation_date DATE,
    status VARCHAR(20), -- Working, Faulty, Under Repair
    last_maintenance_date DATE,
    wattage INTEGER,
    smart_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_lights_ward ON StreetLights(ward_number);
CREATE INDEX idx_lights_status ON StreetLights(status);

-- ============================================================================================================
-- 4. TRANSPORTATION & MOBILITY
-- ============================================================================================================

-- Public Transport Routes
CREATE TABLE IF NOT EXISTS TransportRoutes (
    id SERIAL PRIMARY KEY,
    route_number VARCHAR(50) NOT NULL,
    route_name VARCHAR(200),
    route_type VARCHAR(50), -- Bus, Metro, Train
    start_point VARCHAR(200),
    end_point VARCHAR(200),
    stops TEXT[], -- Array of stop names
    frequency_minutes INTEGER,
    operational_hours VARCHAR(50),
    fare_base DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_routes_type ON TransportRoutes(route_type);
CREATE INDEX idx_routes_embedding ON TransportRoutes USING hnsw (embedding vector_cosine_ops);

-- Metro Stations
CREATE TABLE IF NOT EXISTS MetroStations (
    id SERIAL PRIMARY KEY,
    station_name VARCHAR(200) NOT NULL,
    metro_line VARCHAR(50), -- Purple Line, Green Line, Pink Line
    ward_number INTEGER REFERENCES Wards(ward_number),
    opening_date DATE,
    platform_count INTEGER,
    daily_footfall INTEGER,
    facilities TEXT[], -- Parking, Restrooms, ATM, etc.
    status VARCHAR(20), -- Operational, Under Construction
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_metro_line ON MetroStations(metro_line);
CREATE INDEX idx_metro_ward ON MetroStations(ward_number);

-- Parking Locations
CREATE TABLE IF NOT EXISTS ParkingLocations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    parking_type VARCHAR(50), -- Multi-level, On-street, Mall Parking
    total_capacity INTEGER,
    available_spots INTEGER,
    rate_per_hour DECIMAL(10, 2),
    operating_hours VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_parking_ward ON ParkingLocations(ward_number);

-- Traffic Data (Real-time/Historical)
CREATE TABLE IF NOT EXISTS TrafficData (
    id SERIAL PRIMARY KEY,
    location TEXT NOT NULL,
    road_id INTEGER REFERENCES Roads(id),
    ward_number INTEGER REFERENCES Wards(ward_number),
    timestamp TIMESTAMP NOT NULL,
    vehicle_count INTEGER,
    avg_speed_kmph DECIMAL(5, 2),
    congestion_level VARCHAR(20), -- Low, Moderate, High, Severe
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_traffic_timestamp ON TrafficData(timestamp DESC);
CREATE INDEX idx_traffic_ward ON TrafficData(ward_number);

-- ============================================================================================================
-- 5. UTILITIES & SERVICES
-- ============================================================================================================

-- Electricity Infrastructure
CREATE TABLE IF NOT EXISTS ElectricitySubstations (
    id SERIAL PRIMARY KEY,
    substation_name VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    voltage_kv INTEGER,
    capacity_mva INTEGER,
    areas_served TEXT[],
    installation_year INTEGER,
    last_maintenance_date DATE,
    status VARCHAR(20), -- Operational, Under Maintenance
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_electricity_ward ON ElectricitySubstations(ward_number);

-- Power Outages (Citizen-reported & Official)
CREATE TABLE IF NOT EXISTS PowerOutages (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    location TEXT NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    outage_start TIMESTAMP,
    outage_end TIMESTAMP,
    duration_minutes INTEGER,
    affected_area TEXT,
    cause TEXT,
    status VARCHAR(20), -- Reported, Acknowledged, Resolved
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_outages_ward ON PowerOutages(ward_number);
CREATE INDEX idx_outages_status ON PowerOutages(status);
CREATE INDEX idx_outages_embedding ON PowerOutages USING hnsw (embedding vector_cosine_ops);

-- Water Supply
CREATE TABLE IF NOT EXISTS WaterSupply (
    id SERIAL PRIMARY KEY,
    area_name VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    water_source VARCHAR(100), -- Cauvery, Groundwater, Borewell
    supply_schedule VARCHAR(200),
    quality_index DECIMAL(5, 2), -- 0-100 scale
    last_quality_check DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_water_ward ON WaterSupply(ward_number);

-- Water Issues (Citizen-reported)
CREATE TABLE IF NOT EXISTS WaterIssues (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    location TEXT NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    issue_type VARCHAR(100), -- No Supply, Low Pressure, Contamination, Leakage
    description TEXT,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    status VARCHAR(20), -- Reported, In Progress, Resolved
    embedding VECTOR(384)
);

CREATE INDEX idx_water_issues_ward ON WaterIssues(ward_number);
CREATE INDEX idx_water_issues_status ON WaterIssues(status);
CREATE INDEX idx_water_issues_embedding ON WaterIssues USING hnsw (embedding vector_cosine_ops);

-- Waste Management
CREATE TABLE IF NOT EXISTS WasteCollection (
    id SERIAL PRIMARY KEY,
    zone_name VARCHAR(100) NOT NULL,
    ward_numbers INTEGER[],
    collection_schedule VARCHAR(200),
    collection_type VARCHAR(50), -- Wet, Dry, E-waste, Bulk
    vehicle_count INTEGER,
    coverage_area_sq_km DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Garbage Complaints (Citizen-reported)
CREATE TABLE IF NOT EXISTS GarbageComplaints (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    location TEXT NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    complaint_type VARCHAR(100), -- Missed Collection, Illegal Dump, Overflowing Bin
    description TEXT,
    photo_url TEXT,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    status VARCHAR(20),
    embedding VECTOR(384)
);

CREATE INDEX idx_garbage_ward ON GarbageComplaints(ward_number);
CREATE INDEX idx_garbage_status ON GarbageComplaints(status);
CREATE INDEX idx_garbage_embedding ON GarbageComplaints USING hnsw (embedding vector_cosine_ops);

-- ============================================================================================================
-- 6. ENVIRONMENT & SUSTAINABILITY
-- ============================================================================================================

-- Parks & Green Spaces
CREATE TABLE IF NOT EXISTS Parks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    area_acres DECIMAL(10, 2),
    park_type VARCHAR(50), -- Botanical Garden, Public Park, National Park
    facilities TEXT[], -- Playground, Walking Track, Lake, etc.
    tree_count INTEGER,
    opening_hours VARCHAR(50),
    entry_fee DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_parks_ward ON Parks(ward_number);
CREATE INDEX idx_parks_embedding ON Parks USING hnsw (embedding vector_cosine_ops);

-- Air Quality Monitoring
CREATE TABLE IF NOT EXISTS AirQualityData (
    id SERIAL PRIMARY KEY,
    location VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    timestamp TIMESTAMP NOT NULL,
    pm2_5 DECIMAL(10, 2), -- µg/m³
    pm10 DECIMAL(10, 2),
    ozone DECIMAL(10, 2),
    no2 DECIMAL(10, 2),
    so2 DECIMAL(10, 2),
    aqi INTEGER, -- Air Quality Index
    aqi_category VARCHAR(50), -- Good, Moderate, Unhealthy, Hazardous
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_air_ward ON AirQualityData(ward_number);
CREATE INDEX idx_air_timestamp ON AirQualityData(timestamp DESC);

-- Tree Census (Citizen-contributed)
CREATE TABLE IF NOT EXISTS Trees (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    tree_species VARCHAR(100),
    tree_height_m DECIMAL(5, 2),
    tree_age_years INTEGER,
    health_status VARCHAR(50), -- Healthy, Diseased, Dead, Needs Pruning
    photo_url TEXT,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_trees_ward ON Trees(ward_number);
CREATE INDEX idx_trees_embedding ON Trees USING hnsw (embedding vector_cosine_ops);

-- ============================================================================================================
-- 7. GOVERNANCE & CITIZEN SERVICES
-- ============================================================================================================

-- Complaints (Enhanced from original)
CREATE TABLE IF NOT EXISTS Complaints (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Citizens(id) ON DELETE CASCADE,
    ward_number INTEGER REFERENCES Wards(ward_number),
    category VARCHAR(100) NOT NULL, -- Street Light, Garbage, Water, Roads, etc.
    sub_category VARCHAR(100),
    description TEXT NOT NULL,
    location TEXT,
    photo_url TEXT,
    priority VARCHAR(20) DEFAULT 'medium', -- low, medium, high, critical
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, in_progress, resolved, rejected
    assigned_officer_id INTEGER REFERENCES Citizens(id),
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    resolution_notes TEXT,
    citizen_rating INTEGER, -- 1-5 stars
    embedding VECTOR(384)
);

CREATE INDEX idx_complaints_ward ON Complaints(ward_number);
CREATE INDEX idx_complaints_status ON Complaints(status);
CREATE INDEX idx_complaints_category ON Complaints(category);
CREATE INDEX idx_complaints_date ON Complaints(date DESC);
CREATE INDEX idx_complaints_user ON Complaints(user_id);
CREATE INDEX idx_complaints_embedding ON Complaints USING hnsw (embedding vector_cosine_ops);

-- Reports (Officer-submitted)
CREATE TABLE IF NOT EXISTS Reports (
    id SERIAL PRIMARY KEY,
    officer_id INTEGER NOT NULL REFERENCES Citizens(id) ON DELETE CASCADE,
    ward_number INTEGER REFERENCES Wards(ward_number),
    report_type VARCHAR(100), -- Inspection, Audit, Survey, Field Visit
    title VARCHAR(200) NOT NULL,
    report_text TEXT NOT NULL,
    document_url TEXT,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_reports_ward ON Reports(ward_number);
CREATE INDEX idx_reports_date ON Reports(date DESC);
CREATE INDEX idx_reports_embedding ON Reports USING hnsw (embedding vector_cosine_ops);

-- Announcements
CREATE TABLE IF NOT EXISTS Announcements (
    id SERIAL PRIMARY KEY,
    ward_number INTEGER REFERENCES Wards(ward_number), -- NULL means city-wide
    zone VARCHAR(50),
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    announcement_type VARCHAR(50), -- Notice, Event, Alert, News
    valid_from DATE,
    valid_to DATE,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_announcements_ward ON Announcements(ward_number);
CREATE INDEX idx_announcements_zone ON Announcements(zone);
CREATE INDEX idx_announcements_date ON Announcements(date DESC);
CREATE INDEX idx_announcements_embedding ON Announcements USING hnsw (embedding vector_cosine_ops);

-- Permits & Licenses
CREATE TABLE IF NOT EXISTS Permits (
    id SERIAL PRIMARY KEY,
    applicant_id INTEGER REFERENCES Citizens(id),
    permit_type VARCHAR(100), -- Building, Trade License, Event, Construction
    application_date DATE NOT NULL,
    approval_date DATE,
    expiry_date DATE,
    ward_number INTEGER REFERENCES Wards(ward_number),
    status VARCHAR(20), -- Pending, Approved, Rejected, Expired
    document_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_permits_applicant ON Permits(applicant_id);
CREATE INDEX idx_permits_ward ON Permits(ward_number);
CREATE INDEX idx_permits_status ON Permits(status);

-- ============================================================================================================
-- 8. SAFETY & SECURITY
-- ============================================================================================================

-- Police Stations
CREATE TABLE IF NOT EXISTS PoliceStations (
    id SERIAL PRIMARY KEY,
    station_name VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    jurisdiction TEXT[],
    address TEXT,
    phone VARCHAR(15),
    email VARCHAR(100),
    officer_in_charge VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_police_ward ON PoliceStations(ward_number);

-- Crime Incidents (Citizen-reported, anonymized)
CREATE TABLE IF NOT EXISTS CrimeIncidents (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    location TEXT NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    incident_type VARCHAR(100), -- Theft, Assault, Vandalism, Traffic Accident
    description TEXT,
    incident_timestamp TIMESTAMP,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20), -- Reported, Under Investigation, Resolved
    embedding VECTOR(384)
);

CREATE INDEX idx_crime_ward ON CrimeIncidents(ward_number);
CREATE INDEX idx_crime_status ON CrimeIncidents(status);
CREATE INDEX idx_crime_embedding ON CrimeIncidents USING hnsw (embedding vector_cosine_ops);

-- Fire Stations
CREATE TABLE IF NOT EXISTS FireStations (
    id SERIAL PRIMARY KEY,
    station_name VARCHAR(200) NOT NULL,
    coverage_wards INTEGER[],
    address TEXT,
    phone VARCHAR(15),
    vehicle_count INTEGER,
    avg_response_time_minutes INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Emergency Incidents (Citizen-reported)
CREATE TABLE IF NOT EXISTS EmergencyIncidents (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    incident_type VARCHAR(100), -- Fire, Medical, Accident, Natural Disaster
    location TEXT NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    description TEXT,
    severity VARCHAR(20), -- Low, Medium, High, Critical
    incident_timestamp TIMESTAMP,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_time_minutes INTEGER,
    status VARCHAR(20), -- Reported, Responded, Resolved
    embedding VECTOR(384)
);

CREATE INDEX idx_emergency_ward ON EmergencyIncidents(ward_number);
CREATE INDEX idx_emergency_status ON EmergencyIncidents(status);
CREATE INDEX idx_emergency_embedding ON EmergencyIncidents USING hnsw (embedding vector_cosine_ops);

-- ============================================================================================================
-- 9. ECONOMY & SOCIAL INDICATORS
-- ============================================================================================================

-- Commercial Areas & Markets
CREATE TABLE IF NOT EXISTS CommercialAreas (
    id SERIAL PRIMARY KEY,
    area_name VARCHAR(200) NOT NULL,
    ward_number INTEGER REFERENCES Wards(ward_number),
    area_type VARCHAR(50), -- Market, Shopping Complex, Business District
    total_businesses INTEGER,
    major_industries TEXT[],
    avg_footfall_daily INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_commercial_ward ON CommercialAreas(ward_number);

-- Businesses (Citizen-contributed)
CREATE TABLE IF NOT EXISTS Businesses (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    business_name VARCHAR(200) NOT NULL,
    business_type VARCHAR(100),
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    registration_date DATE,
    employee_count INTEGER,
    phone VARCHAR(15),
    email VARCHAR(100),
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_businesses_ward ON Businesses(ward_number);
CREATE INDEX idx_businesses_type ON Businesses(business_type);
CREATE INDEX idx_businesses_embedding ON Businesses USING hnsw (embedding vector_cosine_ops);

-- Schools & Colleges
CREATE TABLE IF NOT EXISTS EducationalInstitutions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    institution_type VARCHAR(50), -- School, College, University, Training Center
    ward_number INTEGER REFERENCES Wards(ward_number),
    address TEXT,
    enrollment_count INTEGER,
    teacher_count INTEGER,
    established_year INTEGER,
    affiliation VARCHAR(100),
    phone VARCHAR(15),
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_education_ward ON EducationalInstitutions(ward_number);
CREATE INDEX idx_education_type ON EducationalInstitutions(institution_type);
CREATE INDEX idx_education_embedding ON EducationalInstitutions USING hnsw (embedding vector_cosine_ops);

-- Hospitals & Clinics
CREATE TABLE IF NOT EXISTS HealthcareFacilities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    facility_type VARCHAR(50), -- Hospital, Clinic, Dispensary, Health Center
    ward_number INTEGER REFERENCES Wards(ward_number),
    address TEXT,
    bed_count INTEGER,
    staff_count INTEGER,
    specialties TEXT[],
    emergency_services BOOLEAN DEFAULT FALSE,
    phone VARCHAR(15),
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_healthcare_ward ON HealthcareFacilities(ward_number);
CREATE INDEX idx_healthcare_type ON HealthcareFacilities(facility_type);
CREATE INDEX idx_healthcare_embedding ON HealthcareFacilities USING hnsw (embedding vector_cosine_ops);

-- ============================================================================================================
-- 10. CONSTRUCTION & URBAN DEVELOPMENT
-- ============================================================================================================

-- Construction Projects (Citizen-contributed & Official)
CREATE TABLE IF NOT EXISTS ConstructionProjects (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    project_name VARCHAR(200),
    project_type VARCHAR(100), -- Residential, Commercial, Infrastructure, Public Facility
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    contractor_name VARCHAR(200),
    start_date DATE,
    expected_end_date DATE,
    actual_end_date DATE,
    budget DECIMAL(15, 2),
    status VARCHAR(20), -- Planned, In Progress, Completed, Delayed, Abandoned
    description TEXT,
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_construction_ward ON ConstructionProjects(ward_number);
CREATE INDEX idx_construction_status ON ConstructionProjects(status);
CREATE INDEX idx_construction_embedding ON ConstructionProjects USING hnsw (embedding vector_cosine_ops);

-- Construction Complaints (Citizen-reported: noise, dust, safety issues)
CREATE TABLE IF NOT EXISTS ConstructionComplaints (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES Citizens(id),
    project_id INTEGER REFERENCES ConstructionProjects(id),
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    complaint_type VARCHAR(100), -- Noise, Dust, Safety Hazard, Unauthorized Construction
    description TEXT,
    photo_url TEXT,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    status VARCHAR(20),
    embedding VECTOR(384)
);

CREATE INDEX idx_construction_complaints_ward ON ConstructionComplaints(ward_number);
CREATE INDEX idx_construction_complaints_status ON ConstructionComplaints(status);
CREATE INDEX idx_construction_complaints_embedding ON ConstructionComplaints USING hnsw (embedding vector_cosine_ops);

-- ============================================================================================================
-- 11. CITIZEN CONTRIBUTIONS & FEEDBACK
-- ============================================================================================================

-- Citizen Feedback on Services
CREATE TABLE IF NOT EXISTS CitizenFeedback (
    id SERIAL PRIMARY KEY,
    citizen_id INTEGER REFERENCES Citizens(id),
    service_type VARCHAR(100), -- Water, Electricity, Garbage, Transport, etc.
    ward_number INTEGER REFERENCES Wards(ward_number),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    feedback_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_feedback_ward ON CitizenFeedback(ward_number);
CREATE INDEX idx_feedback_service ON CitizenFeedback(service_type);
CREATE INDEX idx_feedback_embedding ON CitizenFeedback USING hnsw (embedding vector_cosine_ops);

-- Community Events (Citizen-contributed)
CREATE TABLE IF NOT EXISTS CommunityEvents (
    id SERIAL PRIMARY KEY,
    organizer_id INTEGER REFERENCES Citizens(id),
    event_name VARCHAR(200) NOT NULL,
    event_type VARCHAR(100), -- Cultural, Sports, Social, Educational
    location TEXT,
    ward_number INTEGER REFERENCES Wards(ward_number),
    event_date DATE,
    event_time VARCHAR(50),
    description TEXT,
    expected_attendees INTEGER,
    contact_phone VARCHAR(15),
    photo_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    embedding VECTOR(384)
);

CREATE INDEX idx_events_ward ON CommunityEvents(ward_number);
CREATE INDEX idx_events_date ON CommunityEvents(event_date);
CREATE INDEX idx_events_embedding ON CommunityEvents USING hnsw (embedding vector_cosine_ops);

-- ============================================================================================================
-- 12. ANALYTICS & TRIGGERS
-- ============================================================================================================

-- Function to automatically update resolved_at timestamp
CREATE OR REPLACE FUNCTION update_resolved_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status IN ('resolved', 'Resolved') AND OLD.status != NEW.status THEN
        NEW.resolved_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all complaint-type tables
CREATE TRIGGER trg_complaints_resolved
    BEFORE UPDATE ON Complaints
    FOR EACH ROW
    EXECUTE FUNCTION update_resolved_timestamp();

CREATE TRIGGER trg_garbage_resolved
    BEFORE UPDATE ON GarbageComplaints
    FOR EACH ROW
    EXECUTE FUNCTION update_resolved_timestamp();

CREATE TRIGGER trg_water_resolved
    BEFORE UPDATE ON WaterIssues
    FOR EACH ROW
    EXECUTE FUNCTION update_resolved_timestamp();

CREATE TRIGGER trg_construction_complaints_resolved
    BEFORE UPDATE ON ConstructionComplaints
    FOR EACH ROW
    EXECUTE FUNCTION update_resolved_timestamp();

-- ============================================================================================================
-- COMMENTS ON KEY TABLES
-- ============================================================================================================

COMMENT ON TABLE Complaints IS 'Central complaint management with AI embeddings for semantic search';
COMMENT ON TABLE Wards IS 'Bangalore ward/zone mapping with 368 wards across 5 corporations';
COMMENT ON TABLE Roads IS 'Road infrastructure with condition monitoring and citizen reports';
COMMENT ON TABLE PublicFacilities IS 'All public facilities: schools, hospitals, libraries, parks';
COMMENT ON TABLE StreetLights IS 'Street light inventory with status tracking for citizen reports';
COMMENT ON TABLE PowerOutages IS 'Citizen-reported and official power outage tracking';
COMMENT ON TABLE WaterIssues IS 'Water supply complaints with AI-powered duplicate detection';
COMMENT ON TABLE GarbageComplaints IS 'Garbage collection issues reported by citizens';
COMMENT ON TABLE Parks IS 'Green spaces and parks with environmental data';
COMMENT ON TABLE AirQualityData IS 'Real-time air quality monitoring across Bangalore';
COMMENT ON TABLE Trees IS 'Citizen-contributed tree census for urban forestry';
COMMENT ON TABLE ConstructionProjects IS 'Construction and development projects with citizen monitoring';
COMMENT ON TABLE CommunityEvents IS 'Citizen-organized community events and activities';
COMMENT ON TABLE CitizenFeedback IS 'Service quality feedback from citizens';

-- ============================================================================================================
-- END OF SCHEMA
-- ============================================================================================================
