/* GOMATO PROJECT - 05 BUSINESS ANALYSIS
   Purpose: Answer practical questions about customers, orders, products, and delivery.
*/
USE GomatoDB;
GO

-- 1. Total customers
SELECT COUNT(*) AS TotalCustomers FROM dbo.Customer;
GO

-- 2. Total orders and order value
SELECT COUNT(*) AS TotalOrders, SUM(TotalAmount) AS TotalOrderValue
FROM dbo.Orders;
GO

-- 3. Orders by status
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;
GO

-- 4. Payment status summary
SELECT PaymentStatus, COUNT(*) AS OrderCount, SUM(TotalAmount) AS OrderValue
FROM dbo.Orders
GROUP BY PaymentStatus;
GO

-- 5. Top customers by order count
SELECT TOP (5) c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM dbo.Customer AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY OrderCount DESC, c.CustomerName;
GO

-- 6. Revenue by product category. Use line-item revenue to avoid order-level double counting.
SELECT cat.CategoryName,
       SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM dbo.OrderDetails AS od
JOIN dbo.Product AS p ON p.ProductID = od.ProductID
JOIN dbo.Category AS cat ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName
ORDER BY Revenue DESC;
GO

-- 7. Best-selling products by quantity
SELECT p.ProductName, SUM(od.Quantity) AS UnitsSold
FROM dbo.OrderDetails AS od
JOIN dbo.Product AS p ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold DESC, p.ProductName;
GO

-- 8. Pending or in-transit orders
SELECT OrderID, CustomerID, OrderDateTime, TotalAmount, OrderStatus, DeliveryStatus
FROM dbo.Orders
WHERE OrderStatus IN ('Placed', 'Processing')
   OR DeliveryStatus IN ('Pending', 'In Transit')
ORDER BY OrderDateTime;
GO

-- 9. Average partner rating
SELECT AVG(CAST(Rating AS DECIMAL(5,2))) AS AveragePartnerRating
FROM dbo.DeliveryPartners
WHERE Rating IS NOT NULL;
GO

-- 10. Orders by day
SELECT CAST(OrderDateTime AS DATE) AS OrderDate, COUNT(*) AS OrdersPerDay
FROM dbo.Orders
GROUP BY CAST(OrderDateTime AS DATE)
ORDER BY OrderDate;
GO
