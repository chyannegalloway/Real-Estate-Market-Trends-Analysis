-- I need to remove true duplicate values in the Mortgage table and nearby homes table

-- Creating backup tables:

CREATE TABLE mortgage_backup AS 
    SELECT *
    FROM mortgage;

CREATE TABLE nearby_homes_backup AS 
    SELECT *
    FROM nearby_homes;

-- Mortgage table

SELECT
    zpid,
    buckettype,
    COUNT(*)
FROM mortgage
GROUP BY zpid, buckettype
HAVING COUNT(*) > 1;

CREATE TABLE mortgage_clean AS
SELECT DISTINCT *
FROM mortgage;

-- Nearby_homes table