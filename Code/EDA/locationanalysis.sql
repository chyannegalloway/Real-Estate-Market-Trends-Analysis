SELECT *
FROM property_listings_clean


-- Which states have the most listings?

SELECT 
    city,
    state,
    COUNT(*)
FROM property_listings_clean
GROUP BY city, state
ORDER BY COUNT(*) DESC

SELECT 
    state,
    COUNT(*)
FROM property_listings_clean
GROUP BY state
ORDER BY COUNT(*) DESC

-- Which cities have the highest median prices? do median calculations in powerbi

-- Where is the price per square foot highest

CREATE VIEW price_per_sqft_city AS
SELECT 
    ROUND(AVG(price/livingarea), 0) AS price_per_sqft,
    city,
    state
FROM property_listings_clean
WHERE livingarea IS NOT NULL AND livingarea <> '0'
GROUP BY city, state
ORDER BY price_per_sqft DESC
LIMIT 10

-- cities with averages above the national average, and the percentage difference. 

SELECT 
    city,
    state,
    ROUND(AVG(price), 0) AS city_average,
    ROUND(((AVG(price)-673024)/673024)*100, 2) AS percent_diff
FROM property_listings_clean
GROUP BY city, state
ORDER BY percent_diff DESC 

CREATE VIEW state_avg AS
SELECT 
    state,
    ROUND(AVG(price), 0) AS state_average,
    ROUND(((AVG(price)-673024)/673024)*100, 2) AS percent_diff
FROM property_listings_clean
GROUP BY state
ORDER BY percent_diff DESC


-- national average
SELECT 
    AVG(price) AS avg
FROM property_listings_clean -- 673024

-- maybe create a grouping based on location: South, West Coast etc.

CREATE VIEW regionmap AS
SELECT 
    zpid,
    state,
    CASE
        WHEN state IN ('WA', 'CA', 'NV', 'AZ', 'CO') THEN 'The West'
        WHEN state IN ('TX', 'TN', 'KY', 'VA', 'NC', 'SC', 'GA', 'FL') THEN 'The South'
        WHEN state IN ('IL', 'IN', 'OH', 'MI') THEN 'The Midwest'
        WHEN state IN ('PA', 'NY', 'MD', 'MA') THEN 'The North East'
        ELSE 'IDK'
    END AS Regions
FROM property_listings_clean

DROP VIEW regions


