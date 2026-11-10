-- Do highly rated schools correlate with higher property prices?
CREATE VIEW school_rate AS 
SELECT 
    p.zpid,
    p.price,
    s.schoolname,
    s.schoolrating,
    s.type
FROM property_listings_clean p
LEFT JOIN schools_clean s ON p.zpid = s.zpid


