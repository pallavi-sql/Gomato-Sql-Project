/* GOMATO PROJECT - 06 JOINS
   Purpose: Combine related data across the eight project tables.
*/
USE GomatoDB;
GO

-- Q1: Orders with customer names
SELECT o.OrderID, c.CustomerName, o.OrderDateTime, o.TotalAmount, o.OrderStatus
FROM dbo.Orders AS o
JOIN dbo.Customer AS c ON c.CustomerID = o.CustomerID;
GO

-- Q2: Customer addresses
SELECT c.CustomerName, a.AddressLine, a.City, a.Pincode
FROM dbo.Customer AS c
JOIN dbo.Address AS a ON a.CustomerID = c.CustomerID;
GO

-- Q3: Products with categories
SELECT p.ProductName, cat.CategoryName, p.Price
FROM dbo.Product AS p
JOIN dbo.Category AS cat ON cat.CategoryID = p.CategoryID;
GO

-- Q4: Products with store details
SELECT p.ProductName, p.Price, s.StoreName, s.City
FROM dbo.Product AS p
JOIN dbo.Store AS s ON s.StoreID = p.StoreID;
GO

-- Q5: Order line details
SELECT o.OrderID, p.ProductName, od.Quantity, od.UnitPrice,
       od.Quantity * od.UnitPrice AS LineAmount
FROM dbo.Orders AS o
JOIN dbo.OrderDetails AS od ON od.OrderID = o.OrderID
JOIN dbo.Product AS p ON p.ProductID = od.ProductID;
GO

-- Q6: Orders and delivery partner, including unassigned partners
SELECT o.OrderID, o.DeliveryStatus, dp.PartnerName, dp.VehicleType
FROM dbo.Orders AS o
LEFT JOIN dbo.DeliveryPartners AS dp ON dp.PartnerID = o.PartnerID;
GO

-- Q7: Customers who have never placed an order
SELECT c.CustomerID, c.CustomerName
FROM dbo.Customer AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;
GO

-- Q8: Total line-item revenue by store
SELECT s.StoreName, SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM dbo.Store AS s
JOIN dbo.Product AS p ON p.StoreID = s.StoreID
JOIN dbo.OrderDetails AS od ON od.ProductID = p.ProductID
GROUP BY s.StoreName
ORDER BY Revenue DESC;
GO

-- Q9: Number of orders per customer, including zero-order customers
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM dbo.Customer AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;
GO

-- Q10: Completed deliveries with customer, address, and partner
SELECT o.OrderID, c.CustomerName, a.AddressLine, dp.PartnerName, o.OrderDateTime
FROM dbo.Orders AS o
JOIN dbo.Customer AS c ON c.CustomerID = o.CustomerID
JOIN dbo.Address AS a ON a.AddressID = o.AddressID
LEFT JOIN dbo.DeliveryPartners AS dp ON dp.PartnerID = o.PartnerID
WHERE o.DeliveryStatus = 'Delivered';
GO
