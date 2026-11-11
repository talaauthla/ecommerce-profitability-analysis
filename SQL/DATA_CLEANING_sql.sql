CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;


CREATE TABLE orders_clean_v2 AS
SELECT *
FROM orders_corrected;

SELECT *
FROM orders_clean_v2
LIMIT 20;

-- check whether every Row ID is unique:
SELECT COUNT( DISTINCT `ROW ID`) , COUNT(*)
FROM orders_clean_v2;

-- check for duplicate records
SELECT `order id`, `order date`, `ship date`,`customer id`,`product id`,count(*) as occurrences
FROM orders_clean_v2
GROUP BY `order id`, `order date`, `ship date`,`customer id`,`product id`
HAVING occurrences >1;

-- further investigating potential duplicates
SELECT 
`order id`,
 `order date`,
 `ship date`,
 `customer id`,
 `product id`,
 count(*) as occurrences,
 COUNT(DISTINCT `ship mode`),
 COUNT(DISTINCT `customer name`),
 COUNT(DISTINCT segment),
 COUNT(DISTINCT country),
 COUNT(DISTINCT city),
 COUNT(DISTINCT state),
 COUNT(DISTINCT `postal code`),
 COUNT(DISTINCT region),
 COUNT(DISTINCT category),
 COUNT(DISTINCT `sub-category`),
 COUNT(DISTINCT `product name`),
 COUNT(DISTINCT sales),
 COUNT(DISTINCT quantity),
 COUNT(DISTINCT discount),
 COUNT(DISTINCT profit)
FROM orders_clean_v2
GROUP BY `order id`, `order date`, `ship date`,`customer id`,`product id`
HAVING occurrences >1;

-- dound this exact duplicate
SELECT *
FROM orders_clean_v2
WHERE `order id`= 'US-2014-150119' AND 
      `product id` ='FUR-CH-10002965';
      
-- deleting the exact duplicate
SET SQL_SAFE_UPDATES = 0;

DELETE FROM orders_clean_v2
WHERE `row id`='3407';

-- check for missing values
SELECT SUM(CASE WHEN `ROW ID` IS NULL THEN 1 ELSE 0 END) AS MISSING_ROWID,
	   SUM(CASE WHEN `ORDER ID` IS NULL THEN 1 ELSE 0 END) AS MISSING_ORDERID,
       SUM(CASE WHEN `ORDER DATE` IS NULL THEN 1 ELSE 0 END) AS MISSING_ORDERDATE,
       SUM(CASE WHEN `SHIP DATE` IS NULL THEN 1 ELSE 0 END) AS MISSING_SHIPDATE,
       SUM(CASE WHEN `SHIP MODE` IS NULL THEN 1 ELSE 0 END) AS MISSING_SHIPMODE,
       SUM(CASE WHEN `CUSTOMER ID` IS NULL THEN 1 ELSE 0 END) AS MISSING_CUSTOMERID,
       SUM(CASE WHEN `CUSTOMER NAME` IS NULL THEN 1 ELSE 0 END) AS MISSING_CUSTOMERNAME,
       SUM(CASE WHEN `SEGMENT` IS NULL THEN 1 ELSE 0 END) AS MISSING_SEGMENT,
       SUM(CASE WHEN `COUNTRY` IS NULL THEN 1 ELSE 0 END) AS MISSING_COUNTRY,
       SUM(CASE WHEN `CITY` IS NULL THEN 1 ELSE 0 END) AS MISSING_CITY,
       SUM(CASE WHEN `STATE` IS NULL THEN 1 ELSE 0 END) AS MISSING_STATE,
        SUM(CASE WHEN `Postal Code` IS NULL THEN 1 ELSE 0 END) AS missing_postal_code,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS missing_region,
    SUM(CASE WHEN `Product ID` IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN `Sub-Category` IS NULL THEN 1 ELSE 0 END) AS missing_sub_category,
    SUM(CASE WHEN `Product Name` IS NULL THEN 1 ELSE 0 END) AS missing_product_name,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS missing_discount,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS missing_profit
FROM orders_clean_v2;
       
-- check for empty spaces
SELECT 
     SUM(CASE WHEN TRIM(`row id`)='' THEN 1 ELSE 0 END) AS empty_rowid,
     SUM(CASE WHEN TRIM(`Order ID`) = '' THEN 1 ELSE 0 END) AS empty_order_id,
    SUM(CASE WHEN TRIM(`Order Date`) = '' THEN 1 ELSE 0 END) AS empty_order_date,
    SUM(CASE WHEN TRIM(`Ship Date`) = '' THEN 1 ELSE 0 END) AS empty_ship_date,
    SUM(CASE WHEN TRIM(`Ship Mode`) = '' THEN 1 ELSE 0 END) AS empty_ship_mode,
    SUM(CASE WHEN TRIM(`Customer ID`) = '' THEN 1 ELSE 0 END) AS empty_customer_id,
    SUM(CASE WHEN TRIM(`Customer Name`) = '' THEN 1 ELSE 0 END) AS empty_customer_name,
    SUM(CASE WHEN TRIM(Segment) = '' THEN 1 ELSE 0 END) AS empty_segment,
    SUM(CASE WHEN TRIM(Country) = '' THEN 1 ELSE 0 END) AS empty_country,
    SUM(CASE WHEN TRIM(City) = '' THEN 1 ELSE 0 END) AS empty_city,
    SUM(CASE WHEN TRIM(State) = '' THEN 1 ELSE 0 END) AS empty_state,
    SUM(CASE WHEN TRIM(`Postal Code`) = '' THEN 1 ELSE 0 END) AS empty_postal_code,
    SUM(CASE WHEN TRIM(Region) = '' THEN 1 ELSE 0 END) AS empty_region,
    SUM(CASE WHEN TRIM(`Product ID`) = '' THEN 1 ELSE 0 END) AS empty_product_id,
    SUM(CASE WHEN TRIM(Category) = '' THEN 1 ELSE 0 END) AS empty_category,
    SUM(CASE WHEN TRIM(`Sub-Category`) = '' THEN 1 ELSE 0 END) AS empty_sub_category,
    SUM(CASE WHEN TRIM(`Product Name`) = '' THEN 1 ELSE 0 END) AS empty_product_name,
    SUM(CASE WHEN TRIM(Sales) = '' THEN 1 ELSE 0 END) AS empty_sales,
    SUM(CASE WHEN TRIM(Quantity) = '' THEN 1 ELSE 0 END) AS empty_quantity,
    SUM(CASE WHEN TRIM(Discount) = '' THEN 1 ELSE 0 END) AS empty_discount,
    SUM(CASE WHEN TRIM(Profit) = '' THEN 1 ELSE 0 END) AS empty_profit
FROM orders_clean_v2;

-- Check leading and trailing whitespace
SELECT
    SUM(`Row ID` <> TRIM(`Row ID`)) AS row_id_spaces,
    SUM(`Order ID` <> TRIM(`Order ID`)) AS order_id_spaces,
    SUM(`Order Date` <> TRIM(`Order Date`)) AS order_date_spaces,
    SUM(`Ship Date` <> TRIM(`Ship Date`)) AS ship_date_spaces,
    SUM(`Ship Mode` <> TRIM(`Ship Mode`)) AS ship_mode_spaces,
    SUM(`Customer ID` <> TRIM(`Customer ID`)) AS customer_id_spaces,
    SUM(`Customer Name` <> TRIM(`Customer Name`)) AS customer_name_spaces,
    SUM(Segment <> TRIM(Segment)) AS segment_spaces,
    SUM(Country <> TRIM(Country)) AS country_spaces,
    SUM(City <> TRIM(City)) AS city_spaces,
    SUM(State <> TRIM(State)) AS state_spaces,
    SUM(`Postal Code` <> TRIM(`Postal Code`)) AS postal_code_spaces,
    SUM(Region <> TRIM(Region)) AS region_spaces,
    SUM(`Product ID` <> TRIM(`Product ID`)) AS product_id_spaces,
    SUM(Category <> TRIM(Category)) AS category_spaces,
    SUM(`Sub-Category` <> TRIM(`Sub-Category`)) AS sub_category_spaces,
    SUM(`Product Name` <> TRIM(`Product Name`)) AS product_name_spaces,
    SUM(Sales <> TRIM(Sales)) AS sales_spaces,
    SUM(Quantity <> TRIM(Quantity)) AS quantity_spaces,
    SUM(Discount <> TRIM(Discount)) AS discount_spaces,
    SUM(Profit <> TRIM(Profit)) AS profit_spaces
FROM orders_clean_v2;

-- Validate date columns
SELECT
    SUM(
        CASE WHEN STR_TO_DATE(`Order Date`, '%m/%d/%Y') IS NULL
        THEN 1 ELSE 0 END
    ) AS invalid_order_dates,

    SUM(
        CASE WHEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y') IS NULL
        THEN 1 ELSE 0 END
    ) AS invalid_ship_dates,

    SUM(
        CASE WHEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
             < STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        THEN 1 ELSE 0 END
    ) AS ship_before_order

FROM orders_clean_v2;

-- Validate numeric columns
SELECT
    SUM(CASE WHEN Sales NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
        THEN 1 ELSE 0 END) AS invalid_sales,

    SUM(CASE WHEN Quantity NOT REGEXP '^[0-9]+$'
        THEN 1 ELSE 0 END) AS invalid_quantity,

    SUM(CASE WHEN Discount NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
        THEN 1 ELSE 0 END) AS invalid_discount,

    SUM(CASE WHEN Profit NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
        THEN 1 ELSE 0 END) AS invalid_profit

FROM orders_clean_v2;

-- Standardization — categorical values
SELECT 'ship mode' AS column_name, `ship mode` AS value, COUNT(*) AS records
FROM orders_clean_V2
GROUP BY 1,2

UNION ALL

SELECT 'segment', `segment`, count(*)
FROM orders_clean_V2
GROUP BY 1,2

UNION ALL 


SELECT 'Country', Country, COUNT(*)
FROM orders_clean_v2
GROUP BY Country

UNION ALL

SELECT 'Region', Region, COUNT(*)
FROM orders_clean_v2
GROUP BY Region

UNION ALL

SELECT 'Category', Category, COUNT(*)
FROM orders_clean_v2
GROUP BY Category

UNION ALL

SELECT 'Sub-Category', `Sub-Category`, COUNT(*)
FROM orders_clean_v2
GROUP BY `Sub-Category`;

-- text columns standerization
SELECT
    LOWER(TRIM(City)) AS normalized_city,
    COUNT(DISTINCT City) AS variations,
    GROUP_CONCAT(DISTINCT City) AS original_values
FROM orders_clean_v2
GROUP BY LOWER(TRIM(City))
HAVING COUNT(DISTINCT City) > 1;

SELECT
    LOWER(TRIM(State)) AS normalized_state,
    COUNT(DISTINCT State) AS variations,
    GROUP_CONCAT(DISTINCT State) AS original_values
FROM orders_clean_v2
GROUP BY LOWER(TRIM(State))
HAVING COUNT(DISTINCT State) > 1;

SELECT
    LOWER(TRIM(`Product Name`)) AS normalized_name,
    COUNT(DISTINCT `Product Name`) AS variations,
    GROUP_CONCAT(DISTINCT `Product Name`) AS original_values
FROM orders_clean_v2
GROUP BY LOWER(TRIM(`Product Name`))
HAVING COUNT(DISTINCT `Product Name`) > 1;

SELECT
    LOWER(TRIM(`Customer Name`)) AS normalized_name,
    COUNT(DISTINCT `Customer Name`) AS variations,
    GROUP_CONCAT(DISTINCT `Customer Name`) AS original_values
FROM orders_clean_v2
GROUP BY LOWER(TRIM(`Customer Name`))
HAVING COUNT(DISTINCT `Customer Name`) > 1;

-- data consistency checks
-- Check whether one Customer ID has multiple names
SELECT `customer id`, COUNT(DISTINCT `customer name`) as associated_names
FROM orders_clean_v2
GROUP BY 1
having associated_names>1;

-- check whether once name has multiple customer ids
SELECT `Customer Name`, COUNT(DISTINCT `Customer ID`) AS associated_ids
FROM orders_clean_v2
GROUP BY 1
HAVING associated_ids > 1;

-- Check whether one product ID has multiple names
SELECT `Product ID`, COUNT(DISTINCT `Product Name`) AS name_variations
FROM orders_clean_v2
GROUP BY 1
HAVING name_variations > 1;

-- investingating
SELECT `product id`, `Product Name`
FROM orders_clean_v2
where `product id` = 'FUR-FU-10004017';

-- quantifiying the issue 
SELECT
    COUNT(*) AS affected_records
FROM orders_clean_v2 AS o
JOIN (
    SELECT `Product ID`
    FROM orders_clean_v2
    GROUP BY `Product ID`
    HAVING COUNT(DISTINCT `Product Name`) > 1
) AS inconsistent_products
ON o.`Product ID` = inconsistent_products.`Product ID`;

-- Check whether one product name has multiple ids
 SELECT `Product name`, COUNT(DISTINCT `Product id`) AS name_variations
FROM orders_clean_v2
GROUP BY 1
HAVING name_variations > 1;

-- geographical consistency 
-- checking whether a post cose is associated with more than 1 city
SELECT `postal code`, COUNT(DISTINCT city) AS cities
FROM orders_clean_v2
GROUP BY 1
HAVING cities>1;

-- invistigating
SELECT DISTINCT
    `Postal Code`,
    City,
    State
FROM orders_clean_v2
WHERE `Postal Code` = '92024';

-- checking whether a city is associated with more than 1 post code
SELECT city, COUNT(DISTINCT `postal code`) AS codes
FROM orders_clean_v2
GROUP BY 1
HAVING codes>1;


-- check whether a city is associated with more than once country
SELECT city, count(distinct state) as states
FROM orders_clean_v2
GROUP BY 1
HAVING states>1;

-- creating a final table with the correct data type
CREATE TABLE orders_final (
    `Row ID` INT,
    `Order ID` VARCHAR(20),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(30),
    `Customer ID` VARCHAR(20),
    `Customer Name` VARCHAR(100),
    Segment VARCHAR(30),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    `Postal Code` VARCHAR(20),
    Region VARCHAR(20),
    `Product ID` VARCHAR(30),
    Category VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(255),
    Sales DECIMAL(12,4),
    Quantity INT,
    Discount DECIMAL(5,4),
    Profit DECIMAL(12,4)
);

INSERT INTO orders_final (
    `Row ID`, `Order ID`, `Order Date`, `Ship Date`,
    `Ship Mode`, `Customer ID`, `Customer Name`, Segment,
    Country, City, State, `Postal Code`, Region,
    `Product ID`, Category, `Sub-Category`, `Product Name`,
    Sales, Quantity, Discount, Profit
)
SELECT
    CAST(`Row ID` AS UNSIGNED),
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y'),
    `Ship Mode`,
    `Customer ID`,
    `Customer Name`,
    Segment,
    Country,
    City,
    State,
    `Postal Code`,
    Region,
    `Product ID`,
    Category,
    `Sub-Category`,
    `Product Name`,
    CAST(Sales AS DECIMAL(12,4)),
    CAST(Quantity AS UNSIGNED),
    CAST(Discount AS DECIMAL(5,4)),
    CAST(Profit AS DECIMAL(12,4))
FROM orders_clean_v2;

SELECT *
FROM orders_final
limit 30;

DESCRIBE orders_final;