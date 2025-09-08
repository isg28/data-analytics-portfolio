-- Row count, years, regions
SELECT 
  COUNT(*) AS total_rows,
  COUNT(DISTINCT year) AS distinct_years,
  COUNT(DISTINCT region) AS distinct_regions,
  COUNT(DISTINCT type) AS distinct_types
FROM `avocado-analysis-sql.avocado.avocado_dataset`;



-- Which type sells more overall?
SELECT 
  type,
  SUM(`Total Volume`) AS total_volume
FROM `avocado-analysis-sql.avocado.avocado_dataset`
GROUP BY type
ORDER BY total_volume DESC;

-- Average price by region & type
SELECT
  region,
  type, 
  ROUND(AVG(AveragePrice)) As average_price
FROM `avocado-analysis-sql.avocado.avocado_dataset`
GROUP BY region, type
ORDER BY region, type

-- Monthly average price trend
SELECT 
  DATE_TRUNC(Date, MONTH) AS month, 
  type,
  ROUND(AVG(AveragePrice)) as average_price
FROM `avocado-analysis-sql.avocado.avocado_dataset`
GROUP BY month, type
ORDER BY month, type;


-- Which type sells the most (all the years combined)

WITH by_region AS (
  SELECT
    region,
    SUM(CASE WHEN type = 'organic' THEN `Total Volume` ELSE 0 END)  AS org_vol,
    SUM(CASE WHEN type = 'conventional' THEN `Total Volume` ELSE 0 END) AS conv_vol,
    SUM(`Total Volume`) AS total_vol
  FROM `avocado-analysis-sql.avocado.avocado_dataset`
  GROUP BY region
)
SELECT
  region,
  org_vol,
  conv_vol,
  total_vol,
  CASE
    WHEN conv_vol > org_vol THEN 'conventional'
    WHEN org_vol > conv_vol THEN 'organic'
    ELSE 'tie'
  END AS winner_type,
  ROUND(100 * GREATEST(org_vol, conv_vol) / NULLIF(total_vol, 0), 2) AS winner_share_pct,
  ROUND(GREATEST(org_vol, conv_vol) - LEAST(org_vol, conv_vol), 2) AS volume_margin
FROM by_region
ORDER BY volume_margin DESC;