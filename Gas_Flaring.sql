-- Create the Database
CREATE DATABASE gas_flaring;
USE gas_flaring;

-- 1. Create the 'countries' table
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Create the 'fields' table
CREATE TABLE fields (
    field_id INT AUTO_INCREMENT PRIMARY KEY,
    field_name VARCHAR(255),
    field_type VARCHAR(100),
    field_operator VARCHAR(255),
    location VARCHAR(255),
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- 3. Create the 'flaring_events' table
CREATE TABLE flaring_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    field_id INT NOT NULL,
    year YEAR NOT NULL,
    flare_level VARCHAR(50),
    flaring_volume_million_m3 DECIMAL(15, 6),
    volume_bcm DECIMAL(15, 6),
    volume_mmscfd DECIMAL(15, 6),
    FOREIGN KEY (field_id) REFERENCES fields(field_id)
);

-- Insert sample countries (Parent table first)
INSERT INTO countries (country_name) VALUES
('Nigeria'),
('United States'),
('Norway');

-- Insert sample fields (References countries)
INSERT INTO fields (field_name, field_type, field_operator, location, latitude, longitude, country_id) VALUES
('Abiteye', 'Oil', 'Chevron', 'Onshore', 5.6, 5.2, (SELECT country_id FROM countries WHERE country_name = 'Nigeria')),
('Phantom', 'Oil', 'Vital Energy', 'Onshore', 31.3, -103.6, (SELECT country_id FROM countries WHERE country_name = 'United States')),
('Njord', 'Oil', 'Equinor', 'Offshore', 64.2, 7.1, (SELECT country_id FROM countries WHERE country_name = 'Norway'));

-- Insert sample flaring events (References fields)
INSERT INTO flaring_events (field_id, year, flare_level, flaring_volume_million_m3, volume_bcm, volume_mmscfd) VALUES
(
 (SELECT field_id FROM fields WHERE field_name = 'Abiteye'),
 2022,
 'High',
 150.75,
 0.15075,
 5324.12
),
(
 (SELECT field_id FROM fields WHERE field_name = 'Phantom'),
 2022,
 'Medium',
 89.21,
 0.08921,
 3150.55
),
(
 (SELECT field_id FROM fields WHERE field_name = 'Njord'),
 2022,
 'Low',
 12.45,
 0.01245,
 439.67
);

-- Create Staging Table
CREATE TABLE staging_table (
    `Country` VARCHAR(100),
    `Latitude` DECIMAL(10, 6),
    `Longitude` DECIMAL(10, 6),
    `bcm` DECIMAL(15, 6),
    `MMscfd` DECIMAL(15, 6),  
    `Year` INT,
    `Field Type` VARCHAR(50),
    `Field Name` VARCHAR(100),
    `Field Operator` VARCHAR(100),
    `Location` VARCHAR(100),
    `Flare Level` VARCHAR(50),
    `Flaring Vol (million m3)` DECIMAL(15, 6)
    );
    
    




