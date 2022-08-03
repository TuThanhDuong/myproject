-- MySQL version used: 8.0.28
-- Credit for  this Adventureworks dummy dataset:
	-- The link to this dataset is incorporated in this blog post by Maz Nguyen:
	-- https://madzynguyen.com/xay-dung-portfolio-cho-data-analyst-thanh-thao-sql/
    
-- Some assumptions: 
	#1 The current year is 2018
    	#2 profit = Number of products sold * (product_price - product_cost) = (Number of ordered products - Number of returned products) * (product_price - product_cost)
	#3 For simplicity, queries are only in year 2015 (replace sales_2015 by those of 2016 and 2017 to extract the data of the following years)

-- Some Questions for exploratory data analysis
#1 Is there any noticable shift in demographics (age, education, income, etc.) of customers from 2015 to 2017?

	#1.1 Customers marital status over the years?
SELECT b.Marital_Status, COUNT(DISTINCT a. customer_key) AS 'Number of customers'
FROM sales_2015 a
JOIN customers b
	ON a.Customer_Key = b.Customer_Key
GROUP BY Marital_Status;
    
	#1.2 Customers education_level  over the years?
SELECT b.Education_level, COUNT(DISTINCT a.customer_key) AS 'Number of customers'
FROM sales_2015 a
JOIN customers b
	ON a.Customer_Key = b.Customer_Key
GROUP BY Education_level
ORDER BY COUNT(DISTINCT a. customer_key) DESC;
    
	#1.3 Customers occcupations over the years?
SELECT b.Occupation, COUNT(DISTINCT a. customer_key) AS 'Number of Customers'
FROM sales_2017 a
JOIN customers b
	ON a.Customer_Key = b.Customer_Key
GROUP BY b.Occupation
ORDER BY COUNT(DISTINCT a. customer_key) DESC;

	#1.4 The number of customers of each age group in 2015, 2016, and 2017 (ages are grouped into 4 ranges)
SELECT 
CASE 
	WHEN 2018 - YEAR(Birth_Date) < 40 THEN 'Under 40'
        WHEN 2018 - YEAR(Birth_Date) BETWEEN 40 AND 50 THEN 'Age 40-50'
        WHEN 2018 - YEAR(Birth_Date) BETWEEN 51 AND 60 THEN 'Age 51-60'
        ELSE 'Elderly'
	END AS 'Age group',
 COUNT(DISTINCT a.Customer_Key) AS 'Number of customers'
FROM sales_2015 a
JOIN customers b
	ON a.Customer_Key = b.Customer_Key
GROUP BY 
CASE 
	WHEN 2018 - YEAR(Birth_Date) < 40 THEN 'Under 40'
        WHEN 2018 - YEAR(Birth_Date) BETWEEN 40 AND 50 THEN 'Age 40-50'
        WHEN 2018 - YEAR(Birth_Date) BETWEEN 51 AND 60 THEN 'Age 51-60'
        ELSE 'Elderly'
	END
ORDER BY COUNT(DISTINCT a.Customer_Key) DESC;

	#1.5 The number of customers of each income group in 2015, 2016, and 2017 (incomes are grouped into 4 ranges)
SELECT 
CASE 
		WHEN Annual_Income < 30000 THEN 'Less than 30k'
        WHEN Annual_Income BETWEEN 30000 AND 60000 THEN '30k-60k'
        WHEN Annual_Income BETWEEN 60001 AND 90000 THEN '60k-90k'
        ELSE 'More than 90k'
	END AS 'Annual income group',
COUNT(DISTINCT a.Customer_Key) AS 'Number of customers'
FROM sales_2015 a
JOIN customers b
	ON a.Customer_Key = b.Customer_Key
GROUP BY 
CASE 
	WHEN Annual_Income < 30000 THEN 'Less than 30k'
        WHEN Annual_Income BETWEEN 30000 AND 60000 THEN '30k-60k'
        WHEN Annual_Income BETWEEN 60001 AND 90000 THEN '60k-90k'
        ELSE 'More than 90k'
	END
ORDER BY COUNT(DISTINCT a.Customer_Key) DESC;
    
#2 Find number of customers of each country for each year?
SELECT b.Country, COUNT(DISTINCT a.customer_key) AS 'Number of Customers'
FROM sales_2015 a 
	JOIN territories b
	ON a.Territory_Key = b.Territory_Key
GROUP BY country
ORDER BY COUNT(DISTINCT a.customer_key) DESC;


#3.1 Which products are most likely to be ordered in each year? 
SELECT a.Product_Key, b.Product_Name, SUM(Order_quantity) AS Total_ordered_Qty
FROM sales_2016 a
JOIN products b
	ON a.Product_Key = b.Product_Key
GROUP BY a.Product_Key
ORDER BY SUM(Order_quantity) DESC;

#3.2 List categories and their according ordered quantity over the years? 
SELECT d.Category_Name, SUM(Order_quantity) AS Total_ordered_Qty
FROM sales_2015 a
JOIN products b
	ON a. Product_Key = b.Product_Key
JOIN product_subcategories c 
	ON b.Subcategory_Key = c.Subcategory_Key
JOIN product_categories d
	ON c.Category_Key = d.Category_Key
GROUP BY d.Category_Name
ORDER BY SUM(Order_quantity) DESC;

#4.1 Which products are most likely to be returned over the years?
SELECT a.product_key, b.product_name, SUM(Return_Quantity) AS Total_return_quantity
FROM returns a 
JOIN products b
	ON a.Product_Key = b.Product_Key
WHERE YEAR(return_date) = 2017
GROUP BY a.product_key
ORDER BY SUM(Return_Quantity) DESC;

#4.2 Find the return quantity of each country over the years?
SELECT b.country, SUM(return_quantity) AS 'Total return quantity'
FROM returns a
JOIN territories b
	ON a.Territory_Key = b.Territory_Key
WHERE YEAR(a.return_date) = 2015
GROUP BY b.Country
ORDER BY SUM(Return_Quantity) DESC;

#5.1 How many products ordered in 2016 belong to category 'clothing'?
SELECT COUNT(product_key) AS 'Number of products'
FROM sales_2016
WHERE Product_Key IN (SELECT Product_Key 
		      FROM products 
                      WHERE Subcategory_Key IN
						(SELECT Subcategory_Key
						FROM product_subcategories
						WHERE Category_Key IN
									(SELECT Category_Key
									FROM product_categories
									WHERE Category_Name = 'Clothing')));

#5.2 How many products ordered in 2017 belong to subcategory 'Tires and Tubes'?
SELECT COUNT(product_key) AS 'Number of products'
FROM sales_2017 a
WHERE EXISTS (SELECT Product_Key 
		FROM products b
                WHERE b.Product_Key = a.Product_Key
                AND EXISTS
			(SELECT Subcategory_Key
			FROM product_subcategories c
			WHERE c.Subcategory_Key = b.Subcategory_Key
			AND Subcategory_Name = 'Tires and Tubes'));

#6 Name the customers who had the highest total order_quantity in 2016 and 2017
WITH CTE AS (
SELECT First_Name, Last_Name, SUM(Order_Quantity) AS 'Total_Order_Qty'
FROM sales_2016 a
JOIN customers b
	ON a.Customer_Key = b.Customer_Key
GROUP BY a.Customer_Key)
    SELECT * 
    FROM CTE
    WHERE CTE.Total_Order_Qty = (SELECT MAX(CTE.Total_Order_Qty) FROM CTE);

#7 Return ratios over the years? (Number of return quantity devided by number of ordered quantity)
SELECT ROUND((SELECT SUM(Return_Quantity)
FROM returns 
WHERE YEAR(return_date) = 2015)
/
(SELECT SUM(Order_Quantity)
FROM sales_2015)*100,2) AS 'return ratio (%)';
                
#8 Total profit of each year?
SELECT
(ROUND((SELECT SUM(a.Order_Quantity*(b.product_price - b.product_cost))
FROM sales_2015 a 
JOIN products b
	ON a.Product_Key = b.Product_Key))
-
(ROUND((SELECT SUM(a.Return_Quantity*(b.product_price - b.product_cost))
FROM returns a 
JOIN products b
	ON a.Product_Key = b.Product_Key
WHERE YEAR(return_date) = 2015)))) AS 'Total profit';

#8.1 Which country generate the highest profit over the years?
WITH CTE_1 AS (
SELECT t3.country, ROUND(SUM(t1.Order_Quantity * (t2.product_price - t2.product_cost))) AS C1
FROM sales_2015 t1
JOIN products t2
	ON t1.Product_Key = t2.Product_Key
JOIN territories t3
	ON t1.Territory_Key = t3.Territory_Key
GROUP BY t3.country),
CTE_2 AS
(SELECT t3.country, ROUND(SUM(t1.Return_Quantity*(t2.product_price - t2.product_cost))) AS C2
FROM returns t1
JOIN products t2
	ON t1.Product_Key = t2.Product_Key
JOIN territories t3
	ON t1.Territory_Key = t3.Territory_Key
WHERE YEAR(t1.return_date) = 2015
GROUP BY t3.country)
SELECT CTE_1.country, (CTE_1.C1 - CTE_2.C2) AS 'Country profit'
FROM CTE_1
JOIN CTE_2
	ON CTE_1.country = CTE_2.country
ORDER BY (CTE_1.C1 - CTE_2.C2) DESC;

#9 Find top 10 products that generate most profit over the years? 
WITH CTE_1 AS(
SELECT t2.Product_Key, t2.Product_Name, t3.Subcategory_Name, t4.Category_Name, SUM(t1.Order_Quantity) AS Total_order_Qty, t2.product_price, t2.product_cost
FROM sales_2015 t1
JOIN products t2
	ON t1.Product_Key = t2.Product_Key
JOIN product_subcategories t3
	ON t2.Subcategory_Key = t3.Subcategory_Key
JOIN product_categories t4
	ON t3.Category_Key = t4.Category_Key
GROUP BY t1.Product_Key),
CTE_2 AS(
SELECT t2.Product_Key, SUM(t1.Return_Quantity) AS Total_return_qty
FROM returns t1
JOIN products t2
	ON t1.Product_Key = t2.Product_Key
WHERE YEAR(Return_Date) = 2015
GROUP BY t2.Product_Key)
SELECT CTE_1.Product_Name, CTE_1.Subcategory_Name, CTE_1.Category_Name, 
		ROUND((CTE_1.Total_order_Qty - COALESCE(CTE_2.Total_return_qty,0))*(CTE_1.product_price - CTE_1.product_cost)) AS 'Product profit'
FROM CTE_1
LEFT JOIN CTE_2
	ON CTE_1.product_key = CTE_2.product_key
ORDER BY ROUND((CTE_1.Total_order_Qty - COALESCE(CTE_2.Total_return_qty,0))*(CTE_1.product_price - CTE_1.product_cost)) DESC
LIMIT 10;





    





