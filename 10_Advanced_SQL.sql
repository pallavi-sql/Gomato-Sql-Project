/* GOMATO PROJECT - 10 ADVANCED SQL
   Purpose: Apply CASE, date/string functions, NULL handling, and business rules.
*/
USE GomatoDB;
GO

-- CASE: Label orders by value
SELECT OrderID, TotalAmount,
       CASE
           WHEN TotalAmount >= 700 THEN 'High Value'
           WHEN TotalAmount >= 300 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS OrderValueBand
FROM dbo.Orders;
GO

-- Date: Orders from the last seven days
SELECT OrderID, OrderDateTime, TotalAmount
FROM dbo.Orders
WHERE OrderDateTime >= DATEADD(DAY, -7, SYSDATETIME())
  AND OrderDateTime <  SYSDATETIME();
GO

-- Date: Monthly order summary
SELECT DATEFROMPARTS(YEAR(OrderDateTime), MONTH(OrderDateTime), 1) AS OrderMonth,
       COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalOrderValue
FROM dbo.Orders
GROUP BY DATEFROMPARTS(YEAR(OrderDateTime), MONTH(OrderDateTime), 1)
ORDER BY OrderMonth;
GO

-- String: Standardized display of customer names
SELECT CustomerID, UPPER(LTRIM(RTRIM(CustomerName))) AS StandardizedName
FROM dbo.Customer;
GO

-- String: Search product names containing 'kit'
SELECT ProductID, ProductName
FROM dbo.Product
WHERE ProductName LIKE '%kit%';
GO

-- NULL handling: Display missing contact details clearly
SELECT CustomerName,
       COALESCE(Email, 'Email not provided') AS Email,
       COALESCE(Phone, 'Phone not provided') AS Phone
FROM dbo.Customer;
GO

-- Business scenario: Count orders that are not yet delivered
SELECT COUNT(*) AS UndeliveredOrderCount
FROM dbo.Orders
WHERE DeliveryStatus IS NULL OR DeliveryStatus <> 'Delivered';
GO

-- Business scenario: Products never ordered
SELECT p.ProductID, p.ProductName
FROM dbo.Product AS p
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.OrderDetails AS od
    WHERE od.ProductID = p.ProductID
);
GO

-- Business scenario: Reconciliation between order total and line-item total
WITH DetailTotals AS
(
    SELECT OrderID, SUM(Quantity * UnitPrice) AS DetailTotal
    FROM dbo.OrderDetails
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, dt.DetailTotal,
       o.TotalAmount - COALESCE(dt.DetailTotal, 0) AS Difference
FROM dbo.Orders AS o
LEFT JOIN DetailTotals AS dt ON dt.OrderID = o.OrderID
WHERE ABS(o.TotalAmount - COALESCE(dt.DetailTotal, 0)) > 0.01;
GO
