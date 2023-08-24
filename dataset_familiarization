--forest_area csv

SELECT COUNT(DISTINCT country_name) AS unique_countries 
FROM forest_area;

SELECT AVG(forest_area_sqkm) AS avg_forest_area_2016 
FROM forest_area 
WHERE year = 2016;

SELECT country_name, forest_area_sqkm 
FROM forest_area 
WHERE year = 2016 
ORDER BY forest_area_sqkm DESC 
LIMIT 5;

-- Landarea csv
SELECT COUNT(DISTINCT country_name) AS unique_countries 
FROM land_area;

SELECT AVG(total_area_sq_mi) AS avg_land_area_2016 
FROM land_area 
WHERE year = 2016;

SELECT country_name, total_area_sq_mi 
FROM land_area 
WHERE year = 2016 
ORDER BY total_area_sq_mi DESC LIMIT 5;


-- regions csv
SELECT COUNT(DISTINCT region) AS unique_regions 
FROM regions;

SELECT region, COUNT(country_name) AS number_of_countries 
FROM regions 
GROUP BY region;

SELECT country_name, region 
FROM regions 
WHERE country_name = 'India';
