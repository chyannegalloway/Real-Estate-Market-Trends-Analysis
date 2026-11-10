SELECT *
FROM property_listings_clean 

SELECT DISTINCT state
FROM property_listings_clean

SELECT DISTINCT EXTRACT(YEAR FROM dateposted)
FROM property_listings_clean