-- The purpose of this page is to determine the primary keys of each table, and to better understand the dataset I am working with. 
-- I am validating whether the supposed unique identifiers are genuinely unique rather than blindly assigning primary keys.

-- Starting with property_listings
SELECT 
    zpid, 
    COUNT(*)
FROM property_listings
GROUP BY zpid
HAVING COUNT(*) > 1;
-- There are multiple duplicate values

SELECT *
FROM property_listings
WHERE zpid = '35836184'; -- each duplicate is of the same property posted at different dates. 

SELECT 
    zpid,
    dateposted,
    COUNT(*)
FROM property_listings
GROUP BY zpid, dateposted
HAVING COUNT(*) > 1; -- there is no duplicate data here, the primary key for this table may be composite. 

SELECT
    dateposted
FROM property_listings

UPDATE property_listings
SET datePosted = NULL
WHERE datePosted = '';

ALTER TABLE property_listings
ALTER COLUMN dateposted TYPE DATE
USING datePosted::DATE; -- now the datePosted column has the Date data type

-- now for this column, I just need to add the primary key. But not before dealing with the true duplicates in my tables. 

SELECT *
FROM property_listings
WHERE zpid IS NULL;

CREATE TABLE property_listings_clean AS
SELECT *
FROM property_listings
WHERE zpid IS NOT NULL;

SELECT COUNT(*)
FROM property_listings_clean
WHERE datePosted IS NULL;

SELECT *
FROM property_listings
WHERE datePosted IS NULL;

ALTER TABLE property_listings
ADD COLUMN listing_id BIGSERIAL;

-- Mortgage table:
SELECT 
    zpid,
    COUNT(*)
FROM mortgage
GROUP BY zpid
HAVING COUNT(*) >1;

SELECT *
FROM mortgage
WHERE zpid = '2053550747'; -- the buckettype is different here. 

SELECT
    zpid,
    buckettype,
    COUNT(*)
FROM mortgage
GROUP BY zpid, buckettype
HAVING COUNT(*) > 1;

SELECT
    zpid,
    bucketType,
    lastUpdatedTimestamp,
    COUNT(*) AS occurrences
FROM mortgage
GROUP BY
    zpid,
    bucketType,
    lastUpdatedTimestamp
HAVING COUNT(*) > 1;

SELECT *
FROM mortgage
WHERE zpid = '32330103'
  AND bucketType = '15 Year Fixed Bucket'
ORDER BY lastUpdatedTimestamp; -- these are true duplicate rows. 

-- remove exact duplicates.

-- For the nearby_homes table
SELECT 
    zpid, 
    zpidComp, 
    COUNT(*)
FROM nearby_homes
GROUP BY zpid, zpidComp
HAVING COUNT(*) > 1;

SELECT *
FROM nearby_homes
WHERE zpid = '14544977'
AND zpidComp = '14544941'; -- lastupdated column is the only thing that differs here. 

SELECT 
    zpid,
    zpidComp,
    lastupdated,
    COUNT(*)
FROM nearby_homes
GROUP BY zpid, zpidComp, lastupdated
HAVING COUNT(*) > 1

SELECT *
FROM nearby_homes
WHERE zpid = '416555848'
AND zpidComp = '337097260'
AND lastupdated = '2024-11-28 06:03:26.899807' -- these are true duplicate values

SELECT
    zpid,
    zpidComp,
    lastUpdated,
    COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM nearby_homes
) AS cleaned
GROUP BY zpid, zpidComp, lastUpdated
HAVING COUNT(*) > 1;

SELECT COUNT(*)
FROM nearby_homes
WHERE zpid IS NULL
   OR zpidComp IS NULL
   OR lastUpdated IS NULL;

-- For price table:
SELECT 
    zpid,
    COUNT(*)
FROM price_history
GROUP BY zpid
HAVING COUNT(*) > 1;

SELECT *
FROM price_history
WHERE zpid = '6966848' -- the duplicate values are not an issue in this table, as it denotes a change in listing for the same property. 

SELECT
    zpid,
    event,
    dateOfEvent,
    COUNT(*) AS occurrences
FROM price_history
GROUP BY
    zpid,
    event,
    dateOfEvent
HAVING COUNT(*) > 1;

-- for schools table:
SELECT
    zpid,
    schoolName,
    COUNT(*) AS record_count
FROM schools
GROUP BY zpid, schoolName
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

SELECT *
FROM schools
WHERE zpid = '2071963346'
  AND schoolName = 'David T Howard Middle School'
ORDER BY lastUpdated;

SELECT
    zpid,
    schoolName,
    lastUpdated,
    COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM schools
) AS cleaned
GROUP BY zpid, schoolName, lastUpdated
HAVING COUNT(*) > 1;

-- for subtype table:
SELECT 
    zpid,
    COUNT(*)
FROM subtype
GROUP BY zpid
HAVING COUNT(*) > 1; -- no duplicate data, zpid can be primary key. 

SELECT COUNT(*)
FROM subtype
WHERE zpid IS NULL; -- zpid can be the primary id for the table. 

-- for tax table:
SELECT 
    zpid,
    COUNT(*)
FROM listing_tax
GROUP BY zpid
HAVING COUNT(*) > 1; -- there are duplicate data

SELECT *
FROM listing_tax
WHERE zpid = '36509158' -- a lot of the columns differ for the zpid, it is unclear what the key should be here. 

SELECT
    zpid,
    lastUpdatedTimestamp,
    COUNT(*) 
FROM listing_tax
GROUP BY
    zpid,
    lastUpdatedTimestamp
HAVING COUNT(*) > 1;

/*
- property_listings: there is no duplicate data for zpid and dateposted columns, these could be a composite primary key. 
- subtype: there is no duplicate zpid data, this can be the primary key for this table. 
- listing_tax: multiple differences between duplicate rows, unclear. 
- mortgage: multiple differences between duplicate rows, unclear. 
- pricehistory: multiple differences between duplicate rows, unclear. 
*/


-- listing tax
SELECT
    zpid,
    lastUpdatedTimestamp,
    COUNT(*) AS occurrences
FROM listing_tax
GROUP BY zpid, lastUpdatedTimestamp
HAVING COUNT(*) > 1 -- same zpid has duplicates

SELECT *
FROM listing_tax
WHERE zpid = '30612549'
AND lastUpdatedTimestamp = '2023-11-23 05:07:48.933'

SELECT 
    zpid,
    lastUpdatedTimestamp,
    COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM listing_tax
) AS cleaned
GROUP BY zpid, lastUpdatedTimestamp
HAVING COUNT(*) > 1;

/*
There are exact duplicate rows in the raw data.
Those duplicates contain identical information.
Once exact duplicates are removed, zpid + lastUpdatedTimestamp is unique.
Therefore, zpid + lastUpdatedTimestamp is a candidate composite primary key.
*/

SELECT COUNT(*)
FROM listing_tax
WHERE zpid IS NULL
   OR lastUpdatedTimestamp IS NULL; -- no null values.

CREATE TABLE listing_tax_clean AS
SELECT DISTINCT *
FROM listing_tax;

-- mortgage
SELECT
    zpid,
    bucketType,
    lastUpdatedTimestamp,
    COUNT(*) AS occurrences
FROM mortgage
GROUP BY zpid, bucketType, lastUpdatedTimestamp
HAVING COUNT(*) > 1

SELECT *
FROM mortgage
WHERE zpid = '34238833'
  AND bucketType = 'Arm 5 Bucket'
  AND lastUpdatedTimestamp = '2024-11-21 00:17:49.441'; -- true duplicate values found here. 

SELECT 
    zpid,
    bucketType,
    lastUpdatedTimestamp,
    COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM mortgage
) AS cleaned
GROUP BY zpid, bucketType, lastUpdatedTimestamp
HAVING COUNT(*) > 1; -- no data

SELECT COUNT(*)
FROM mortgage
WHERE zpid IS NULL
   OR bucketType IS NULL
   OR lastUpdatedTimestamp IS NULL; -- no null values. 


--price history
SELECT
    zpid,
    event,
    dateOfEvent,
    COUNT(*) AS occurrences
FROM price_history
GROUP BY zpid, event, dateOfEvent
HAVING COUNT(*) > 1

SELECT *
FROM price_history
WHERE zpid = '30281084'
  AND event = 'Sold'
  AND dateOfEvent = '2007-12-18'; -- last updated timestamp differs.

SELECT
    zpid,
    event,
    price,
    pricePerSquareFoot,
    priceChangeRate,
    dateOfEvent,
    source,
    postingIsRental,
    lastUpdated
FROM price_history
WHERE zpid = '33403436'
  AND event = 'Sold'
  AND dateOfEvent = '2021-03-16'
ORDER BY lastUpdated;

SELECT
    zpid,
    event,
    dateOfEvent,
    COUNT(*) AS record_count
FROM price_history
GROUP BY zpid, event, dateOfEvent
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

SELECT
    zpid,
    event,
    dateOfEvent,
    COUNT(DISTINCT price) AS different_prices,
    COUNT(DISTINCT pricePerSquareFoot) AS different_ppsf,
    COUNT(DISTINCT priceChangeRate) AS different_change_rates,
    COUNT(DISTINCT source) AS different_sources,
    COUNT(DISTINCT postingIsRental) AS different_rental_status
FROM price_history
GROUP BY zpid, event, dateOfEvent
HAVING COUNT(*) > 1;

SELECT
    zpid,
    event,
    dateOfEvent,
    COUNT(DISTINCT price) AS different_prices,
    COUNT(DISTINCT pricePerSquareFoot) AS different_ppsf,
    COUNT(DISTINCT priceChangeRate) AS different_change_rates,
    COUNT(DISTINCT source) AS different_sources,
    COUNT(DISTINCT postingIsRental) AS different_rental_status
FROM price_history
GROUP BY zpid, event, dateOfEvent
HAVING COUNT(*) > 1
   AND (
       COUNT(DISTINCT price) > 1
       OR COUNT(DISTINCT pricePerSquareFoot) > 1
       OR COUNT(DISTINCT priceChangeRate) > 1
       OR COUNT(DISTINCT source) > 1
       OR COUNT(DISTINCT postingIsRental) > 1
   );

SELECT *
FROM price_history
WHERE (zpid, event, dateOfEvent) IN (
    SELECT
        zpid,
        event,
        dateOfEvent
    FROM price_history
    GROUP BY zpid, event, dateOfEvent
    HAVING COUNT(*) > 1
       AND (
           COUNT(DISTINCT price) > 1
           OR COUNT(DISTINCT pricePerSquareFoot) > 1
           OR COUNT(DISTINCT priceChangeRate) > 1
           OR COUNT(DISTINCT source) > 1
           OR COUNT(DISTINCT postingIsRental) > 1
       )
)
ORDER BY zpid, dateOfEvent, lastUpdated;

SELECT *
FROM price_history
WHERE zpid = '3666337'
  AND event = 'Sold'
  AND dateOfEvent = '2000-01-05'
ORDER BY lastUpdated; -- pricepersquarefoot and lastupdated differ

ALTER TABLE price_history
ADD COLUMN price_history_id BIGSERIAL;