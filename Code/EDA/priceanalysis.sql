-- Which properties experienced the largest price changes?

WITH price_change AS (
    SELECT 
        zpid,
        price,
        LAG(price) OVER(
            PARTITION BY zpid
            ORDER BY dateofevent) AS before_price,
        dateofevent
    FROM price_history
    WHERE price IS NOT NULL 
    ORDER BY zpid, dateofevent
)

SELECT 
    zpid,
    price,
    before_price,
    ROUND(((price-before_price)::NUMERIC/before_price)*100, 2) AS price_change_percent,
    dateofevent
FROM price_change
WHERE before_price <> 0 AND 
    ROUND(((price-before_price)::NUMERIC/before_price)*100, 2) <> 0

-- How long after price reductions did properties sell?

SELECT
    zpid,
    COUNT(*)
FROM price_history
GROUP BY zpid
HAVING COUNT(*) > 1

SELECT *
FROM price_history

-- How have property prices changed over time?

ALTER TABLE price_history
ALTER COLUMN dateofevent TYPE DATE
USING NULLIF(TRIM(dateofevent), '')::DATE;

SELECT 
    EXTRACT(YEAR FROM dateofevent) AS Year,
    EXTRACT(MONTH FROM dateofevent) AS Month,
    ROUND(AVG(price), 0) AS avg_price
FROM price_history
WHERE price IS NOT NULL
GROUP BY 
    EXTRACT(YEAR FROM dateofevent),
    EXTRACT(MONTH FROM dateofevent)

CREATE VIEW pricehistMED AS
SELECT
    zpid,
    dateofevent,
    PERCENTILE_CONT(0.5) 
            WITHIN GROUP (ORDER BY price) AS median_price
FROM price_history
WHERE price IS NOT NULL 
GROUP BY zpid, dateofevent

SELECT *
FROM price_history
WHERE EXTRACT(YEAR FROM dateofevent) = '1987'

-- price distribution
CREATE VIEW pricerange AS 
SELECT
    zpid,
    dateofevent,
    ROUND(AVG(price), 0) AS avg_price,
    CASE 
        WHEN price BETWEEN 0 AND 100000 THEN '0 - $100,000'
        WHEN price BETWEEN 100000 AND 200000 THEN '$100,000 - $200,000'
        WHEN price BETWEEN 200000 AND 300000 THEN '$200,000 - $300,000'
        WHEN price BETWEEN 300000 AND 400000 THEN '$300,000 - $400,000'
        WHEN price BETWEEN 400000 AND 500000 THEN '$400,000 - 500,000'
        WHEN price BETWEEN 500000 AND 600000 THEN '$500,000 - $600,000'
        WHEN price BETWEEN 600000 AND 700000 THEN '$600,000 - $700,000'
        WHEN price BETWEEN 700000 AND 800000 THEN '$700,000 - $800,000'
        WHEN price BETWEEN 800000 AND 900000 THEN '$800,000 - $900,000'
        WHEN price BETWEEN 900000 AND 1000000 THEN '$900,000 - $1 Million'
        WHEN price BETWEEN 1000000 AND 2000000 THEN '$1 - $2 Million'
        WHEN price BETWEEN 2000000 AND 3000000 THEN '$2 - $3 Million'
        WHEN price BETWEEN 3000000 AND 4000000 THEN '$3 - $4 Million'
        WHEN price BETWEEN 4000000 AND 5000000 THEN '$4 - $5 Million'
        WHEN price BETWEEN 5000000 AND 6000000 THEN '$5 - $6 Million'
        WHEN price BETWEEN 6000000 AND 7000000 THEN '$6 - $7 Million'
        WHEN price BETWEEN 7000000 AND 8000000 THEN '$7 - $8 Million'
        WHEN price BETWEEN 8000000 AND 9000000 THEN '$8 - $9 Million'
        WHEN price BETWEEN 9000000 AND 10000000 THEN '$9 - $10 Million'
        WHEN price BETWEEN 10000000 AND 20000000 THEN '$10 - $20 Million'
        WHEN price BETWEEN 20000000 AND 30000000 THEN '$20 - $30 Million'
        WHEN price BETWEEN 30000000 AND 40000000 THEN '$30 - $40 Million'
        WHEN price BETWEEN 40000000 AND 50000000 THEN '$40 - $50 Million'
        WHEN price BETWEEN 50000000 AND 60000000 THEN '$50 - $60 Million'
        WHEN price BETWEEN 60000000 AND 70000000 THEN '$60 - $70 Million'
        WHEN price BETWEEN 70000000 AND 80000000 THEN '$70 - $80 Million'
        WHEN price BETWEEN 80000000 AND 90000000 THEN '$80 - $90 Million'
        WHEN price BETWEEN 90000000 AND 100000000 THEN '$90 - $100 Million'
        WHEN price BETWEEN 100000000 AND 500000000 THEN '$100 Million +'
        ELSE 'No Cost'
    END AS PriceRange
FROM price_history
WHERE price IS NOT NULL
GROUP BY zpid, dateofevent, price


SELECT
    price 
FROM price_history
WHERE price > 100000000
    
