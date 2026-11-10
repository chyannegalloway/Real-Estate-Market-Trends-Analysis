-- Number of listings over time

SELECT 
    EXTRACT(YEAR from dateposted) AS year_posted,
    EXTRACT(MONTH from dateposted) AS month_posted,
    COUNT(*)
FROM property_listings_clean
WHERE EXTRACT(YEAR from dateposted) IS NOT NULL AND EXTRACT(MONTH from dateposted) IS NOT NULL
GROUP BY EXTRACT(YEAR from dateposted), EXTRACT(MONTH from dateposted)
ORDER BY year_posted, month_posted

-- Average listing price over time

SELECT
    EXTRACT(YEAR from dateposted) AS year_posted,
    EXTRACT(MONTH from dateposted) AS month_posted,
    ROUND(AVG(price), 0)
FROM property_listings_clean
WHERE EXTRACT(YEAR from dateposted) IS NOT NULL AND EXTRACT(MONTH from dateposted) IS NOT NULL
GROUP BY EXTRACT(YEAR from dateposted), EXTRACT(MONTH from dateposted)
ORDER BY year_posted, month_posted

-- Median listing price over time - on powerbi

-- New listings by month

SELECT 
    EXTRACT(YEAR FROM dateposted) AS Year,
    EXTRACT(MONTH FROM dateposted) AS Month,
    COUNT(*) AS occurrences
FROM property_listings_clean
GROUP BY 
    EXTRACT(YEAR FROM dateposted),
    EXTRACT(MONTH FROM dateposted)
ORDER BY Year, Month

-- Price changes over time

SELECT 
    zpid,
    COUNT(*)
FROM price_history
GROUP BY zpid
HAVING COUNT(*) > 1

SELECT *
FROM price_history
WHERE zpid = '98342684'

SELECT
    zpid,
    price,
    dateofevent
FROM price_history
WHERE price IS NOT NULL
ORDER BY zpid, dateofevent


