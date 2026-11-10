SELECT *
FROM mortgage_clean

-- What is the average mortgage amount?
-- What is the average interest rate?
-- Which mortgage types are most common?
-- How does interest rate vary by mortgage type?
--Power Bi above

-- Which property types have the most favourable mortgage rates

CREATE VIEW type_mortgage AS
SELECT 
    p.hometype,
    ROUND(AVG(m.rate), 3) AS mortgage_rate
FROM property_listings_clean p
LEFT JOIN mortgage_clean m ON p.zpid = m.zpid
WHERE m.rate IS NOT NULL
GROUP BY p.hometype

SELECT *
FROM mortgage_clean

-- How does mortgage rate vary by property price range?

SELECT 
    MIN(price),
    MAX(price)
FROM property_listings_clean

CREATE VIEW mortgage_range AS
SELECT 
    -- p.zpid,
    -- p.price,
    ROUND(AVG(m.rate), 3),
    CASE 
        WHEN price BETWEEN 0 AND 500000 THEN '0 - 0.5 Million'
        WHEN price BETWEEN 500000 AND 1000000 THEN '0.5 - 1 Million'
        WHEN price BETWEEN 1000000 AND 5000000 THEN '1 - 5 Million'
        WHEN price BETWEEN 5000000 AND 10000000 THEN '5 Million - 10 Million'
        WHEN price BETWEEN 10000000 AND 50000000 THEN '10 Million - 50 Million'
        WHEN price BETWEEN 50000000 AND 100000000 THEN '50 - 100 Million'
        WHEN price BETWEEN 100000000 AND 500000000 THEN '100 Million +'
        ELSE 'No Cost'
    END AS PriceRange
FROM property_listings_clean p
LEFT JOIN mortgage_clean m ON p.zpid = m.zpid
WHERE rate IS NOT NULL AND rate <> '0'
GROUP BY PriceRange

-- Which cities combine high property prices with favourable mortgage rates?

SELECT 
    ROUND(AVG(p.price), 0) AS avg_price,
    ROUND(AVG(m.rate), 3) AS avg_rate,
    p.county,
    p.state
FROM property_listings_clean p
LEFT JOIN mortgage_clean m ON p.zpid = m.zpid
WHERE m.rate IS NOT NULL AND p.county IS NOT NULL
GROUP BY county, state
ORDER BY avg_rate DESC
LIMIT 5;

SELECT 
    ROUND(AVG(p.price), 0) AS avg_price,
    ROUND(AVG(m.rate), 3) AS avg_rate,
    p.county,
    p.state
FROM property_listings_clean p
LEFT JOIN mortgage_clean m ON p.zpid = m.zpid
WHERE m.rate IS NOT NULL
GROUP BY county, state
ORDER BY avg_price DESC
LIMIT 5;


SELECT 
    ROUND(AVG(p.price), 0) AS avg_price,
    ROUND(AVG(m.rate), 3) AS avg_rate,
    p.state
FROM property_listings_clean p
LEFT JOIN mortgage_clean m ON p.zpid = m.zpid
WHERE m.rate IS NOT NULL
GROUP BY  state

-- mortgage range
CREATE VIEW mortgage_ranges AS 
SELECT 
    zpid,
    CASE 
        WHEN rate BETWEEN 5.2 AND 5.6 THEN '5.2 - 5.6'
        WHEN rate BETWEEN 5.6 AND 5.8 THEN '5.6 - 5.8'
        WHEN rate BETWEEN 5.8 AND 6.0 THEN '5.8 - 6.0'
        WHEN rate BETWEEN 6.0 AND 6.2 THEN '6.0 - 6.2'
        WHEN rate BETWEEN 6.2 AND 6.4 THEN '6.2 - 6.4'
        WHEN rate BETWEEN 6.4 AND 6.6 THEN '6.4 - 6.6'
        WHEN rate BETWEEN 6.6 AND 6.8 THEN '6.6 - 6.8'
        WHEN rate BETWEEN 6.8 AND 7.0 THEN '6.8 - 7.0'
        WHEN rate BETWEEN 7.0 AND 7.2 THEN '7.0 - 7.2'
        WHEN rate BETWEEN 7.2 AND 7.4 THEN '7.2 - 7.4'
        WHEN rate BETWEEN 7.4 AND 7.6 THEN '7.4 - 7.6'
        ELSE '7.6 +'
    END AS mortgage_rate_range
FROM mortgage_clean
WHERE rate IS NOT NULL 

CREATE VIEW m_range AS
SELECT 
    zpid,
    CASE 
        WHEN rate BETWEEN 5.2 AND 5.3 THEN '5.2 - 5.3'
        WHEN rate BETWEEN 5.3 AND 5.4 THEN '5.3 - 5.4'
        WHEN rate BETWEEN 5.4 AND 5.5 THEN '5.4 - 5.5'
        WHEN rate BETWEEN 5.5 AND 5.6 THEN '5.5 - 5.6'
        WHEN rate BETWEEN 5.6 AND 5.7 THEN '5.6 - 5.7'
        WHEN rate BETWEEN 5.7 AND 5.8 THEN '5.7 - 5.8'
        WHEN rate BETWEEN 5.8 AND 5.9 THEN '5.8 - 5.9'
        WHEN rate BETWEEN 5.9 AND 6.0 THEN '5.9 - 6.0'
        WHEN rate BETWEEN 6.0 AND 6.1 THEN '6.0 - 6.1'
        WHEN rate BETWEEN 6.1 AND 6.2 THEN '6.1 - 6.2'
        WHEN rate BETWEEN 6.2 AND 6.3 THEN '6.2 - 6.3'
        WHEN rate BETWEEN 6.3 AND 6.4 THEN '6.3 - 6.4'
        WHEN rate BETWEEN 6.4 AND 6.5 THEN '6.4 - 6.5'
        WHEN rate BETWEEN 6.5 AND 6.6 THEN '6.5 - 6.6'
        WHEN rate BETWEEN 6.6 AND 6.7 THEN '6.6 - 6.7'
        WHEN rate BETWEEN 6.7 AND 6.8 THEN '6.7 - 6.8'
        WHEN rate BETWEEN 6.8 AND 6.9 THEN '6.8 - 6.9'
        WHEN rate BETWEEN 6.9 AND 7.0 THEN '6.9 - 7.0'
        WHEN rate BETWEEN 7.0 AND 7.1 THEN '7.0 - 7.1'
        WHEN rate BETWEEN 7.1 AND 7.2 THEN '7.1 - 7.2'
        WHEN rate BETWEEN 7.2 AND 7.3 THEN '7.2 - 7.3'
        WHEN rate BETWEEN 7.3 AND 7.4 THEN '7.3 - 7.4'
        WHEN rate BETWEEN 7.4 AND 7.5 THEN '7.4 - 7.5'
        ELSE '7.5 +'
    END AS mortgage_rate_range
FROM mortgage_clean
WHERE rate IS NOT NULL 

select distinct ratesource
from mortgage_clean



