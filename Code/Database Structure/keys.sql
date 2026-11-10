CREATE TABLE listing_tax_clean AS
SELECT DISTINCT *
FROM listing_tax;

CREATE TABLE mortgage_clean AS
SELECT DISTINCT *
FROM mortgage;

CREATE TABLE nearby_homes_clean AS
SELECT DISTINCT *
FROM nearby_homes;

CREATE TABLE schools_clean AS
SELECT DISTINCT *
FROM schools;

ALTER TABLE listing_tax_clean
ADD PRIMARY KEY (zpid, lastUpdatedTimestamp);

ALTER TABLE mortgage_clean
ADD PRIMARY KEY (zpid, bucketType, lastUpdatedTimestamp);

ALTER TABLE nearby_homes_clean
ADD PRIMARY KEY (zpid, zpidComp, lastUpdated);

ALTER TABLE schools_clean
ADD PRIMARY KEY (zpid, schoolName, lastUpdated);

ALTER TABLE subtype
ADD PRIMARY KEY (zpid);

ALTER TABLE property_listings_clean
ADD PRIMARY KEY (listing_id);

ALTER TABLE price_history
ADD PRIMARY KEY (price_history_id);

CREATE TABLE properties (
    zpid BIGINT PRIMARY KEY
);

INSERT INTO properties (zpid)
SELECT DISTINCT zpid
FROM property_listings_clean
WHERE zpid IS NOT NULL;

ALTER TABLE mortgage_clean
ADD CONSTRAINT fk_mortgage_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE price_history
ADD CONSTRAINT fk_price_history_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE schools_clean
ADD CONSTRAINT fk_schools_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE subtype
ADD CONSTRAINT fk_subtype_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE listing_tax_clean
ADD CONSTRAINT fk_listing_tax_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE property_listings_clean
ADD CONSTRAINT fk_property_listings_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE nearby_homes_clean
ADD CONSTRAINT fk_nearby_property
FOREIGN KEY (zpid)
REFERENCES properties(zpid);

ALTER TABLE nearby_homes_clean
ADD CONSTRAINT fk_nearby_comparison_property
FOREIGN KEY (zpidComp)
REFERENCES properties(zpid);

SELECT DISTINCT nh.zpidComp
FROM nearby_homes_clean nh
LEFT JOIN properties p
    ON nh.zpidComp = p.zpid
WHERE nh.zpidComp IS NOT NULL
  AND p.zpid IS NULL;

SELECT *
FROM nearby_homes_clean
WHERE zpidComp IN (
    SELECT DISTINCT nh.zpidComp
    FROM nearby_homes_clean nh
    LEFT JOIN properties p
        ON nh.zpidComp = p.zpid
    WHERE nh.zpidComp IS NOT NULL
      AND p.zpid IS NULL
);

SELECT COUNT(DISTINCT nh.zpidComp) AS missing_properties
FROM nearby_homes_clean nh
LEFT JOIN properties p
    ON nh.zpidComp = p.zpid
WHERE nh.zpidComp IS NOT NULL
  AND p.zpid IS NULL;

SELECT COUNT(DISTINCT zpid)
FROM nearby_homes_clean;

SELECT COUNT(DISTINCT zpidComp)
FROM nearby_homes_clean;

SELECT COUNT(DISTINCT zpid)
FROM properties;

SELECT COUNT(DISTINCT nh.zpidComp)
FROM nearby_homes_clean nh
JOIN property_listings_clean pl
    ON nh.zpidComp = pl.zpid;

SELECT COUNT(DISTINCT nh.zpid)
FROM nearby_homes_clean nh
JOIN properties p
    ON nh.zpid = p.zpid;

INSERT INTO properties (zpid)
SELECT DISTINCT zpidComp
FROM nearby_homes_clean
WHERE zpidComp IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM properties p
      WHERE p.zpid = nearby_homes_clean.zpidComp
  );

SELECT COUNT(DISTINCT nh.zpidComp) AS missing_comparison_properties
FROM nearby_homes_clean nh
LEFT JOIN properties p
    ON nh.zpidComp = p.zpid
WHERE nh.zpidComp IS NOT NULL
  AND p.zpid IS NULL;

ALTER TABLE nearby_homes_clean
ADD CONSTRAINT fk_nearby_comparison_property
FOREIGN KEY (zpidComp)
REFERENCES properties(zpid);