/* GOMATO PROJECT - 07 SUBQUERIES
   Purpose: Use one query's result inside another query.
*/
USE GomatoDB;
GO

-- Q11: Products priced above the overall average
SELECT ProductID, ProductName, Price
FROM dbo.Product
WHERE Price > (SELECT AVG(Price) FROM dbo.Product);
GO

-- Q12: Customers who have placed at least one order
SELECT CustomerID, CustomerName
FROM dbo.Customer AS c
WHERE EXISTS
(
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);
GO

-- Q13: Customers who have never placed an order
SELECT CustomerID, CustomerName
FROM dbo.Customer AS c
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);
GO

-- Q14: Orders above the average order amount
SELECT OrderID, CustomerID, TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM dbo.Orders);
GO

-- Q15: Most expensive product(s)
SELECT ProductID, ProductName, Price
FROM dbo.Product
WHERE Price = (SELECT MAX(Price) FROM dbo.Product);
GO

-- Q16: Products in categories that have more than one product
SELECT ProductID, ProductName, CategoryID
FROM dbo.Product
WHERE CategoryID IN
(
    SELECT CategoryID
    FROM dbo.Product
    GROUP BY CategoryID
    HAVING COUNT(*) > 1
);
GO

-- Q17: Customers whose total order value exceeds the average customer order value
WITH CustomerSpend AS
(
    SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(o.TotalAmount), 0) AS TotalSpend
    FROM dbo.Customer AS c
    LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *
FROM CustomerSpend
WHERE TotalSpend > (SELECT AVG(TotalSpend) FROM CustomerSpend);
GO

-- Q18: Orders that contain a product from Personal Care
SELECT o.OrderID, o.CustomerID
FROM dbo.Orders AS o
WHERE EXISTS
(
    SELECT 1
    FROM dbo.OrderDetails AS od
    JOIN dbo.Product AS p ON p.ProductID = od.ProductID
    JOIN dbo.Category AS cat ON cat.CategoryID = p.CategoryID
    WHERE od.OrderID = o.OrderID
      AND cat.CategoryName = 'Personal Care'
);
GO

-- Q19: Each product compared with its category's average price
SELECT p.ProductName, p.Price, p.CategoryID
FROM dbo.Product AS p
WHERE p.Price >
(
    SELECT AVG(p2.Price)
    FROM dbo.Product AS p2
    WHERE p2.CategoryID = p.CategoryID
);
GO

-- Q20: Customers with the latest order date
SELECT c.CustomerID, c.CustomerName, o.OrderDateTime
FROM dbo.Customer AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderDateTime = (SELECT MAX(OrderDateTime) FROM dbo.Orders);
GO
