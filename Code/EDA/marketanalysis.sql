SELECT *
FROM property_listings_clean

-- Which locations have the highest property prices?

SELECT 
    ROUND(AVG(price), 0) AS average_price,
    county,
    state -- change these into their full names
FROM property_listings_clean
GROUP BY county, state
ORDER BY average_price DESC

-- How does price vary by number of bedrooms?

SELECT 
    ROUND(AVG(price), 0) AS average_price,
    bedrooms
FROM property_listings_clean
GROUP BY bedrooms
ORDER BY average_price DESC

-- How does price vary by square footage?

SELECT 
    ROUND(AVG(price), 0) AS average_price,
    livingarea,
    livingareaunits
FROM property_listings_clean
WHERE livingarea IS NOT NULL AND livingareaunits IS NOT NULL
GROUP BY livingarea, livingareaunits
ORDER BY average_price DESC

SELECT DISTINCT livingareaunits
FROM property_listings_clean

-- Which properties are priced significantly above or below the average price for their city and property type?

-- average property price per city
CREATE VIEW medprice AS
WITH avg_city_type AS (
    SELECT
        hometype,
        city,
        state,
        PERCENTILE_CONT(0.5) 
            WITHIN GROUP (ORDER BY price) AS median_price
    FROM property_listings_clean
    WHERE price <> 0
    GROUP BY hometype, city, state
)

SELECT
    p.zpid,
    p.price,
    p.streetaddress,
    p.hometype,
    p.city,
    p.state,
    c.median_price,
    ROUND(((p.price-c.median_price)/c.median_price)::NUMERIC*100, 2) AS Variance
FROM property_listings_clean p
LEFT JOIN avg_city_type c ON 
    p.city = c.city AND
    p.state = c.state AND 
    p.hometype = c.hometype
WHERE 
    p.price <> 0 AND 
    p.price IS NOT NULL AND
    c.median_price IS NOT NULL AND 
    c.median_price <> 0;

-- Which cities have the largest gap between property prices and price-per-square-foot?

SELECT 
    city,
    state,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(price/livingarea), 0) AS avg_price_per_sqft
FROM property_listings_clean
WHERE livingarea <> '0' AND livingarea IS NOT NULL
GROUP BY city, state

SELECT 
    state,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(price/livingarea), 0) AS avg_price_per_sqft
FROM property_listings_clean
WHERE livingarea <> '0' AND livingarea IS NOT NULL
GROUP BY state

-- Which cities/states are priced significantly higher/lower than the national average?

-- national average
WITH avg AS (
    SELECT 
        ROUND(AVG(price), 0) AS nation_avg
    FROM property_listings_clean -- $673024
)

SELECT
    price,
    city,
    state,
    (price-673024)/(673024)
FROM property_listings_clean 

-- something about year built.



