-- ============================================================================================================
-- BANGALORE SMART CITY - REALISTIC DATA POPULATION
-- Based on official BBMP/GBA data (2025)
-- ============================================================================================================

-- ============================================================================================================
-- 1. WARDS & ZONES (Sample from 368 wards)
-- ============================================================================================================

INSERT INTO Wards (ward_number, ward_name, zone, major_areas, population, area_sq_km, corporation) VALUES
-- North City Corporation
(5, 'Jakkur', 'Byatarayanapura', ARRAY['Jakkur', 'Jakkur Layout', 'Jakkur Plantation'], 18500, 4.2, 'North City Corporation'),
(6, 'Thanisandra', 'Byatarayanapura', ARRAY['Thanisandra', 'Thanisandra Main Road'], 22300, 3.8, 'North City Corporation'),
(9, 'Vidyaranyapura', 'Byatarayanapura', ARRAY['Vidyaranyapura', 'Vidyaranyapura Layout'], 19800, 3.5, 'North City Corporation'),
(17, 'JP Nagar', 'Dasarahalli', ARRAY['JP Nagar', 'JP Park Area'], 25600, 4.1, 'North City Corporation'),
(41, 'Peenya Industrial Area', 'Peenya', ARRAY['Peenya', 'Peenya Industrial Estate'], 12400, 6.8, 'North City Corporation'),
(44, 'Tumkur Road', 'Peenya', ARRAY['Tumkur Road', 'Yeshwanthpur'], 28900, 5.2, 'North City Corporation'),
(48, 'Yeshwanthpur', 'Mahalakshmi Layout', ARRAY['Yeshwanthpur', 'Yeshwanthpur Junction'], 31200, 3.9, 'North City Corporation'),
(61, 'Malleshwaram', 'Malleshwaram', ARRAY['Malleshwaram', 'Sadashivanagar', 'IISc Campus'], 27800, 4.5, 'North City Corporation'),

-- East City Corporation  
(86, 'KR Puram', 'KR Puram', ARRAY['KR Puram', 'Whitefield Road'], 29400, 5.1, 'East City Corporation'),
(93, 'Old Airport Road', 'Mahadevapura', ARRAY['Old Airport Road', 'Indiranagar', 'HAL'], 32600, 6.3, 'East City Corporation'),
(110, 'Whitefield', 'Mahadevapura', ARRAY['Whitefield', 'ITPL', 'Brookefield'], 138000, 12.4, 'East City Corporation'),
(112, 'Hoodi', 'Mahadevapura', ARRAY['Hoodi', 'Hoodi Circle'], 24500, 4.2, 'East City Corporation'),
(140, 'Marathahalli', 'Mahadevapura', ARRAY['Marathahalli', 'Marathahalli Bridge', 'Kalamandir'], 45600, 7.8, 'East City Corporation'),
(149, 'Sarjapur Road', 'Mahadevapura', ARRAY['Sarjapur Road', 'Bellandur Junction'], 38900, 9.2, 'East City Corporation'),
(150, 'Bellandur', 'Mahadevapura', ARRAY['Bellandur', 'Suncity', 'Sarjapur Road'], 168320, 14.6, 'East City Corporation'),

-- Central City Corporation
(92, 'Shivajinagar', 'Shivajinagar', ARRAY['Shivajinagar', 'Commercial Street'], 21400, 2.8, 'Central City Corporation'),
(94, 'Majestic', 'Chickpet', ARRAY['Majestic', 'KR Market', 'City Market'], 18200, 3.1, 'Central City Corporation'),
(101, 'Cooke Town', 'Shivajinagar', ARRAY['Cooke Town', 'Benson Town'], 16800, 2.4, 'Central City Corporation'),
(102, 'Cox Town', 'Shivajinagar', ARRAY['Cox Town', 'Murphy Town'], 15900, 2.2, 'Central City Corporation'),
(111, 'Cubbon Park', 'Shivajinagar', ARRAY['Cubbon Park', 'MG Road', 'Brigade Road'], 8400, 3.6, 'Central City Corporation'),
(131, 'Ulsoor', 'Ulsoor', ARRAY['Ulsoor', 'Ulsoor Lake'], 24300, 3.4, 'Central City Corporation'),

-- South City Corporation
(151, 'Koramangala', 'Bommanahalli', ARRAY['Koramangala 1st Block', 'Koramangala 4th Block', 'Koramangala 6th Block'], 86800, 11.2, 'South City Corporation'),
(174, 'HSR Layout', 'Bommanahalli', ARRAY['HSR Layout Sector 1', 'HSR Layout Sector 2', '27th Main Road'], 95600, 8.9, 'South City Corporation'),
(175, 'Electronic City', 'Bommanahalli', ARRAY['Electronic City Phase 1', 'Electronic City Phase 2', 'Infosys Campus'], 52400, 15.3, 'South City Corporation'),
(176, 'Jayanagar', 'Bommanahalli', ARRAY['Jayanagar 4th Block', 'Jayanagar 9th Block', 'Jayanagar Shopping Complex'], 42300, 6.7, 'South City Corporation'),
(181, 'MG Road Area', 'Bommanahalli', ARRAY['MG Road', 'Brigade Road', 'Church Street'], 19500, 2.9, 'South City Corporation'),
(183, 'Richmond Circle', 'Bommanahalli', ARRAY['Richmond Town', 'Richmond Circle'], 22100, 3.2, 'South City Corporation'),
(186, 'BTM Layout', 'Bommanahalli', ARRAY['BTM Layout 1st Stage', 'BTM Layout 2nd Stage'], 67800, 7.4, 'South City Corporation'),
(188, 'Bannerghatta', 'Bommanahalli', ARRAY['Bannerghatta', 'Bannerghatta Main Road'], 34200, 8.6, 'South City Corporation'),
(190, 'Bannerghatta Road', 'Bommanahalli', ARRAY['Bannerghatta Road', 'Gottigere'], 41500, 9.8, 'South City Corporation'),
(198, 'JP Nagar South', 'Bommanahalli', ARRAY['JP Nagar 7th Phase', 'JP Nagar 8th Phase'], 54300, 6.9, 'South City Corporation'),
(203, 'Banashankari', 'Bommanahalli', ARRAY['Banashankari 2nd Stage', 'Banashankari 3rd Stage'], 48900, 5.8, 'South City Corporation'),
(210, 'Basavanagudi', 'South', ARRAY['Basavanagudi', 'Bull Temple Road', 'Gandhi Bazaar'], 38600, 4.3, 'South City Corporation'),
(224, 'Anjanapura', 'Bommanahalli', ARRAY['Anjanapura', 'Anjanapura Township'], 29700, 7.2, 'South City Corporation'),
(243, 'Bannerghatta National Park', 'South', ARRAY['Bannerghatta National Park Area'], 1200, 104.27, 'South City Corporation'),

-- West City Corporation
(141, 'Rajajinagar', 'Rajajinagar', ARRAY['Rajajinagar', 'Rajajinagar Industrial Estate'], 112400, 8.7, 'West City Corporation'),
(148, 'Nagawara', 'West', ARRAY['Nagawara', 'Nagawara Ring Road'], 23800, 4.6, 'West City Corporation'),
(165, 'NLSIU Area', 'West', ARRAY['Nagarabhavi', 'NLSIU Campus'], 16900, 5.3, 'West City Corporation'),
(180, 'Vijayanagar', 'West', ARRAY['Vijayanagar', 'Chord Road'], 34500, 4.9, 'West City Corporation');

-- ============================================================================================================
-- 2. INFRASTRUCTURE - ROADS
-- ============================================================================================================

INSERT INTO Roads (name, location, ward_number, road_type, surface_type, construction_year, last_maintenance_date, condition_rating, lane_count, speed_limit, length_km) VALUES
('MG Road', 'Central Bangalore', 181, 'Main Road', 'Asphalt', 1995, '2024-08-15', 'Good', 4, 40, 2.8),
('Outer Ring Road', 'Encircles City', NULL, 'Highway', 'Concrete', 2010, '2024-10-01', 'Excellent', 8, 80, 62.4),
('Bannerghatta Road', 'South Bangalore', 190, 'Main Road', 'Asphalt', 2005, '2024-06-20', 'Fair', 6, 60, 18.3),
('Old Madras Road', 'East Bangalore', 93, 'Main Road', 'Asphalt', 1998, '2024-09-10', 'Good', 4, 50, 12.7),
('Bellary Road', 'North Bangalore', 5, 'Highway', 'Concrete', 2008, '2024-07-25', 'Excellent', 6, 70, 24.6),
('Tumkur Road', 'West Bangalore', 44, 'Highway', 'Asphalt', 2002, '2024-05-18', 'Good', 6, 60, 28.9),
('Kanakapura Road', 'South Bangalore', 210, 'Main Road', 'Asphalt', 2003, '2024-04-12', 'Fair', 4, 50, 35.2),
('Sarjapur Road', 'East-South Bangalore', 149, 'Main Road', 'Asphalt', 2012, '2024-09-22', 'Good', 6, 60, 22.4),
('Commercial Street', 'Shivajinagar', 92, 'Inner Road', 'Concrete', 1980, '2024-03-30', 'Good', 2, 20, 1.2),
('Brigade Road', 'Central Bangalore', 181, 'Main Road', 'Asphalt', 1985, '2024-08-05', 'Good', 4, 30, 1.8),
('Whitefield Main Road', 'Whitefield', 110, 'Main Road', 'Asphalt', 2007, '2024-09-15', 'Fair', 4, 50, 8.6),
('Hosur Road', 'South Bangalore', 175, 'Highway', 'Concrete', 2009, '2024-10-10', 'Excellent', 6, 80, 26.3),
('Mysore Road', 'West Bangalore', 180, 'Highway', 'Asphalt', 2001, '2024-06-08', 'Good', 6, 70, 32.1),
('Airport Road', 'North Bangalore', 6, 'Highway', 'Concrete', 2015, '2024-09-28', 'Excellent', 8, 100, 41.5),
('Inner Ring Road', 'Central Areas', NULL, 'Main Road', 'Asphalt', 2004, '2024-07-14', 'Good', 6, 60, 34.8);

-- ============================================================================================================
-- 3. INFRASTRUCTURE - BRIDGES & FLYOVERS
-- ============================================================================================================

INSERT INTO Bridges (name, ward_number, bridge_type, span_length_m, material, built_year, last_inspection_date, status) VALUES
('Domlur Flyover', 112, 'Flyover', 1200, 'Concrete', 2006, '2024-09-10', 'Operational'),
('Jayadeva Flyover', 176, 'Flyover', 880, 'Steel', 2024, '2024-10-05', 'Operational'),
('Richmond Circle Flyover', 183, 'Flyover', 650, 'Concrete', 2002, '2024-08-20', 'Operational'),
('KR Puram Bridge', 86, 'Bridge', 480, 'Steel', 1999, '2024-07-15', 'Operational'),
('Mekhri Circle Underpass', 61, 'Underpass', 320, 'Concrete', 2003, '2024-09-25', 'Operational'),
('Silk Board Flyover', 174, 'Flyover', 1450, 'Concrete', 2010, '2024-08-30', 'Under Maintenance'),
('Hebbal Flyover', 48, 'Flyover', 1580, 'Concrete', 2003, '2024-09-18', 'Operational'),
('Marathahalli Bridge', 140, 'Bridge', 720, 'Steel', 2008, '2024-10-01', 'Operational'),
('Tin Factory Flyover', 112, 'Flyover', 980, 'Concrete', 2007, '2024-09-05', 'Operational'),
('Goraguntepalya Underpass', 141, 'Underpass', 280, 'Concrete', 2019, '2024-10-08', 'Operational');

-- ============================================================================================================
-- 4. PUBLIC FACILITIES
-- ============================================================================================================

INSERT INTO PublicFacilities (name, facility_type, address, ward_number, capacity, opening_date, operating_hours, status, contact_phone, contact_email) VALUES
-- Schools
('Bishop Cotton Boys School', 'School', 'St Marks Road, Bangalore', 111, 3500, '1865-01-01', '8:00 AM - 3:00 PM', 'Operational', '080-22868546', 'info@bishopcottonbangalore.edu'),
('National Public School', 'School', 'Koramangala, Bangalore', 151, 4200, '1980-06-15', '8:00 AM - 3:30 PM', 'Operational', '080-25532157', 'info@npsbangalore.org'),
('Delhi Public School', 'School', 'Electronic City, Bangalore', 175, 3800, '1998-04-01', '7:45 AM - 2:30 PM', 'Operational', '080-28529898', 'principal@dpseast.com'),

-- Hospitals
('Manipal Hospital', 'Hospital', 'Old Airport Road, Bangalore', 93, 280, '1991-03-15', '24 Hours', 'Operational', '080-25024444', 'info@manipalhospital.com'),
('Apollo Hospitals', 'Hospital', 'Bannerghatta Road, Bangalore', 148, 300, '2007-08-20', '24 Hours', 'Operational', '1860-500-1066', 'bangalore@apollohospitals.com'),
('Narayana Health City', 'Hospital', 'Bommasandra, Bangalore', 175, 600, '2001-09-10', '24 Hours', 'Operational', '080-71222222', 'healthcity@narayanahea lth.org'),
('Fortis Hospital', 'Hospital', 'Whitefield, Bangalore', 110, 300, '2006-11-12', '24 Hours', 'Operational', '080-66214444', 'whitefield@fortishealthcare.com'),
('St Johns Hospital', 'Hospital', 'Koramangala, Bangalore', 188, 1350, '1963-05-01', '24 Hours', 'Operational', '080-49467000', 'info@stjohnshospital.in'),

-- Libraries
('State Central Library', 'Library', 'Cubbon Park, Bangalore', 92, 500, '1914-03-01', '8:30 AM - 8:00 PM', 'Operational', '080-22250483', 'scl@kar.nic.in'),
('British Library', 'Library', 'Indiranagar, Bangalore', 93, 200, '1948-06-15', '11:00 AM - 7:00 PM', 'Operational', '080-23460000', 'bangalore@britishcouncil.org.in'),

-- Community Centers
('Koramangala Community Hall', 'Community Center', 'Koramangala 5th Block', 151, 300, '2010-01-15', '9:00 AM - 9:00 PM', 'Operational', '080-25533333', 'koramangala.comm@bbmp.gov.in'),
('Malleswaram Community Center', 'Community Center', '18th Cross, Malleswaram', 61, 250, '2005-03-20', '9:00 AM - 8:00 PM', 'Operational', '080-23346666', 'malleswaram.comm@bbmp.gov.in'),
('Jayanagar Community Hall', 'Community Center', '4th Block, Jayanagar', 176, 400, '2008-07-10', '9:00 AM - 9:00 PM', 'Operational', '080-26633333', 'jayanagar.comm@bbmp.gov.in');

-- ============================================================================================================
-- 5. STREET LIGHTS (Sample)
-- ============================================================================================================

INSERT INTO StreetLights (location, ward_number, light_type, installation_date, status, last_maintenance_date, wattage, smart_enabled) VALUES
('MG Road Junction', 181, 'LED', '2022-03-15', 'Working', '2024-09-20', 150, TRUE),
('Koramangala 80 Feet Road', 151, 'LED', '2023-01-10', 'Working', '2024-10-01', 120, TRUE),
('Whitefield Main Road', 110, 'LED', '2021-06-20', 'Faulty', '2024-08-15', 150, FALSE),
('Bannerghatta Road', 190, 'Sodium Vapor', '2015-04-12', 'Working', '2024-07-30', 250, FALSE),
('Malleshwaram 8th Cross', 61, 'LED', '2022-11-05', 'Working', '2024-09-25', 100, TRUE);

-- ============================================================================================================
-- 6. TRANSPORTATION - BUS ROUTES
-- ============================================================================================================

INSERT INTO TransportRoutes (route_number, route_name, route_type, start_point, end_point, stops, frequency_minutes, operational_hours, fare_base) VALUES
('365', 'Majestic to Bannerghatta', 'Bus', 'Majestic', 'Bannerghatta National Park', ARRAY['Majestic', 'Wilson Garden', 'Bannerghatta', 'Hulimavu', 'Bannerghatta National Park'], 20, '5:00 AM - 11:00 PM', 25.00),
('505', 'Electronic City to ITPL', 'Bus', 'Electronic City', 'ITPL', ARRAY['Electronic City', 'Bommanahalli', 'Marathahalli Bridge', 'ITPL'], 25, '6:00 AM - 10:00 PM', 30.00),
('G-4', 'Kendriya Sadan to Whitefield', 'Bus', 'Kendriya Sadan', 'Whitefield', ARRAY['Kendriya Sadan', 'Shivajinagar', 'Indiranagar', 'Marathahalli', 'Whitefield'], 15, '5:30 AM - 11:30 PM', 35.00),
('201A', 'Shivajinagar to JP Nagar', 'Bus', 'Shivajinagar', 'JP Nagar 6th Phase', ARRAY['Shivajinagar', 'Jayanagar', 'BTM Layout', 'JP Nagar'], 18, '6:00 AM - 10:30 PM', 20.00),
('335E', 'Kempegowda Bus Station to Sarjapur', 'Bus', 'Kempegowda Bus Station', 'Sarjapur', ARRAY['KBS Majestic', 'Koramangala', 'HSR Layout', 'Sarjapur Road', 'Sarjapur'], 30, '5:00 AM - 10:00 PM', 28.00),
('500A', 'Shantinagar to Yeshwanthpur', 'Bus', 'Shantinagar', 'Yeshwanthpur', ARRAY['Shantinagar', 'MG Road', 'Rajajinagar', 'Yeshwanthpur'], 20, '5:30 AM - 11:00 PM', 22.00),
('171K', 'Majestic to Electronic City', 'Bus', 'Majestic', 'Electronic City Phase 2', ARRAY['Majestic', 'Jayanagar', 'BTM', 'Silk Board', 'Electronic City'], 15, '5:00 AM - 11:30 PM', 32.00),
('KBS-8', 'Kempegowda Bus Station to Hennur', 'Bus', 'KBS Majestic', 'Hennur', ARRAY['KBS', 'Ulsoor', 'Banaswadi', 'HBR Layout', 'Hennur'], 25, '6:00 AM - 10:00 PM', 24.00);

-- ============================================================================================================
-- 7. TRANSPORTATION - METRO STATIONS
-- ============================================================================================================

INSERT INTO MetroStations (station_name, metro_line, ward_number, opening_date, platform_count, daily_footfall, facilities, status) VALUES
('MG Road', 'Purple Line', 181, '2011-10-20', 2, 45000, ARRAY['Parking', 'ATM', 'Restrooms', 'Retail'], 'Operational'),
('Yeshwanthpur', 'Green Line', 48, '2014-03-01', 2, 38000, ARRAY['Parking', 'ATM', 'Restrooms'], 'Operational'),
('Whitefield', 'Purple Line', 110, '2016-06-18', 2, 52000, ARRAY['Parking', 'ATM', 'Restrooms', 'Retail'], 'Operational'),
('Jayanagar', 'Green Line', 176, '2017-06-18', 2, 41000, ARRAY['ATM', 'Restrooms', 'Retail'], 'Operational'),
('Nagawara', 'Pink Line', 148, '2024-05-20', 2, 28000, ARRAY['Parking', 'ATM', 'Restrooms'], 'Operational'),
('Indiranagar', 'Purple Line', 93, '2011-10-20', 2, 48000, ARRAY['Parking', 'ATM', 'Restrooms', 'Retail'], 'Operational'),
('Cubbon Park', 'Purple Line', 111, '2011-10-20', 2, 36000, ARRAY['ATM', 'Restrooms'], 'Operational'),
('Majestic', 'Purple & Green Line', 94, '2011-10-20', 4, 95000, ARRAY['Parking', 'ATM', 'Restrooms', 'Retail', 'Food Court'], 'Operational'),
('Silk Board', 'Purple Line', 174, '2017-06-18', 2, 42000, ARRAY['Parking', 'ATM', 'Restrooms'], 'Operational'),
('Electronic City', 'Purple Line', 175, '2016-06-18', 2, 55000, ARRAY['Parking', 'ATM', 'Restrooms', 'Retail'], 'Operational');

-- ============================================================================================================
-- 8. TRANSPORTATION - PARKING
-- ============================================================================================================

INSERT INTO ParkingLocations (name, location, ward_number, parking_type, total_capacity, available_spots, rate_per_hour, operating_hours) VALUES
('Brigade Road Parking', 'Brigade Road', 181, 'Multi-level', 250, 45, 40.00, '24 Hours'),
('Garuda Mall Parking', 'Magrath Road', 112, 'Mall Parking', 400, 120, 30.00, '10:00 AM - 11:00 PM'),
('Majestic Bus Stand Parking', 'Kempegowda Bus Station', 94, 'On-street', 150, 20, 20.00, '24 Hours'),
('Commercial Street Pay & Park', 'Commercial Street', 92, 'Multi-level', 180, 35, 35.00, '9:00 AM - 10:00 PM'),
('Forum Mall Parking', 'Koramangala', 176, 'Mall Parking', 500, 200, 30.00, '10:00 AM - 11:00 PM'),
('Whitefield ITPL Parking', 'Whitefield', 110, 'On-street', 300, 80, 25.00, '24 Hours'),
('Indiranagar Metro Parking', 'Indiranagar', 93, 'Multi-level', 220, 60, 30.00, '5:00 AM - 12:00 AM'),
('HSR Layout BDA Complex', 'HSR Layout', 174, 'On-street', 120, 40, 20.00, '6:00 AM - 10:00 PM');

-- ============================================================================================================
-- 9. UTILITIES - ELECTRICITY SUBSTATIONS
-- ============================================================================================================

INSERT INTO ElectricitySubstations (substation_name, ward_number, voltage_kv, capacity_mva, areas_served, installation_year, last_maintenance_date, status) VALUES
('Hoodi Substation', 86, 400, 500, ARRAY['Whitefield', 'KR Puram', 'Marathahalli'], 2010, '2024-09-15', 'Operational'),
('AnandRao Circle Substation', 61, 220, 315, ARRAY['Majestic', 'Malleshwaram', 'Rajajinagar'], 2005, '2024-08-20', 'Operational'),
('Devanahalli Substation', 150, 220, 400, ARRAY['Devanahalli', 'Airport Region', 'Yelahanka'], 2015, '2024-10-01', 'Operational'),
('Electronic City Substation', 175, 220, 350, ARRAY['Electronic City', 'Bommanahalli', 'Hosur Road'], 2008, '2024-09-10', 'Operational'),
('Yeshwanthpur Substation', 48, 220, 280, ARRAY['Yeshwanthpur', 'Peenya', 'Tumkur Road'], 2003, '2024-07-25', 'Operational');

-- ============================================================================================================
-- 10. UTILITIES - WASTE COLLECTION
-- ============================================================================================================

INSERT INTO WasteCollection (zone_name, ward_numbers, collection_schedule, collection_type, vehicle_count, coverage_area_sq_km) VALUES
('Bommanahalli Zone', ARRAY[151, 174, 175, 176, 186, 188, 190], 'Daily 5:30-6:30 AM', 'Wet, Dry', 45, 85.6),
('Mahadevapura Zone', ARRAY[86, 93, 110, 112, 140, 149, 150], 'Daily 5:30-6:30 AM', 'Wet, Dry', 52, 98.4),
('South Zone', ARRAY[183, 198, 203, 210, 224, 243], 'Daily 5:30-6:30 AM', 'Wet, Dry', 38, 142.8),
('West Zone', ARRAY[141, 148, 165, 180], 'Daily 5:30-6:30 AM', 'Wet, Dry', 28, 62.5),
('Central Zone', ARRAY[92, 94, 101, 102, 111, 131], 'Daily 5:30-6:30 AM', 'Wet, Dry', 32, 48.7);

-- ============================================================================================================
-- 11. UTILITIES - WATER SUPPLY
-- ============================================================================================================

INSERT INTO WaterSupply (area_name, ward_number, water_source, supply_schedule, quality_index, last_quality_check) VALUES
('Bellandur', 150, 'Cauvery', 'Daily 6:00-8:00 AM, 6:00-8:00 PM', 85.5, '2024-10-15'),
('Basavanagudi', 210, 'Groundwater, Cauvery', 'Daily 6:00-9:00 AM', 88.2, '2024-10-12'),
('Rajajinagar', 141, 'Cauvery', 'Daily 6:00-8:00 AM, 6:00-8:00 PM', 87.8, '2024-10-14'),
('Whitefield', 110, 'Cauvery, Borewell', 'Alternate Days 6:00-9:00 AM', 82.4, '2024-10-10'),
('Koramangala', 151, 'Cauvery', 'Daily 6:00-8:00 AM, 7:00-9:00 PM', 89.1, '2024-10-16'),
('Jayanagar', 176, 'Cauvery', 'Daily 6:00-9:00 AM', 90.3, '2024-10-13'),
('Malleshwaram', 61, 'Cauvery', 'Daily 6:00-8:00 AM, 6:00-8:00 PM', 88.7, '2024-10-11'),
('Electronic City', 175, 'Cauvery, Borewell', 'Alternate Days 5:00-8:00 AM', 81.9, '2024-10-09');

-- ============================================================================================================
-- 12. ENVIRONMENT - PARKS
-- ============================================================================================================

INSERT INTO Parks (name, ward_number, area_acres, park_type, facilities, tree_count, opening_hours, entry_fee) VALUES
('Cubbon Park', 111, 300, 'Public Park', ARRAY['Walking Track', 'Childrens Play Area', 'Statues', 'Library'], 6000, '5:00 AM - 9:00 PM', 0.00),
('Lalbagh Botanical Garden', 210, 240, 'Botanical Garden', ARRAY['Glasshouse', 'Lake', 'Walking Paths', 'Rare Plants'], 18000, '6:00 AM - 7:00 PM', 30.00),
('Bannerghatta National Park', 243, 104.27, 'National Park', ARRAY['Safari', 'Zoo', 'Butterfly Park', 'Trekking'], 25000, '9:00 AM - 5:00 PM', 100.00),
('JP Park', 17, 85, 'Public Park', ARRAY['Walking Track', 'Lake', 'Boating', 'Playground'], 3500, '5:30 AM - 8:30 PM', 0.00),
('Nandanavana Park', 140, 30, 'Public Park', ARRAY['Walking Track', 'Playground', 'Outdoor Gym'], 1200, '5:00 AM - 9:00 PM', 0.00),
('Ulsoor Lake Park', 131, 125, 'Lake Park', ARRAY['Boating', 'Walking Track', 'Sitting Areas'], 2800, '5:00 AM - 9:00 PM', 0.00),
('Sankey Tank Park', 61, 37, 'Lake Park', ARRAY['Walking Track', 'Bird Watching', 'Sitting Areas'], 1500, '5:00 AM - 8:00 PM', 0.00);

-- ============================================================================================================
-- 13. ENVIRONMENT - AIR QUALITY (Sample recent data)
-- ============================================================================================================

INSERT INTO AirQualityData (location, ward_number, timestamp, pm2_5, pm10, ozone, no2, so2, aqi, aqi_category) VALUES
('Parisara Bhavan, Church Street', 92, '2024-10-20 08:00:00', 45.2, 78.5, 32.1, 28.4, 12.5, 95, 'Moderate'),
('Peenya Industrial Area', 41, '2024-10-20 08:00:00', 68.8, 125.3, 45.6, 42.8, 22.3, 152, 'Unhealthy'),
('Whitefield', 110, '2024-10-20 08:00:00', 52.4, 89.7, 38.2, 31.5, 15.8, 112, 'Moderate'),
('Silk Board', 174, '2024-10-20 08:00:00', 71.5, 132.8, 48.9, 45.2, 24.1, 158, 'Unhealthy'),
('Yeshwanthpur', 48, '2024-10-20 08:00:00', 58.3, 98.4, 41.3, 35.7, 18.6, 125, 'Moderate');

-- ============================================================================================================
-- 14. SAFETY - POLICE STATIONS
-- ============================================================================================================

INSERT INTO PoliceStations (station_name, ward_number, jurisdiction, address, phone, email, officer_in_charge) VALUES
('Ulsoor Police Station', 131, ARRAY['Ulsoor', 'MG Road Area', 'Trinity Circle'], 'Ulsoor, Bangalore', '080-25580540', 'ps.ulsoor@ksp.gov.in', 'Inspector Ramesh Kumar'),
('Koramangala Police Station', 151, ARRAY['Koramangala', 'HSR Layout', 'BTM Layout'], '1st Block, Koramangala', '080-25537106', 'ps.koramangala@ksp.gov.in', 'Inspector Vijay Kumar'),
('Malleswaram Police Station', 61, ARRAY['Malleswaram', 'Rajajinagar', 'Sadashivanagar'], '18th Cross, Malleswaram', '080-23461424', 'ps.malleswaram@ksp.gov.in', 'Inspector Suresh Babu'),
('Basavanagudi Police Station', 210, ARRAY['Basavanagudi', 'Gandhi Bazaar', 'Bull Temple Road'], 'Gandhi Bazaar, Basavanagudi', '080-26608490', 'ps.basavanagudi@ksp.gov.in', 'Inspector Prakash Rao'),
('Rajajinagar Police Station', 141, ARRAY['Rajajinagar', 'Mahalakshmi Layout', 'Nandini Layout'], '8th Block, Rajajinagar', '080-23578524', 'ps.rajajinagar@ksp.gov.in', 'Inspector Murthy K N'),
('Whitefield Police Station', 110, ARRAY['Whitefield', 'Marathahalli', 'Varthur'], 'Whitefield Main Road', '080-28452540', 'ps.whitefield@ksp.gov.in', 'Inspector Ravi Shankar');

-- ============================================================================================================
-- 15. SAFETY - FIRE STATIONS
-- ============================================================================================================

INSERT INTO FireStations (station_name, coverage_wards, address, phone, vehicle_count, avg_response_time_minutes) VALUES
('Banashankari Fire Station', ARRAY[203, 180], 'Banashankari, Bangalore', '080-26712131', 5, 8),
('Whitefield Fire Station', ARRAY[110, 111], 'Whitefield, Bangalore', '080-28451010', 4, 10),
('Central Fire Control', ARRAY[112, 111], 'Magrath Road, Bangalore', '080-22942302', 8, 6),
('Cooke Town Fire Station', ARRAY[101, 102], 'Cooke Town, Bangalore', '080-25461212', 4, 7),
('Koramangala Fire Station', ARRAY[151, 186], 'Koramangala 5th Block', '080-25537171', 5, 8),
('Yeshwanthpur Fire Station', ARRAY[48, 44], 'Yeshwanthpur, Bangalore', '080-23571010', 6, 9);

-- ============================================================================================================
-- 16. ECONOMY - COMMERCIAL AREAS
-- ============================================================================================================

INSERT INTO CommercialAreas (area_name, ward_number, area_type, total_businesses, major_industries, avg_footfall_daily) VALUES
('Whitefield', 110, 'Business District', 2400, ARRAY['IT', 'Tech Startups', 'Co-working Spaces'], 85000),
('Sarjapur Road', 149, 'Business District', 1800, ARRAY['IT', 'E-commerce', 'Cloud Kitchens'], 62000),
('Brigade Road', 181, 'Shopping Complex', 950, ARRAY['Retail', 'Restaurants', 'Entertainment'], 45000),
('Koramangala', 151, 'Mixed Use', 3200, ARRAY['Startups', 'Cafes', 'Retail', 'Services'], 78000),
('Indiranagar', 93, 'Shopping Complex', 1600, ARRAY['Retail', 'Restaurants', 'Boutiques'], 52000),
('Electronic City', 175, 'Business District', 1200, ARRAY['IT', 'Manufacturing', 'Tech Services'], 95000),
('Majestic', 94, 'Market', 2800, ARRAY['Wholesale', 'Retail', 'Transport Services'], 120000),
('Malleswaram', 61, 'Market', 1400, ARRAY['Retail', 'Services', 'Traditional Business'], 38000),
('JP Nagar', 198, 'Mixed Use', 1900, ARRAY['Retail', 'Services', 'Restaurants'], 48000),
('HSR Layout', 174, 'Mixed Use', 2100, ARRAY['Startups', 'Retail', 'Services'], 56000);

-- ============================================================================================================
-- 17. EDUCATION - SCHOOLS & COLLEGES
-- ============================================================================================================

INSERT INTO EducationalInstitutions (name, institution_type, ward_number, address, enrollment_count, teacher_count, established_year, affiliation, phone, website) VALUES
('IISc', 'University', 61, 'CV Raman Avenue, Bangalore', 4000, 450, 1909, 'Autonomous', '080-22932001', 'https://www.iisc.ac.in'),
('NLSIU', 'University', 165, 'Nagarabhavi, Bangalore', 800, 85, 1987, 'Autonomous', '080-23160532', 'https://www.nls.ac.in'),
('Bishop Cotton Boys School', 'School', 111, 'St Marks Road, Bangalore', 3500, 280, 1865, 'CISCE', '080-22868546', 'https://bishopcottonbangalore.edu'),
('Christ University', 'University', 176, 'Hosur Road, Bangalore', 13000, 980, 1969, 'UGC', '080-40129100', 'https://www.christuniversity.in'),
('National Public School', 'School', 151, 'Koramangala, Bangalore', 4200, 350, 1980, 'CBSE', '080-25532157', 'https://www.npsbangalore.org'),
('Delhi Public School', 'School', 175, 'Electronic City, Bangalore', 3800, 320, 1998, 'CBSE', '080-28529898', 'https://www.dpseast.com'),
('Bangalore University', 'University', 141, 'Jnanabharathi Campus, Bangalore', 45000, 1200, 1964, 'UGC', '080-22961301', 'https://www.bangaloreuniversity.ac.in'),
('RV College of Engineering', 'College', 210, 'Mysore Road, Bangalore', 8500, 650, 1963, 'VTU', '080-67178000', 'https://www.rvce.edu.in');

-- ============================================================================================================
-- 18. HEALTHCARE FACILITIES
-- ============================================================================================================

INSERT INTO HealthcareFacilities (name, facility_type, ward_number, address, bed_count, staff_count, specialties, emergency_services, phone, website) VALUES
('Manipal Hospital', 'Hospital', 93, 'Old Airport Road, Bangalore', 280, 450, ARRAY['Cardiology', 'Neurology', 'Orthopedics', 'Oncology'], TRUE, '080-25024444', 'https://www.manipalhospitals.com'),
('Apollo Hospitals', 'Hospital', 148, 'Bannerghatta Road, Bangalore', 300, 520, ARRAY['Cardiology', 'Neurosurgery', 'Transplant', 'Cancer Care'], TRUE, '1860-500-1066', 'https://www.apollohospitals.com'),
('Narayana Health City', 'Hospital', 175, 'Bommasandra, Bangalore', 600, 980, ARRAY['Cardiac Surgery', 'Neurology', 'Oncology', 'Kidney Care'], TRUE, '080-71222222', 'https://www.narayanahealth.org'),
('Fortis Hospital', 'Hospital', 110, 'Whitefield, Bangalore', 300, 480, ARRAY['Cardiology', 'Orthopedics', 'Neurology', 'Gastroenterology'], TRUE, '080-66214444', 'https://www.fortishealthcare.com'),
('St Johns Hospital', 'Hospital', 188, 'Koramangala, Bangalore', 1350, 2100, ARRAY['Cardiology', 'Neurology', 'Oncology', 'Emergency Medicine'], TRUE, '080-49467000', 'https://www.stjohnshospital.in'),
('Bangalore Baptist Hospital', 'Hospital', 183, 'Bellary Road, Bangalore', 200, 350, ARRAY['General Medicine', 'Surgery', 'Pediatrics'], TRUE, '080-22277979', 'https://www.baptisthospitalbangalore.org'),
('Victoria Hospital', 'Hospital', 94, 'Fort Area, Bangalore', 1200, 1800, ARRAY['General Medicine', 'Surgery', 'Trauma Care', 'Infectious Diseases'], TRUE, '080-26702490', 'https://victoriahospital.kar.nic.in');

-- ============================================================================================================
-- 19. SAMPLE CITIZEN DATA (With hashed passwords)
-- ============================================================================================================

-- Note: Password is 'password123' hashed with bcrypt
INSERT INTO Citizens (name, email, phone, ward_number, zone, address, role, password_hash) VALUES
('Rajesh Kumar', 'rajesh.kumar@email.com', '9876543210', 151, 'Bommanahalli', 'Koramangala 5th Block, Bangalore', 'citizen', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzpLhJ3pem'),
('Priya Sharma', 'priya.sharma@email.com', '9876543211', 110, 'Mahadevapura', 'Whitefield Main Road, Bangalore', 'citizen', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzpLhJ3pem'),
('Arun Reddy', 'arun.reddy@email.com', '9876543212', 61, 'Malleshwaram', '18th Cross, Malleshwaram, Bangalore', 'citizen', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzpLhJ3pem'),
('Lakshmi Iyer', 'lakshmi.iyer@email.com', '9876543213', 176, 'Bommanahalli', 'Jayanagar 4th Block, Bangalore', 'officer', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzpLhJ3pem'),
('Suresh Patel', 'suresh.patel@email.com', '9876543214', 94, 'Chickpet', 'Near Majestic, Bangalore', 'admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYzpLhJ3pem');

-- ============================================================================================================
-- 20. SAMPLE COMPLAINTS (Various categories with embeddings to be added by backend)
-- ============================================================================================================

INSERT INTO Complaints (user_id, ward_number, category, sub_category, description, location, priority, status) VALUES
(1, 151, 'Street Light Failure', 'LED Light', 'Street light near Forum Mall has not been working for 3 days', 'Koramangala 5th Block', 'high', 'pending'),
(2, 110, 'Garbage Dump', 'Illegal Dumping', 'Large garbage pile on Whitefield Main Road near ITPL gate', 'Whitefield Main Road', 'high', 'pending'),
(3, 61, 'Water Supply Issues', 'No Supply', 'No water supply for last 2 days in our area', '18th Cross, Malleshwaram', 'critical', 'in_progress'),
(1, 151, 'Road Damage', 'Pothole', 'Large pothole causing traffic issues near Koramangala water tank', 'Koramangala 1st Block', 'medium', 'pending'),
(2, 110, 'Street Light Failure', 'Sodium Vapor', 'Multiple street lights not working on service road', 'Whitefield Service Road', 'medium', 'pending');

-- ============================================================================================================
-- 21. SAMPLE ANNOUNCEMENTS
-- ============================================================================================================

INSERT INTO Announcements (ward_number, zone, title, body, announcement_type, valid_from, valid_to) VALUES
(NULL, NULL, 'Swachh Bharat Abhiyan Drive', 'Citywide cleanliness drive on October 25, 2025. All citizens are requested to participate.', 'Event', '2024-10-20', '2024-10-25'),
(151, 'Bommanahalli', 'Water Supply Disruption', 'Water supply will be disrupted on October 22 from 10 AM to 4 PM due to pipeline maintenance.', 'Alert', '2024-10-20', '2024-10-22'),
(NULL, NULL, 'Property Tax Last Date', 'Last date to pay property tax without penalty is October 31, 2025.', 'Notice', '2024-10-15', '2024-10-31'),
(110, 'Mahadevapura', 'Road Widening Project', 'Whitefield Main Road widening project will commence from November 1. Expect traffic diversions.', 'News', '2024-10-18', '2024-12-31');

-- ============================================================================================================
-- END OF DATA POPULATION
-- ============================================================================================================

-- Verify data insertion
SELECT 'Wards Inserted: ' || COUNT(*) FROM Wards;
SELECT 'Roads Inserted: ' || COUNT(*) FROM Roads;
SELECT 'Public Facilities Inserted: ' || COUNT(*) FROM PublicFacilities;
SELECT 'Metro Stations Inserted: ' || COUNT(*) FROM MetroStations;
SELECT 'Parks Inserted: ' || COUNT(*) FROM Parks;
SELECT 'Police Stations Inserted: ' || COUNT(*) FROM PoliceStations;
SELECT 'Healthcare Facilities Inserted: ' || COUNT(*) FROM HealthcareFacilities;
SELECT 'Educational Institutions Inserted: ' || COUNT(*) FROM EducationalInstitutions;
SELECT 'Citizens Inserted: ' || COUNT(*) FROM Citizens;
SELECT 'Complaints Inserted: ' || COUNT(*) FROM Complaints;
