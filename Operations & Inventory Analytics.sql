-- Operations & Inventory Analytics

Use classicmodels;

-- Insight about Low-stock product alerts

SELECT
	productCode,
    ProductName,
    quantityInStock,
    CASE
		WHEN quantityInStock < 50 THEN "Critical"
        WHEN quantityInStock < 100 THEN "Low"
        ELSE "Sufficient"
	END AS inventoryStatus
FROM 
	products
ORDER BY
	quantityInStock ASC;
    
-- Q2: What is the maximum, minimum and average order fulfillment time?
-- fulfillment time = shippedDate - orderDate 
SELECT
    AVG(DATEDIFF(shippedDate, orderDate)) AS avgfulfillmentDays,
    MAX(DATEDIFF(shippedDate, orderDate)) AS slowest,
    MIN(DATEDIFF(shippedDate, orderDate)) AS fastest
FROM
	orders
WHERE 
	DATEDIFF(shippedDate, orderDate) IS NOT NULL;
    
-- Q3: Detect potential bakcorders

SELECT 
    od.orderNumber,
    od.productCode,
    p.productName,
    od.quantityOrdered,
    p.quantityInStock,
    (od.quantityOrdered - p.quantityInStock) AS shortage
FROM 
	orderdetails od
JOIN 
	products p ON od.productCode = p.productCode
WHERE 
	od.quantityOrdered > p.quantityInStock;

-- Q4: What are the total product counts at risk of backorder?

SELECT 
    COUNT(*) AS backorderItems,
    SUM(od.quantityOrdered - p.quantityInStock) AS totalShortageUnits
FROM 
	orderdetails od
JOIN 
	products p ON od.productCode = p.productCode
WHERE 
	od.quantityOrdered > p.quantityInStock;
