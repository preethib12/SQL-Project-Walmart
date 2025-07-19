-- 1. Create walmart_sales table with correct column names and types
CREATE TABLE walmart_sales (
  Invoice_ID TEXT,
  Branch TEXT,
  City TEXT,
  Customer_type TEXT,
  Gender TEXT,
  Product_line TEXT,
  Unit_price REAL,
  Quantity INTEGER,
  Tax_5 REAL,
  Sales REAL,
  Date TEXT,
  Time TEXT,
  Payment TEXT,
  cogs REAL,
  gross_margin_percentage REAL,
  gross_income REAL,
  Rating REAL
);

-- 2. Insert clean data from walmart_data with type casting
INSERT INTO walmart_sales
SELECT
  c1,                         -- Invoice_ID
  c2,                         -- Branch
  c3,                         -- City
  c4,                         -- Customer_type
  c5,                         -- Gender
  c6,                         -- Product_line
  CAST(c7 AS REAL),           -- Unit_price
  CAST(c8 AS INTEGER),        -- Quantity
  CAST(c9 AS REAL),           -- Tax_5
  CAST(c10 AS REAL),          -- Sales
  c11,                        -- Date
  c12,                        -- Time
  c13,                        -- Payment
  CAST(c14 AS REAL),          -- cogs
  CAST(c15 AS REAL),          -- gross_margin_percentage
  CAST(c16 AS REAL),          -- gross_income
  CAST(c17 AS REAL)           -- Rating
FROM walmart_data
WHERE 
  c7 GLOB '[0-9.]*' AND
  c8 GLOB '[0-9]*' AND
  c9 GLOB '[0-9.]*' AND
  c10 GLOB '[0-9.]*' AND
  c14 GLOB '[0-9.]*' AND
  c15 GLOB '[0-9.]*' AND
  c16 GLOB '[0-9.]*' AND
  c17 GLOB '[0-9.]*';
  
  --Checking inserted data
SELECT * FROM walmart_sales LIMIT 5;

--Q1 Total sales per city
SELECT City, SUM(Sales) AS Total_Sales
FROM walmart_sales
GROUP BY City;

--Q2 Best-selling product line (by quantity)
SELECT Product_line, SUM(Quantity) AS Total_Quantity
FROM walmart_sales
GROUP BY Product_line
ORDER BY Total_Quantity DESC
LIMIT 1;

--Q3 Monthly sales trend
SELECT 
  STRFTIME('%Y-%m', Date) AS Month,
  SUM(Sales) AS Total_Sales
FROM walmart_sales
GROUP BY Month
ORDER BY Month;

--checking the format of Date
SELECT DISTINCT Date
FROM walmart_sales
LIMIT 10;

--Converting the date format 
SELECT 
  SUBSTR(Date, 7, 4) || '-' || 
  SUBSTR(Date, 1, 2) || '-' || 
  SUBSTR(Date, 4, 2) AS Converted_Date
FROM walmart_sales
LIMIT 5;

--rewriting the query with converted date
SELECT 
  SUBSTR(Date, -4) || '-' || 
  SUBSTR(Date, 1, INSTR(Date, '/') - 1) AS Month,
  SUM(Sales) AS Total_Sales
FROM walmart_sales
GROUP BY Month
ORDER BY Month;

--Q4 Number of transactions per branch
SELECT SUM(Sales) AS Total_Revenue
FROM walmart_sales;

--Q5 Average rating per product line
SELECT Product_line, ROUND(AVG(Rating), 2) AS Avg_Rating
FROM walmart_sales
GROUP BY Product_line;

--Q6 Number of transactions per branch
SELECT Branch, COUNT(*) AS Transaction_Count
FROM walmart_sales
GROUP BY Branch;

--Q7 Highest gross income transaction
SELECT Invoice_ID, MAX(gross_income) AS Highest_Gross_Income
FROM walmart_sales;

--Q8 Most popular payment method
SELECT Payment, COUNT(*) AS Count
FROM walmart_sales
GROUP BY Payment
ORDER BY Count DESC
LIMIT 1;

--Q9 Average unit price by product line
SELECT Product_line, ROUND(AVG(Unit_price), 2) AS Avg_Unit_Price
FROM walmart_sales
GROUP BY Product_line;

--Q10 Total quantity sold per product line
SELECT Product_line, SUM(Quantity) AS Total_Quantity
FROM walmart_sales
GROUP BY Product_line;

--Q11 Which gender spends more on average?
SELECT Gender, AVG(sales) AS Avg_Spent
FROM walmart_sales
GROUP BY Gender;

--Q12 Which customer type generates higher revenue?
SELECT Customer_type, SUM(sales) AS Total_Revenue
FROM walmart_sales
GROUP BY Customer_type;

--Q13 Revenue per branch
SELECT Branch, SUM(sales) AS Branch_Revenue
FROM walmart_sales
GROUP BY Branch;

--Q14 Number of unique invoices
SELECT COUNT(DISTINCT Invoice_ID) AS Unique_Invoices
FROM walmart_sales;

--Q15 Top 3 product lines by total revenue
SELECT Product_line, SUM(sales) AS Revenue
FROM walmart_sales
GROUP BY Product_line
ORDER BY Revenue DESC
LIMIT 3;

--Q16 Which product line has the highest rating average?
SELECT Product_line, ROUND(AVG(Rating), 2) AS Avg_Rating
FROM walmart_sales
GROUP BY Product_line
ORDER BY Avg_Rating DESC
LIMIT 1;

--Q17 Which branch had the highest number of sales transactions?
SELECT Branch, COUNT(*) AS Total_Transactions
FROM walmart_sales
GROUP BY Branch
ORDER BY Total_Transactions DESC
LIMIT 1;

--Q18 Show all transactions where the product line contains 'accessories'
SELECT Invoice_ID, Product_line, sales
FROM walmart_sales
WHERE Product_line LIKE '%accessories%';

--Q19 Find the average number of items (Quantity) sold per transaction, rounded to 1 decimal
SELECT ROUND(AVG(Quantity), 1) AS Avg_Items_Per_Transaction
FROM walmart_sales;

--Q20 Show unique product lines in UPPERCASE
SELECT DISTINCT UPPER(Product_line) AS Upper_Product_Line
FROM walmart_sales;
