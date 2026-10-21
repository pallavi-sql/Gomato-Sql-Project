/* GOMATO PROJECT - 09 WINDOW FUNCTIONS
   Purpose: Rank, compare, and calculate running values without collapsing rows.
*/
USE GomatoDB;
GO

-- Q26: Rank products by price
SELECT ProductName, Price,
       RANK() OVER (ORDER BY Price DESC) AS PriceRank
FROM dbo.Product;
GO

-- Q27: Dense rank products by price
SELECT ProductName, Price,
       DENSE_RANK() OVER (ORDER BY Price DESC) AS DensePriceRank
FROM dbo.Product;
GO

-- Q28: Number each customer's orders chronologically
SELECT CustomerID, OrderID, OrderDateTime,
       ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDateTime) AS CustomerOrderNumber
FROM dbo.Orders;
GO

-- Q29: Running order value by date
SELECT OrderID, OrderDateTime, TotalAmount,
       SUM(TotalAmount) OVER (ORDER BY OrderDateTime, OrderID
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningOrderValue
FROM dbo.Orders;
GO

-- Q30: Compare each order with the previous order for the same customer
SELECT CustomerID, OrderID, OrderDateTime, TotalAmount,
       LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDateTime, OrderID) AS PreviousOrderAmount
FROM dbo.Orders;
GO

-- Q31: Highest-priced product in each category
WITH RankedProducts AS
(
    SELECT p.ProductName, p.CategoryID, p.Price,
           ROW_NUMBER() OVER (PARTITION BY p.CategoryID ORDER BY p.Price DESC, p.ProductID) AS rn
    FROM dbo.Product AS p
)
SELECT ProductName, CategoryID, Price
FROM RankedProducts
WHERE rn = 1;
GO

-- Q32: Each order's percentage of total order value
SELECT OrderID, TotalAmount,
       CAST(100.0 * TotalAmount / NULLIF(SUM(TotalAmount) OVER (), 0) AS DECIMAL(6,2)) AS PercentOfOrderValue
FROM dbo.Orders;
GO
