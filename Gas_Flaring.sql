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
    
    -- Look at the first few rows to understand the data
SELECT * FROM staging_table LIMIT 5;

-- See a list of unique countries
SELECT DISTINCT Country FROM staging_table;

SELECT * FROM staging_table LIMIT 5;

INSERT INTO countries (country_name)
SELECT DISTINCT Country
FROM staging_table
WHERE Country IS NOT NULL AND Country != ''
LIMIT 3;

SELECT * FROM countries;

INSERT INTO fields (field_name, field_type, field_operator, location, latitude, longitude, country_id)
SELECT DISTINCT
    `Field Name`,       
    `Field Type`,       
    `Field Operator`,   
    `Location`,
    `Latitude`,
    `Longitude`,
    c.country_id
FROM staging_table r 
JOIN countries c ON r.`Country` = c.country_name
WHERE `Field Name` IS NOT NULL
LIMIT 3;

SELECT * FROM fields;

INSERT INTO flaring_events (field_id, year, flare_level, flaring_volume_million_m3, volume_bcm, volume_mmscfd)
SELECT
    f.field_id,          
    `Year`,
    `Flare Level`,      
    `Flaring Vol (million m3)`, 
    `bcm`,
    `MMscfd`
FROM staging_table r
JOIN fields f ON r.`Field Name` = f.field_name 
              AND r.`Latitude` = f.latitude 
              AND r.`Longitude` = f.longitude 
LIMIT 3;

SELECT * FROM flaring_events;

SELECT 
    c.country_name,
    f.field_name,
    f.field_operator,
    e.year,
    e.flaring_volume_million_m3
FROM flaring_events e
JOIN fields f ON e.field_id = f.field_id
JOIN countries c ON f.country_id = c.country_id;

DESCRIBE staging_table;

SELECT * FROM staging_table LIMIT 5;

-- Number of total records
SELECT COUNT(*) AS Total_Records FROM staging_table;

-- The timespan of the data
SELECT MIN(`Year`) AS Start_Year, MAX(`Year`) AS End_Year FROM staging_table;

-- Number of unique countries
SELECT COUNT(DISTINCT `Country`) AS Unique_Countries FROM staging_table;

-- Total Flaring Volume by Country
SELECT 
    `Country`,
    SUM(`Flaring Vol (million m3)`) AS Total_Flaring_Volume
FROM staging_table
GROUP BY `Country`
ORDER BY Total_Flaring_Volume DESC;

-- Total Flaring Volume by Year (Global Trend):
SELECT 
    `Year`,
    SUM(`Flaring Vol (million m3)`) AS Global_Flaring_Volume
FROM staging_table
GROUP BY `Year`
ORDER BY `Year`;

-- Top 10 Highest Flaring Fields/Operations:
SELECT 
    `Field Name`,
    `Field Operator`,
    `Country`,
    SUM(`Flaring Vol (million m3)`) AS Total_Flaring_Volume
FROM staging_table
GROUP BY `Field Name`, `Field Operator`, `Country`
ORDER BY Total_Flaring_Volume DESC
LIMIT 10;

-- 1. Trend: Global Flaring Over Time
SELECT 
    `Year`,
    SUM(`Flaring Vol (million m3)`) AS Global_Flaring_Volume
FROM staging_table
GROUP BY `Year`
ORDER BY `Year`;

-- 2. Geography: Top Flaring Countries & Ranking Change
-- a) Top Countries (e.g., for the most recent year):
SELECT 
    `Country`,
    SUM(`Flaring Vol (million m3)`) AS Total_Flaring_Volume
FROM staging_table
WHERE `Year` = (SELECT MAX(`Year`) FROM staging_table) -- 
GROUP BY `Country`
ORDER BY Total_Flaring_Volume DESC
LIMIT 10;

-- b) Ranking Change Over Time:
SELECT 
    `Year`,
    `Country`,
    SUM(`Flaring Vol (million m3)`) AS Yearly_Flaring_Volume
FROM staging_table
GROUP BY `Year`, `Country`
ORDER BY `Year`, Yearly_Flaring_Volume DESC;

-- 3. Operators: Top Flaring Companies
SELECT 
    `Field Operator`,
    SUM(`Flaring Vol (million m3)`) AS Total_Flaring_Volume
FROM staging_table
WHERE `Field Operator` IS NOT NULL 
  AND `Field Operator` != ''
GROUP BY `Field Operator`
ORDER BY Total_Flaring_Volume DESC
LIMIT 15;

-- 4. Field Level: "Super Emitter" Fields
SELECT 
    `Field Name`,
    `Country`,
    `Field Operator`,
    AVG(`Flaring Vol (million m3)`) AS Avg_Annual_Flaring, -- Finds consistently high flarers
    SUM(`Flaring Vol (million m3)`) AS Total_Flaring_Volume -- Finds all-time highest flarers
FROM staging_table
WHERE `Field Name` IS NOT NULL 
  AND `Field Name` != ''
GROUP BY `Field Name`, `Country`, `Field Operator`
ORDER BY Avg_Annual_Flaring DESC
LIMIT 20;

-- 5. Correlation: Flaring by Field Type
SELECT 
    `Field Type`,
    AVG(`Flaring Vol (million m3)`) AS Avg_Flaring_Volume,
    SUM(`Flaring Vol (million m3)`) AS Total_Flaring_Volume,
    COUNT(*) AS Number_of_Records
FROM staging_table
WHERE `Field Type` IS NOT NULL 
  AND `Field Type` != ''
GROUP BY `Field Type`
ORDER BY Total_Flaring_Volume DESC;


    
    




