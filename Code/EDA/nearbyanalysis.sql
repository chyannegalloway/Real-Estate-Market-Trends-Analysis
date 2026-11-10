SELECT *
FROM nearby_homes_clean

SELECT *
FROM property_listings_clean

-- How many nearby properties does each property have?
-- what is the average no. of nearby homes a property has.
CREATE VIEW nearby AS
WITH no_nearby AS (
    SELECT
        zpid,
        COUNT(zpidcomp) AS no_nearbyhomes
    FROM nearby_homes_clean
    GROUP BY zpid
    ORDER BY no_nearbyhomes DESC
)

SELECT 
    ROUND(AVG(no_nearbyhomes), 0)
FROM no_nearby -- 14

-- How does a property's price compare with nearby properties?

SELECT 
    n.zpid,
    n.zpidcomp,
    p.price,
    n.pricecomp
FROM nearby_homes_clean n
LEFT JOIN property_listings_clean p ON n.zpid = p.zpid

-- Which properties are significantly cheaper/more expensive than nearby properties?

WITH nearby_prices AS (
    SELECT 
        n.zpid,
        n.zpidcomp,
        p.price,
        n.pricecomp
    FROM nearby_homes_clean n
    LEFT JOIN property_listings_clean p ON n.zpid = p.zpid
)

SELECT
    zpid,
    ROUND(AVG(price-pricecomp),0) AS average_price_diff
FROM nearby_prices
GROUP BY zpid

-- Does location appear to influence nearby property prices?

WITH nearby_prices AS (
    SELECT 
        n.zpid,
        n.zpidcomp,
        p.price,
        n.pricecomp,
        p.city,
        p.state,
        n.citycomp,
        n.statecomp,
        p.hometype,
        n.hometypecomp
    FROM nearby_homes_clean n
    LEFT JOIN property_listings_clean p ON n.zpid = p.zpid
)

SELECT
    zpid,
    price,
    pricecomp,
    ROUND(AVG(price-pricecomp),0) AS average_price_diff,
    ROUND(AVG((price-pricecomp)/pricecomp)::NUMERIC*100, 1) AS percent_diff,
    city,
    citycomp,
    state,
    statecomp
FROM nearby_prices
WHERE pricecomp <> 0 AND pricecomp IS NOT NULL AND hometype = hometypecomp
GROUP BY zpid, price, pricecomp, city, citycomp, state, statecomp -- MORE ON THIS


SELECT *
FROM nearby_homes_clean

