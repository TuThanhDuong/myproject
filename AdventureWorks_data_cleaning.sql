-- Some formatting on customers table
	#1 Removing prefix column as it is redundant
    ALTER TABLE customers
    DROP COLUMN Prefix;
    
    #2 Changing first_name, last_name from Uppercase to propercase format
    UPDATE customers SET First_name = REPLACE(TRIM(First_name),SUBSTRING(First_name,2),LOWER(SUBSTRING(First_name,2)));
    UPDATE customers SET Last_Name = REPLACE(TRIM(Last_Name),SUBSTRING(Last_Name,2),LOWER(SUBSTRING(Last_Name,2)));
    
    #3 Removing redundant spaces if any 
    UPDATE customers SET First_name = REPLACE(First_Name,' ','');
    UPDATE customers SET Last_name = REPLACE(Last_name,' ','');
    UPDATE customers SET Marital_Status = TRIM(Marital_status);
    UPDATE customers SET Gender = TRIM(Gender);
    UPDATE customers SET Email_Address = REPLACE(Email_Address,' ','');
    UPDATE customers SET Education_Level = TRIM(Education_Level);
    UPDATE customers SET Occupation = TRIM(Occupation);
    UPDATE customers SET HomeOwner = TRIM(HomeOwner);
    
    #4 Changing birthday from DATETIME into DATE
    ALTER TABLE customers
    MODIFY Birth_Date DATE;
    
    #5 Removing duplicates if any (customers with same first_name, last_name, birthday, and email)
	DELETE a FROM
	customers a
	JOIN customers b
	WHERE a.Customer_Key < b.Customer_Key
	AND a.First_name = b.First_Name
	AND a.Last_Name = b.Last_Name
	AND a.Birth_Date = b.Birth_Date
	AND a.Email_Address = b.Email_Address;
    
-- Some formatting on product_categories and product_subcategories, returns, and territories tables
	#1 Removing redundant spaces
    UPDATE product_categories SET Category_Name = TRIM(Category_Name);
    UPDATE product_subcategories SET Subcategory_Name = TRIM(Subcategory_Name);
    UPDATE territories SET Region = TRIM(Region);
    UPDATE territories SET Country = TRIM(Country);
    UPDATE territories SET Continent = TRIM(Continent);
    
    #2 Changing Return_Date from DATETIME into DATE in returns table
	ALTER TABLE returns
    MODIFY Return_Date DATE;
    
-- Some formatting on Products table
     #1 Removing redundant spaces
    UPDATE products SET SKU = REPLACE(SKU,' ','');
    UPDATE products SET Product_name = TRIM(Product_name);
    UPDATE products SET Model_name = TRIM(Model_name);
     
     #2 ROUND product cost and price upto 2 decimal
     UPDATE products SET product_cost = ROUND(product_cost,2);
     ALTER TABLE products MODIFY product_cost DEC(6,2);
     
     UPDATE products SET product_price = ROUND(product_price,2);
     ALTER TABLE products MODIFY product_price DEC(6,2);
     
     #3 Removing duplicates if any (products with same SKU and product_name are considered duplicates)
     DELETE a FROM
     products a
     JOIN products b
     WHERE a.Product_Key < b.Product_Key
		AND a.SKU = b.SKU
		AND a.Product_Name = b.Product_Name;
  
-- Some formatting on Sales_2015, Sales_2016, and Sales_2017
     #1 Changing Order_Date, Stock_Date from DATETIME into DATE
     ALTER TABLE Sales_2015 MODIFY Order_Date DATE;
     ALTER TABLE Sales_2016 MODIFY Order_Date DATE;
     ALTER TABLE Sales_2017 MODIFY Order_Date DATE;
     ALTER TABLE Sales_2015 MODIFY Stock_Date DATE;
     ALTER TABLE Sales_2016 MODIFY Stock_Date DATE;
     ALTER TABLE Sales_2017 MODIFY Stock_Date DATE;
     
     #2 Removing duplicates if any (records with same order_date, order_number, product_key, and customer_key considered duplicates)
     DELETE a 
     FROM sales_2015 a 
     JOIN sales_2015 b
     WHERE a.id < b.id
		AND a.Order_Date = b.Order_Date
        AND a.Order_Number = b.Order_Number
        AND a.Product_Key = b.Product_Key
        AND a.Customer_Key = b.Customer_Key;
        
	 DELETE a 
     FROM sales_2016 a 
     JOIN sales_2016 b
     WHERE a.id < b.id
		AND a.Order_Date = b.Order_Date
        AND a.Order_Number = b.Order_Number
        AND a.Product_Key = b.Product_Key
        AND a.Customer_Key = b.Customer_Key;
        
	 DELETE a 
     FROM sales_2017 a 
     JOIN sales_2017 b
     WHERE a.id < b.id
		AND a.Order_Date = b.Order_Date
        AND a.Order_Number = b.Order_Number
        AND a.Product_Key = b.Product_Key
        AND a.Customer_Key = b.Customer_Key;
     
-- There is no missing data, so there are no steps for data imputations
        
        
   
