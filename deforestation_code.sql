


DROP VIEW IF EXISTS forestation;

CREATE VIEW forestation AS

SELECT
  f.country_name,
  f.country_code,
  f.year,
  r.income_group,
  r.region,
  l.total_area_sq_mi,
  (total_area_sq_mi*2.59) as total_area_sq_km,
  f.forest_area_sqkm
FROM forest_area f
  INNER JOIN land_area l ON f.country_code = l.country_code AND f.year = l.year
  INNER JOIN regions r ON r.country_code = f.country_code
GROUP BY f.country_name, f.country_code,
f.year, r.income_group, r.region, l.total_area_sq_mi, f.forest_area_sqkm

-- Tester query --

SELECT *
FROM forestation

/*
1A) What was the total forest area (in sq km) of the world in 1990?
Please keep in mind that you can use the country record denoted
as “World" in the region table
*/

SELECT
  forest_area_sqkm
FROM forestation
WHERE year = 1990
  AND region = 'World'

41,282,694.9

/*
1B) What was the total forest area (in sq km) of the world in 2016?
Please keep in mind that you can use the country record in the table
is denoted as “World.”
*/

SELECT
  forest_area_sqkm
FROM forestation
WHERE year = 2016
  AND region = 'World'

or

SELECT
  forest_area_sqkm
FROM forestation
WHERE year = 2016
  AND country_name = 'World'

39,958,245.9

/*
1C) What was the change (in sq km) in the forest area of the
world from 1990 to 2016?
*/

SELECT(
  (SELECT
    SUM(forest_area_sqkm) AS total_forest_area
   FROM forestation
   WHERE year = 2016 AND country_name = 'World')-
  (SELECT
    SUM(forest_area_sqkm) AS total_forest_area
   FROM forestation
   WHERE year = 1990 AND country_name = 'World')) AS area_difference
FROM forestation
LIMIT 1

decrease of 1,324,449

/*
*1D) What was the percent change in forest area of the world
between 1990 and 2016?
*/

SELECT ROUND((((
    (SELECT SUM(forest_area_sqkm) AS total_forest_area
     FROM Forestation
     WHERE year = 2016
      AND country_name = 'World')-
    (SELECT SUM(forest_area_sqkm) AS total_forest_area
     FROM forestation
     WHERE YEAR = 1990
      AND country_name = 'World'))/(
        (SELECT SUM(forest_area_sqkm) AS total_forest_area
         FROM forestation
         WHERE year = 1990
         AND country_name = 'World')))*100):: NUMERIC,2) AS Percent_decrease
FROM forestation
LIMIT 1

DECREASE of 3.21
-3.21

/*
1E) If you compare the amount of forest area lost between 1990 and 2016, which
country's total area, in 2016, is it closest to?
*/

SELECT country_name,
  total_area_sq_km
FROM forestation
WHERE total_area_sq_km <= 1324449
GROUP BY country_name, total_area_sq_km
ORDER BY total_area_sq_km DESC
LIMIT 1

Peru	1,279,999.9891

---------------------------------------------

/*
2a. What was the percent of forest of the entire world in 2016?
Which region had the HIGHEST percent of forest in 2016, and
which had the LOWEST, to 2 decimal places?
*/

SELECT
  country_name,
	ROUND((SUM(forest_area_sqkm) /
  SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
FROM forestation
WHERE year = 2016
      AND country_name = 'World'
GROUP BY country_name;

31.38

SELECT
  region,
	ROUND((SUM(forest_area_sqkm) /
    SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
FROM forestation
WHERE year = 2016
GROUP BY region
ORDER BY forest_percentage DESC

Latin America & Caribbean	46.16
Middle East & North Africa	2.07

/*
2b. What was the percent forest of the entire world in 1990?
Which region had the HIGHEST percent forest in 1990, and which had the LOWEST,
to 2 decimal places?
*/

SELECT
  country_name,
	ROUND((Sum(forest_area_sqkm) /
    SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
FROM forestation
WHERE year = 1990
      AND country_name = 'World'
GROUP BY country_name;
32.42

SELECT
  region,
	ROUND((SUM(forest_area_sqkm) /
    SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
FROM forestation
WHERE year = 1990
GROUP BY region
ORDER BY forest_percentage DESC

Latin America & Caribbean	51.03
Middle East & North Africa	1.78

/*
2c. Based on the table you created, which regions of the world DECREASED in
forest area from 1990 to 2016?
*/

WITH t1 AS
  (SELECT
    region,
  	ROUND((Sum(forest_area_sqkm) /
      Sum(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
   FROM forestation
   WHERE year = 1990
   GROUP BY region
   ORDER BY forest_percentage DESC),

  t2 AS
  (SELECT
    region,
  	ROUND((Sum(forest_area_sqkm) /
      Sum(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
   FROM forestation
   WHERE year = 2016
   GROUP BY region
   ORDER BY forest_percentage DESC)

SELECT
  t1.region,
	t1.forest_percentage AS forest_1990,
  t2.forest_percentage AS forest_2016,
  (t2.forest_percentage - t1.forest_percentage) AS forest_change
FROM t1
  RIGHT JOIN t2 ON t1.region = t2.region
ORDER BY forest_change ASC

Results =
Latin America & Caribbean	51.03, 46.16,	-4.87
Sub-Saharan Africa	      30.67, 28.79,	-1.88
World	                    32.42, 31.38,	-1.04

Latin America & Caribbean and Sub-Saharan Africa. = Answer

Full Answer per review =

East Asia & Pacific	        25.78	26.36
Europe & Central Asia	      37.28	38.04
Latin America & Caribbean	  51.03	46.16
Middle East & North Africa	1.78	2.07
North America	              35.65	36.04
South Asia	                16.51	17.51
Sub-Saharan Africa	        30.67	28.79
World	                      32.42	31.38

------------------------------------


SUCCESS STORIES

3.A part 1

WITH T1 AS
  (SELECT
      country_name,
      forest_area_sqkm
    FROM forestation
    WHERE year = 1990
      AND forest_area_sqkm IS NOT NULL),

  T2 AS
    (SELECT
        country_name,
        forest_area_sqkm
      FROM forestation
      WHERE year = 2016
        AND forest_area_sqkm IS NOT NULL)

SELECT
  f.country_name,
  (t.forest_area_sqkm - f.forest_area_sqkm) AS forest_change,
  ROUND((((t.forest_area_sqkm - f.forest_area_sqkm)/
    f.forest_area_sqkm)*100)::NUMERIC,2) AS percent_change
FROM T1 f
INNER JOIN T2 t ON f.country_name = t.country_name
ORDER BY forest_change DESC

China	        527,229.062 sqkm  33.55 percent
United States	79,200 sqkm       2.62 percent

3.A part 2

WITH T1 AS
  (SELECT
      country_name,
      forest_area_sqkm
    FROM forestation
    WHERE year = 1990
      AND forest_area_sqkm IS NOT NULL),

  T2 AS
    (SELECT
        country_name,
        forest_area_sqkm
      FROM forestation
      WHERE year = 2016
        AND forest_area_sqkm IS NOT NULL)

SELECT
  f.country_name,
  (t.forest_area_sqkm - f.forest_area_sqkm) AS forest_change,
  ROUND((((t.forest_area_sqkm - f.forest_area_sqkm)/
    f.forest_area_sqkm)*100)::NUMERIC,2) AS percent_change
FROM T1 f
INNER JOIN T2 t ON f.country_name = t.country_name
ORDER BY percent_change DESC

Iceland	343.9999962	213.66 percent

/*
3a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016?
What was the difference in forest area for each?
*/

WITH T1 AS
  (SELECT
      country_name,
      region,
      forest_area_sqkm
    FROM forestation
    WHERE year = 1990
      AND forest_area_sqkm IS NOT NULL
    GROUP BY country_name, region, forest_area_sqkm),

  T2 AS
    (SELECT
      country_name,
      region,
      forest_area_sqkm
    FROM forestation
    WHERE year = 2016
      AND forest_area_sqkm IS NOT NULL
    GROUP BY country_name, region, forest_area_sqkm)

SELECT
  f.country_name,
	f.region,
  ROUND((t.forest_area_sqkm - f.forest_area_sqkm)::NUMERIC,2) AS forest_change
FROM T1 f
LEFT JOIN T2 t ON f.country_name = t.country_name
WHERE f.country_name != 'World'
ORDER BY forest_change
LIMIT 5

Brazil	    Latin America & Caribbean	-541510
Indonesia	  East Asia & Pacific	      -282193.9844
Myanmar	    East Asia & Pacific	      -107234.0039
Nigeria	    Sub-Saharan Africa	      -106506.00098
Tanzania	  Sub-Saharan Africa	      -102320

/*
3b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016?
What was the percent change to 2 decimal places for each?
*/

WITH T1 AS
  (SELECT
      country_name,
      region,
      forest_area_sqkm
    FROM forestation
    WHERE year = 1990
      AND forest_area_sqkm IS NOT NULL
    GROUP BY country_name, region, forest_area_sqkm),

  T2 AS
    (SELECT
      country_name,
      region,
      forest_area_sqkm
    FROM forestation
    WHERE year = 2016
      AND forest_area_sqkm IS NOT NULL
    GROUP BY country_name, region, forest_area_sqkm)

SELECT
  f.country_name,
	f.region,
  (t.forest_area_sqkm - f.forest_area_sqkm) AS forest_change,
  ROUND((((t.forest_area_sqkm - f.forest_area_sqkm)/
    f.forest_area_sqkm)*100)::NUMERIC,2) AS percent_change
FROM T1 f
LEFT JOIN T2 t ON f.country_name = t.country_name
ORDER BY percent_change
LIMIT 5

Togo	     Sub-Saharan Africa	       -5168.000031	  -75.45
Nigeria	   Sub-Saharan Africa	       -106506.00098	-61.80
Uganda	   Sub-Saharan Africa	       -28091.99951	  -59.13
Mauritania Sub-Saharan Africa	       -1940	        -46.75
Honduras	 Latin America & Caribbean -36640	        -45.03

/*
3c. If countries were grouped by percent forestation in quartiles, which group had the
most countries in it in 2016?
*/

WITH t1 AS
  (SELECT
      country_name,
      year,
      ROUND((SUM(forest_area_sqkm) /
        SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
   FROM forestation
   WHERE year = 2016
   GROUP BY country_name, year, forest_area_sqkm)

SELECT
  Distinct(quartiles),
  COUNT(country_name) OVER(PARTITION BY quartiles)
FROM
  (SELECT country_name,
    CASE WHEN forest_percentage <=25 THEN 'Q1'
    WHEN forest_percentage >= 25 AND forest_percentage <=50 THEN 'Q2'
    WHEN forest_percentage >= 50 AND forest_percentage <=75 THEN 'Q3'
    ELSE 'Q4' END AS quartiles
   FROM T1
   WHERE forest_percentage IS NOT NULL
    AND year = 2016 AND country_name != 'World') AS snickers

quartiles = Q1

/*
3d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
*/

WITH t2 AS
(WITH t1 AS
    (SELECT
     country_name,
     year,
     forest_area_sqkm,
     total_area_sq_mi,
     region,
        ROUND((SUM(forest_area_sqkm) /
          SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
     FROM forestation
     WHERE year = 2016
     GROUP BY country_name, year, forest_area_sqkm, total_area_sq_mi, region)

    SELECT
        quartiles,
    	  country_name,
        forest_area_sqkm,
        total_area_sq_mi,
        region
    FROM
      (SELECT
        country_name,
        forest_area_sqkm,
        total_area_sq_mi,
        region,
          CASE WHEN forest_percentage < 25 THEN 'Q1'
          WHEN forest_percentage >= 25 AND forest_percentage <=50 THEN 'Q2'
          WHEN forest_percentage >= 50 AND forest_percentage <=75 THEN 'Q3'
          ELSE 'Q4' END AS quartiles
       FROM T1
       WHERE forest_percentage IS NOT NULL
        AND year = 2016 AND country_name != 'World') AS snickers)

SELECT
  country_name,
  quartiles,
  region,
  ROUND((SUM(forest_area_sqkm) /
    SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
FROM t2
WHERE quartiles = 'Q4'
GROUP BY country_name, quartiles, region
ORDER BY forest_percentage DESC

Suriname	              Latin America & Caribbean	98.26
Micronesia, Fed. Sts.		East Asia & Pacific	91.86
Gabon		                Sub-Saharan Africa	90.04
Seychelles		          Sub-Saharan Africa	88.41
Palau		                East Asia & Pacific	87.61
American Samoa		      East Asia & Pacific	87.50
Guyana		              Latin America & Caribbean	83.90
Lao PDR		              East Asia & Pacific	82.11
Solomon Islands		      East Asia & Pacific	77.86

/*
3e. How many countries had a percent forestation higher than the United States in 2016?
*/

SELECT
    country_name,
  	ROUND((SUM(forest_area_sqkm) /
      SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
FROM forestation
WHERE year = 2016
  AND country_name = 'United States'
GROUP BY country_name

33.93 percent

WITH t1 AS
  (SELECT
    country_name,
  	ROUND((SUM(forest_area_sqkm) /
      SUM(total_area_sq_mi*2.59)*100):: NUMERIC,2) AS forest_percentage
  FROM forestation
  WHERE year = 2016
  GROUP BY country_name)

SELECT COUNT(country_name) AS higher_than_US
FROM t1
WHERE forest_percentage IS NOT NULL
	AND forest_percentage >= 34

count = 94
