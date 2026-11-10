CREATE TABLE mortgage (
    zpid BIGINT,
    bucketType VARCHAR(100),
    rate NUMERIC,
    rateSource VARCHAR(100),
    lastUpdatedTimestamp TIMESTAMP,
    lastUpdatedDate VARCHAR(100) -- change this into date type after data import.
);

CREATE TABLE nearby_homes (
    zpid BIGINT,
    zpidComp BIGINT,
    addressComp VARCHAR(200),
    cityComp TEXT,
    stateComp TEXT,
    zipComp INT,
    priceComp INT,
    homeTypeComp TEXT,
    homeStatusComp TEXT,
    livingAreaValueComp INT,
    livingAreaUnitsComp TEXT,
    lotAreaValueComp INT,
    lotAreaUnitsComp TEXT,
    lastUpdated TIMESTAMP
);

CREATE TABLE price_history (
    zpid BIGINT,
    event TEXT,
    price INT,
    pricePerSquareFoot INT,
    priceChangeRate NUMERIC,
    dateOfEvent VARCHAR(100), -- change this into date type after data import.
    source TEXT,
    postingIsRental TEXT,
    lastUpdated TIMESTAMP
);

CREATE TABLE schools (
    zpid BIGINT,
    schoolName VARCHAR(200),
    schoolRating INT,
    type TEXT,
    gradeLevel TEXT,
    grades INT,
    distanceFromListing NUMERIC,
    link VARCHAR(250),
    lastUpdated TIMESTAMP
);

ALTER TABLE schools
ALTER COLUMN grades TYPE VARCHAR(100)

CREATE TABLE subtype (
    zpid BIGINT,
    is_FSBA TEXT,
    is_comingSoon TEXT,
    is_newHome TEXT,
    is_pending TEXT,
    is_forAuction TEXT,
    is_foreclosure TEXT,
    is_bankOwned TEXT,
    is_openHouse TEXT, 
    is_FSBO TEXT,
    lastUpdated TIMESTAMP 
);

CREATE TABLE listing_tax (
    zpid BIGINT,
    lastUpdatedTimestamp TIMESTAMP,
    lastUpdatedDate VARCHAR(100),
    valueIncreaseRate INT,
    taxIncreaseRate INT,
    taxPaid NUMERIC,
    propertyValue INT
);

CREATE TABLE property_listings (
    zpid BIGINT,
    price BIGINT,
    homeStatus TEXT,
    homeType TEXT,
    datePosted VARCHAR(100), -- change this into date type after data import.
    streetAddress VARCHAR(200),
    city TEXT,
    state TEXT,
    zipcode INT,
    county TEXT,
    yearBuilt VARCHAR(50),
    livingArea INT,
    livingAreaUnits TEXT,
    rentZestimate INT,
    bathrooms INT,
    bedrooms INT,
    pageViewCount INT,
    favoriteCount INT,
    propertyTaxRate NUMERIC,
    timeOnZillow VARCHAR(100),
    dateSold VARCHAR(100),
    url VARCHAR(250),
    lastUpdated TIMESTAMP
);

ALTER TABLE property_listings
ALTER COLUMN bathrooms TYPE NUMERIC

COPY mortgage
FROM 'C:\DA Projects\Real Estate SQL Project\Files\listing_mortgage_info.csv'
DELIMITER ',' CSV HEADER; -- fine

COPY nearby_homes
FROM 'C:\DA Projects\Real Estate SQL Project\Files\listing_nearby_homes.csv'
DELIMITER ',' CSV HEADER; -- fine

COPY price_history
FROM 'C:\DA Projects\Real Estate SQL Project\Files\listing_price_history.csv'
DELIMITER ',' CSV HEADER; -- fine

COPY schools
FROM 'C:\DA Projects\Real Estate SQL Project\Files\listing_schools_info.csv'
DELIMITER ',' CSV HEADER; -- fine

COPY subtype
FROM 'C:\DA Projects\Real Estate SQL Project\Files\listing_subtype.csv'
DELIMITER ',' CSV HEADER; -- fine

COPY listing_tax
FROM 'C:\DA Projects\Real Estate SQL Project\Files\listing_tax_info.csv'
DELIMITER ',' CSV HEADER; -- fine

COPY property_listings
FROM 'C:\DA Projects\Real Estate SQL Project\Files\property_listings.csv'
DELIMITER ',' CSV HEADER;

