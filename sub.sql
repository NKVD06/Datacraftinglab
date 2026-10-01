--2--
SELECT 
    product_name, 
    total_amount
FROM 
    flourmills_sales
WHERE 
    total_amount > (
        SELECT AVG(total_amount) 
        FROM flourmills_sales
    );
;
--3--

SELECT sales_id, sale_date, region, product_category
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;

--4--
SELECT 
    product_name, 
    total_amount,
    (SELECT AVG(total_amount) FROM flourmills_sales) AS avg_amount
FROM 
    flourmills_sales;

SELECT product_name
FROM flourmills_sales
WHERE total_amount = 9511208.41;

--5--

SELECT
    product_name,
    total_amount,
    total_amount / (
        SELECT SUM(total_amount)
        FROM flourmills_sales
    ) AS amount_share
FROM flourmills_sales; 

--6--
SELECT 
    month,
    monthly_sales
FROM (
    SELECT 
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(total_amount) AS monthly_sales
    FROM 
        flourmills_sales
    GROUP BY 
        EXTRACT(MONTH FROM sale_date)
) AS monthly_summary
ORDER BY 
    monthly_sales DESC;

SELECT 
    SUM(total_amount) AS monthly_sales
FROM 
    flourmills_sales
WHERE 
    EXTRACT(MONTH FROM sale_date) = 8;
;
--7--
SELECT product_category, total_sales
FROM (
    SELECT
        product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS category_sales
WHERE total_sales > 50000000
ORDER BY total_sales DESC;

--8--
SELECT f1.product_name, f1.product_category, f1.total_amount
FROM flourmills_sales f1
WHERE f1.total_amount > (
    SELECT AVG(f2.total_amount)
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
);
--9--
SELECT
    sales.product_name,
    sales.region,
    sales.total_amount,
    (
        SELECT MIN(region_sales.total_amount)
        FROM flourmills_sales AS region_sales
        WHERE region_sales.region = sales.region
    ) AS region_min_amount
FROM flourmills_sales AS sales;

--10--
SELECT
    sales.product_name,
    sales.region,
    sales.total_amount,
    (
        SELECT MIN(region_sales.total_amount)
        FROM flourmills_sales AS region_sales
        WHERE region_sales.region = sales.region
    ) AS region_min_amount
FROM flourmills_sales AS sales;

--11--
SELECT f1.*
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 200000
);
--12--
SELECT DISTINCT f1.product_category
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
    GROUP BY f2.product_category
    HAVING COUNT(DISTINCT f2.region) > 3
);
--13--
SELECT *
FROM flourmills_sales AS outer_sales
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales AS inner_sales
    WHERE inner_sales.region = outer_sales.region
      AND EXTRACT(YEAR FROM inner_sales.sale_date) = 2024
);
--14--
SELECT DISTINCT f1.product_category
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 500000
);
SELECT COUNT(DISTINCT f1.product_category) AS pocet_kategorii
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 500000
);

--15--
SELECT DISTINCT region
FROM flourmills_sales AS outer_sales
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales AS inner_sales
    WHERE inner_sales.region = outer_sales.region
      AND inner_sales.product_category = 'Flour'
);