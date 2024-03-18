/*
In this project, we start by 
	- creating the database "Innogeration"
	- next populating it with data
	- then creating foreign keys
This is done by running the 3 sql files in this repo in the following order
	01 - Create Innogeneration_Database_tables.sql
	02 - Populate Innogeneration_Tables.sql
	03 - Create Innogeneration_foreign_keys.sql

Next we work on the business requirements we received below.

Skills used: 
- Clauses (SELECT, WHERE, FROM, ORDER BY, GROUP BY, HAVING)
- Joins
- Aliases
- Operators (AND, OR, NOT)
- CTE's ()
- Temp Tables
- Windows Functions
- Aggregate Functions (AVG, COUNT, MAX, SUM)
- Creating Views
- Converting Data Types
- CASE expressions
- Character functions (CONCAT, SUBSTRING, RIGHT, LEFT, CHARINDEX, LEN)
/*
All queries are run against the Innogeneration database
*/


USE Innogeneration; --This is the make sure we are running our queries in the approprate database, "Innogeneration"
GO	


/*
Business question 1:
As a manager for the reporting team, I want a dataset generated that will return all the customers who placed an order and made payments using cash as their payment type. 
This effort is for us to make a budget for how we process electronic payments.
*/

SELECT
	DC.CustomerID,  --We have to use the alias "DC" since CustomerID is found in both customers and Orders tables
	OrderID,
	OrderDate,
	DeliveryDate,
	PaymentTypeName
FROM dbo.Customers DC
JOIN dbo.Orders DO ON DC.CustomerID = DO.CustomerID
JOIN dbo.PaymentTypes DP ON DP.PaymentTypeID = DO.PaymentTypeID
WHERE DP.PaymentTypeID = 1	--287 rows


/*
Business question 2: 
As a manager for the reporting team, I am preparing for the annual customer reports
that I must submit to the upper management; I would like you to write a SQL query to get me the customer's full name, phone numbers, email address, 
address (address line 1, city name, population of that city, and the country name of that address)
*/
SELECT DISTINCT
	dcu.FullName,
	dcu.PhoneNumber,
	dcu.Email,
	dad.AddressLine1,
	dci.CityName,
	dci.Population,
	dco.CountryName
FROM dbo.Customers dcu
JOIN dbo.Orders dor ON dcu.CustomerID = dor.CustomerID
JOIN dbo.Addresses dad ON dcu.BillingAddressID = dad.AddressID
JOIN dbo.Cities dci ON dad.CityID = dci.CityID
JOIN dbo.Provinces dpr ON dci.ProvinceID = dpr.ProvinceID
JOIN dbo.Countries dco ON dpr.CountryID = dco.CountryID   --88 rows

/*
Business question 3:
The director of data services will like you to create a View containing data for ingredient names, recipe quantity, product names, and product descriptions. 
*/

CREATE VIEW dbo.BusReq3
AS
SELECT DISTINCT
	dpr.ProductName,
	dpr.ProductDescription,
	din.IngredientName,
	dre.Quantity [Recipe Quantity] --Renaming the output table column
FROM dbo.Ingredients din
JOIN dbo.Recipes dre ON din.IngredientID = dre.IngredientID
JOIN dbo.Products dpr ON dre.ProductID = dpr.ProductID;	-- 29 rows

/*
Business question 4:
The director is incredibly pleased with the view you created in question 3. Still, after two weeks of using it, the director is asking for additional information to be added to the view. 
The directory would like you to add a column called "Shot Description" this column should contain only the first word of the product description. 
This information is needed because he wants to use it to make a quick analysis and to use something other than the actual product description. 
For example, if the product description is "Bacon ice cream," he wants to see "Bacon" for the "Shot Description" column.
*/
DROP VIEW IF EXISTS dbo.BusReq3 --using "VIEW" enables us to modify the script (if new requirement/update) without impacting 
GO
CREATE VIEW dbo.BusReq3
AS
SELECT DISTINCT
	dpr.ProductName,
	dpr.ProductDescription,
	din.IngredientName,
	dre.Quantity [Recipe Quantity],
	CASE
		WHEN CHARINDEX(' ',dpr.ProductDescription,1) <> 0 THEN SUBSTRING(ProductDescription,1,CHARINDEX(' ',dpr.ProductDescription,1))
		ELSE dpr.ProductDescription
	END [Short Description]
FROM dbo.Ingredients din
JOIN dbo.Recipes dre ON din.IngredientID = dre.IngredientID
JOIN dbo.Products dpr ON dre.ProductID = dpr.ProductID				--29 rows

/*
Business question 5:
 As a manager of the production department, I want to get the list of products that we have discontinued. 
*/
SELECT
	dpr.ProductID,
	dpr.ProductName
FROM dbo.Products dpr
JOIN dbo.ProductSubcategories dps ON dpr.SubcategoryID = dps.ProductSubcategoryID
JOIN dbo.ProductCategories dpc ON dps.ProductCategoryID = dpc.CategoryID
WHERE dpr.Discontinued = 1  ---7 rows


/*
Business question 6:
Thank you for the report on question 5. I will like you to add some information to that report, please. 
I would like you to add the name of the department that discontinued the products; this is needed for audit purposes.
*/
SELECT
	dpr.ProductID,
	dpr.ProductName,
	dpe.Name Department
FROM dbo.Products dpr
JOIN dbo.ProductSubcategories dps ON dpr.SubcategoryID = dps.ProductSubcategoryID
JOIN dbo.ProductCategories dpc ON dps.ProductCategoryID = dpc.CategoryID
JOIN dbo.ProductDepartments dpe ON dpc.DepartmentID = dpe.DepartmentID
WHERE dpr.Discontinued = 1   ---7 rows

/*
Business question 7:
The sales manager would like you to write a query to return all the employees who helped place orders after 2018.
*/

SELECT DISTINCT
	de.EmployeeID,
	de.FirstName,
	de.LastName,
	de.JobTitle,
	YEAR(do.OrderDate) OrderYear
FROM dbo.Employees de
JOIN dbo.orders do ON de.EmployeeID = do.EmployeeID
WHERE YEAR(CAST(do.OrderDate AS DATE)) > 2018   ---9 rows


/*
Business question 8:
A report from upper management regarding a customer complaint says there was short inventory when they tried to place an order. 
The manager will like you to build a report that will check for products and their inventory items. 
They require you to create datasets containing inventory Quantity, Barcode, product name, and unit price.
*/

SELECT DISTINCT
	dp.ProductName,
	din.Quantity [Inventory Quantity],
	din.UnitPrice,
	din.Barcode	
FROM dbo.InventoryItems din
JOIN dbo.Products dp ON din.ProductID = dp.ProductID   ---164 rows

/*
Business question 9:
Using the report from question 8. Please add a derived column called "Quantity check." This column should hold the following information. 
If the quantity is less than 10, display "Red zone"; if the amount is greater or equal to 10 but less than 16, display "Yellow zone." 
If the quantity is greater than 16, then display "Green Zone."
*/

SELECT DISTINCT
	dp.ProductName,
	din.Quantity [Inventory Quantity],
	din.UnitPrice,
	din.Barcode,
	CASE
		WHEN din.Quantity < 10 then 'Red Zone'
		WHEN din.Quantity >= 10 AND din.Quantity < 16 THEN 'Yellow Zone'
		ELSE 'Green Zone'
	END [Quantity Check]
FROM dbo.InventoryItems din
JOIN dbo.Products dp ON din.ProductID = dp.ProductID --164 rows

/*
Business question 10:
Management just noticed that the report on question 9 is blowing up due to unknown values. 
They would like you to replace all the Unknown Barcodes with the reading "No Barcode."
*/

SELECT DISTINCT
	dp.ProductName,
	din.Quantity [Inventory Quantity],
	din.UnitPrice,
	CASE
		WHEN din.Barcode IS NULL THEN 'No Barcode'
	END Barcode,
	CASE
		WHEN din.Quantity < 10 then 'Red Zone'
		WHEN din.Quantity >= 10 AND din.Quantity < 16 THEN 'Yellow Zone'
		ELSE 'Green Zone'
	END [Quantity Check]
FROM dbo.InventoryItems din
JOIN dbo.Products dp ON din.ProductID = dp.ProductID  --164 rows

/*
Business question 11:
The HR department would like you to compile a list of employees with their addresses, cities, provinces, and countries. 
An employee audit is coming, and the HR department wants to have this information handy.
*/

WITH EMP1
AS
(
	SELECT  
		FirstName,
		LastName,
		CAST(BirthDate AS DATE) [Birth Date],
		Gender,
		max(AddressID) AddressID
	FROM dbo.Employees
	GROUP BY FirstName,LastName,Birthdate,Gender
)
SELECT
	emp1.FirstName,
	emp1.LastName,
	emp1.[Birth Date],
	emp1.Gender,
	CASE
		WHEN dad.AddressLine2 = dci.CityName THEN dad.AddressLine1
		ELSE CONCAT(dad.AddressLine1,',',dad.AddressLine2)
	END Addresses,
	dci.CityName,
	dpr.ProvinceName,
	dco.CountryName
FROM EMP1
JOIN dbo.Addresses dad ON emp1.AddressID = dad.AddressID
JOIN dbo.Cities dci ON dad.CityID = dci.CityID
JOIN dbo.Provinces dpr ON dci.ProvinceID = dpr.ProvinceID
JOIN dbo.Countries dco ON dpr.CountryID = dco.CountryID
ORDER BY FirstName ASC     ---289 rows

/*
Business question 12:
You just received an appreciation letter from your manager regarding the report you created in question 2. 
Your manager is pleased with your work and appreciates all your efforts to make that a success. However, your manager wants you to do one last favor. 
It was difficult when using the report from question 2. The manager seeks to filter the report by the customer's full name. 
Please add a filter to the report you created in question 2, so it can be filtered using the full name. 
*/

SELECT DISTINCT
	dcu.FullName,
	dcu.PhoneNumber,
	dcu.Email,
	dad.AddressLine1,
	dci.CityName,
	dci.Population,
	dco.CountryName
FROM dbo.Customers dcu
JOIN dbo.Orders dor ON dcu.CustomerID = dor.CustomerID
JOIN dbo.Addresses dad ON dcu.BillingAddressID = dad.AddressID
JOIN dbo.Cities dci ON dad.CityID = dci.CityID
JOIN dbo.Provinces dpr ON dci.ProvinceID = dpr.ProvinceID
JOIN dbo.Countries dco ON dpr.CountryID = dco.CountryID  --88 rows

/*
Business question 13:
The modified report in question 12 is perfect, but the manager will like one last tweak. He wants you to mask the phone number of the customers for security reasons. 
He wants you only to display the last numbers, and the rest of them should be masked with an asterisk (*). 
For example, 754-555-0137 becomes ********0137.
*/

SELECT DISTINCT
	dcu.FullName,
	CONCAT(REPLICATE('*',10),RIGHT(dcu.phoneNumber,4)) [PhoneNumber],
	dcu.Email,
	dad.AddressLine1,
	dci.CityName,
	dci.Population,
	dco.CountryName
FROM dbo.Customers dcu
JOIN dbo.Orders dor ON dcu.CustomerID = dor.CustomerID
JOIN dbo.Addresses dad ON dcu.BillingAddressID = dad.AddressID
JOIN dbo.Cities dci ON dad.CityID = dci.CityID
JOIN dbo.Provinces dpr ON dci.ProvinceID = dpr.ProvinceID
JOIN dbo.Countries dco ON dpr.CountryID = dco.CountryID      -- 88 rows

/*
Business question 14:
The manager wants you to make one final modification to the report in question 13 and push it to QA. He wants you to mask the email address of the customers. 
He wants you to hide the name of the email and only leave the domain of those emails, so for example, aaron.bryant@gmail.com becomes *************gmail.com, 
aaron.jai@gmail.com becomes **********gmail.com, and aaron.li@gmail.com becomes ********gmail.com. 
Please pay attention; the number of an asterisk (*) should match the number of words you are replacing. 
*/
SELECT DISTINCT
	dcu.FullName,
	CONCAT(REPLICATE('*',10),RIGHT(dcu.phoneNumber,4)) [Phone Number],
	CONCAT(REPLICATE('*',CHARINDEX('@',dcu.Email)),RIGHT(dcu.Email,(CHARINDEX('@',REVERSE(dcu.Email)))-1)) [E-mail],
	dad.AddressLine1,
	dci.CityName,
	dci.Population,
	dco.CountryName
FROM dbo.Customers dcu
JOIN dbo.Orders dor ON dcu.CustomerID = dor.CustomerID
JOIN dbo.Addresses dad ON dcu.BillingAddressID = dad.AddressID
JOIN dbo.Cities dci ON dad.CityID = dci.CityID
JOIN dbo.Provinces dpr ON dci.ProvinceID = dpr.ProvinceID
JOIN dbo.Countries dco ON dpr.CountryID = dco.CountryID   --88 rows

/*
Business question 15:
HR is here again; the HR department manager wants you to generate datasets containing the first name and last name and a derived column called "Actual Age" 
This column should calculate the age of the employee when they were first employed in the company.
*/

SELECT 
	FirstName,
	LastName,
	CASE
		WHEN (hm - bm < 0) OR (hm - bm >= 0 AND hd - bd < 0) THEN DATEDIFF(Year, [Birth Date], [Hire Date]) - 1
		ELSE DATEDIFF(Year, [Birth Date], [Hire Date])
	END [Actual Age]
FROM (
	SELECT DISTINCT
		FirstName,
		LastName,
		CAST(BirthDate AS DATE) [Birth Date],
		CAST(HireDate AS DATE) [Hire Date],
		DATEPART(day,BirthDate) Bd,
		DATEPART(month,BirthDate) Bm,
		DATEPART(day,HireDate) Hd,
		DATEPART(month,HireDate) Hm
	FROM dbo.Employees
) A											--289 rows


/*
Business question 16:
HR wants to create a unique username for all employees. They remembered that you did a project two months ago on question 15. 
They want you to leverage that report and add a column called "UserID" this column should be made up of the first three characters of their address line 1, 
the last three of their city name, the length of their full name, first two of their continents, their last name, and their city population.
*/

WITH EMP
AS
(
	SELECT  
		FirstName,
		LastName,
		min(EmployeeID) EmployeeID,
		CONCAT(FirstName,' ',LastName) FullName
	FROM dbo.Employees
	GROUP BY LastName,FirstName
)
SELECT
	EMP.FirstName,
	EMP.LastName,
	EMP.FirstName,
	emp.EmployeeID,
	dem.AddressID,
	dad.AddressLine1,
	dci.CityName,
	dci.Population,
	dco.Continent,
	CONCAT(LEFT(dad.AddressLine1,3),RIGHT(dci.CityName,3),LEN(EMP.FirstName),LEFT(dco.Continent,2),emp.LastName,dco.Population) UserID
FROM EMP
JOIN dbo.Employees dem ON emp.EmployeeID=dem.EmployeeID
Join dbo.Addresses dad ON dem.AddressID = dad.AddressID
JOIN dbo.Cities dci ON dad.CityID = dci.CityID
JOIN dbo.Provinces dpr ON dci.ProvinceID = dpr.ProvinceID
JOIN dbo.Countries dco ON dpr.CountryID = dco.CountryID --289 rows

