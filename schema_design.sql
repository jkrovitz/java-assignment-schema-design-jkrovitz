-- Create schema and prevent error if schema already exists in database
CREATE SCHEMA IF NOT EXISTS identity_schema;

-- Set current schema to identity_schema
SET SEARCH_PATH = 'identity_schema';

-- Create table location_table and prevent error if table already exists in the schema
CREATE TABLE IF NOT EXISTS location_table (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL
);

-- Create table person and prevent error if table already exists in the schema
CREATE TABLE IF NOT EXISTS person (
	person_id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	age integer NOT NULL,
	location_id INTEGER NOT NULL,
    CONSTRAINT fk_location
        FOREIGN KEY (location_id)
            REFERENCES location_table(location_id)
);

-- Create table interest and prevent error if table already exists in the schema
CREATE TABLE IF NOT EXISTS interest (
  interest_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

--Create table person_interest and prevent error if table already exists in the schema
CREATE TABLE IF NOT EXISTS person_interest (
    person_interest_id SERIAL PRIMARY KEY,
    person_id integer NOT NULL,
    interest_id integer NOT NULL,
    CONSTRAINT fk_person
        FOREIGN KEY (person_id)
            REFERENCES person(person_id),
    CONSTRAINT fk_interest
        FOREIGN KEY (interest_id)
            REFERENCES interest(interest_id)
    
);

-- Add data to location_table
INSERT INTO location_table(city, state, country)
VALUES
    ('Kansas City', 'Kansas', 'United States'),
    ('Toledo', 'Ohio', 'United States'),
    ('Duluth', 'Minnesota', 'United States'),
    ('Tampa', 'Florida', 'United States'),
    ('Boston', 'Massachusetts', 'United States'),
    ('San Diego', 'California', 'United States'),
    ('Los Angeles', 'California', 'United States'),
    ('Anchorage', 'Alaska', 'United States')
;

-- Add data to person table
INSERT INTO person(first_name, last_name, age, location_id)
VALUES
    ('Minnie', 'Clements', 22, 2),
    ('Lorena', 'Mustafa', 24, 4),
    ('Cynthia', 'West', 35, 3),
    ('Braydon', 'Foreman', 32, 2),
    ('Stuart', 'Harwood', 29, 8),
    ('Dexter', 'Beltran', 28, 7),
    ('Perry', 'Jeffery', 42, 4),
    ('Noah', 'Sanderson', 39, 5),
    ('Heather', 'Heath', 33, 1),
    ('Katie', 'Knox', 27, 5),
    ('Skylar', 'Chan', 38, 3),
    ('Kayla', 'Stanley', 26, 3)
;

-- Add data to interest table
INSERT INTO interest(title)
VALUES
    ('Swimming'),
    ('Reading'),
    ('Hiking'),
    ('Biking'),
    ('Sewing'),
    ('Ice Skating'),
    ('Watching TV'),
    ('Sledding')
;

-- Add data to person_interest table
INSERT INTO person_interest(person_id, interest_id)
VALUES 
    (1, 1),
    (1, 4),
    (2, 5),
    (2, 2),
    (3, 7),
    (3, 8),
    (4, 1),
    (4, 4),
    (5, 6),
    (6, 1),
    (7, 1),
    (8, 3),
    (9, 2),
    (10, 3),
    (10, 1),
    (10, 2),
    (10, 6),
    (11, 8),
    (12, 8)
;

SELECT 
    concat(t2.first_name, ' ', t2.last_name) person_name,
    concat(t2.city, ', ', t2.state, ', ', t2.country) person_location,
    t2.title interest
FROM (
    -- sub-query selects the location_id and interest_id from the joined tables where the counts are greater than 1
    (SELECT
        l.location_id,
        pi.interest_id
    FROM location_table l
        JOIN person p ON (l.location_id = p.location_id)
        JOIN person_interest pi ON (pi.person_id = p.person_id)
        JOIN interest i ON (pi.interest_id = i.interest_id)
    GROUP BY
        l.location_id,
        pi.interest_id
    HAVING count(*) > 1)
    ) t1
    -- sub-query selects columns from the person, interest, and location table to join with the previous subquery so that more columns are shown in final output
    JOIN (
        SELECT
            p.first_name,
            p.last_name,
            l.city,
            l.state,
            l.country,
            l.location_id,
            i.interest_id,
            i.title 
        FROM location_table l
            JOIN person p ON (l.location_id = p.location_id)
            JOIN person_interest pi ON (pi.person_id = p.person_id)
            JOIN interest i ON (pi.interest_id = i.interest_id)) t2 
    ON (t1.location_id = t2.location_id
        AND t1.interest_id = t2.interest_id)
ORDER BY t2.title;