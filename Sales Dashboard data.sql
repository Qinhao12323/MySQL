-- Sales Dashboard data

-- Q1: What is the monthly revenue trend

use classicmodels;

SELECT
	Date_Format(o.orderDate, "%Y-%M") AS month,
    SUM(od.quantityOrdered * od.priceEach) AS total_Sales
FROM
	orders o 
JOIN
	orderdetails od 
ON
	od.orderNumber = o.orderNumber
GROUP BY
	month
ORDER BY
	month desc;
    
-- Q2: What are the top 5 best-selling products by quantity? 

SELECT
	p.productName,
    SUM(od.quantityOrdered) AS totalVolume
FROM
	products p
JOIN
	orderdetails od
ON
	od.productCode = p.productCode
GROUP BY
	p.productName
ORDER BY
	totalVolume desc
LIMIT 
	5;
    
-- Q3: Which custoemr generated the most revenue? Rank the customer according to it.

SELECT
	p.customerNumber,
    c.customerName,
    SUM(p.amount) AS total_amount,
    rank() OVER( Order by sum(p.amount) DESC) AS revenueRank 
FROM
	payments p
JOIN 
	customers c
ON
	c.customerNumber = p.customerNumber
GROUP BY
	p.customerNumber;

-- Q4: What is the performance by each product line?

SELECT
	pl.textDescription,
    SUM(od.quantityOrdered*od.priceEach) AS total_revenue
FROM
	orderdetails od
JOIN
	products p
ON
	od.productCode = p.productCode
JOIN
	productLines pl
ON
	pl.productLine = p.productLine
GROUP BY
	pl.textDescription
ORDER BY
	total_revenue desc;
    
-- Q5: Profit analysis: product margin vs revenue
-- profit = quantity * (priceEach - buyPrice) 
-- revenue = quantity * priceEach

SELECT
	p.productName,
    SUM( od.quantityOrdered * (od.priceEach - p.buyPrice)) AS totalProfit,
    SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM
	products p
JOIN 
	orderdetails od
ON
	p.productCode = od.productCode
GROUP BY
	p.productName
ORDER BY
	totalProfit DESC;


