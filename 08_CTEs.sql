/* GOMATO PROJECT - 08 CTEs
   Purpose: Make multi-step queries easier to read and maintain.
*/
USE GomatoDB;
GO

-- Q21: Customer-level order summary
WITH CustomerOrders AS
(
    SELECT CustomerID, COUNT(*) AS OrderCount, SUM(TotalAmount) AS TotalSpend
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT c.CustomerName, COALESCE(co.OrderCount, 0) AS OrderCount,
       COALESCE(co.TotalSpend, 0) AS TotalSpend
FROM dbo.Customer AS c
LEFT JOIN CustomerOrders AS co ON co.CustomerID = c.CustomerID;
GO

-- Q22: Category revenue
WITH CategoryRevenue AS
(
    SELECT cat.CategoryName, SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM dbo.OrderDetails AS od
    JOIN dbo.Product AS p ON p.ProductID = od.ProductID
    JOIN dbo.Category AS cat ON cat.CategoryID = p.CategoryID
    GROUP BY cat.CategoryName
)
SELECT CategoryName, Revenue
FROM CategoryRevenue
WHERE Revenue > 0
ORDER BY Revenue DESC;
GO

-- Q23: Pending orders in a readable result
WITH PendingOrders AS
(
    SELECT OrderID, CustomerID, OrderDateTime, TotalAmount
    FROM dbo.Orders
    WHERE OrderStatus IN ('Placed', 'Processing')
)
SELECT * FROM PendingOrders ORDER BY OrderDateTime;
GO

-- Q24: Store product count and average price
WITH StoreStats AS
(
    SELECT StoreID, COUNT(*) AS ProductCount, AVG(Price) AS AveragePrice
    FROM dbo.Product
    GROUP BY StoreID
)
SELECT s.StoreName, COALESCE(ss.ProductCount, 0) AS ProductCount, ss.AveragePrice
FROM dbo.Store AS s
LEFT JOIN StoreStats AS ss ON ss.StoreID = s.StoreID;
GO

-- Q25: Multi-step order line calculation
WITH LineAmounts AS
(
    SELECT OrderID, Quantity * UnitPrice AS LineAmount
    FROM dbo.OrderDetails
),
OrderLineTotals AS
(
    SELECT OrderID, SUM(LineAmount) AS CalculatedTotal
    FROM LineAmounts
    GROUP BY OrderID
)
SELECT o.OrderID, o.TotalAmount, olt.CalculatedTotal
FROM dbo.Orders AS o
LEFT JOIN OrderLineTotals AS olt ON olt.OrderID = o.OrderID;
GO
