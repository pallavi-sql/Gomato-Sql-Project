/* GOMATO PROJECT - 04 DATA VALIDATION
   Purpose: Check row counts, orphan rows, nulls, and order totals.
*/
USE GomatoDB;
GO

SELECT 'Customer' AS TableName, COUNT_BIG(*) AS RowCount FROM dbo.Customer
UNION ALL SELECT 'Address', COUNT_BIG(*) FROM dbo.Address
UNION ALL SELECT 'Category', COUNT_BIG(*) FROM dbo.Category
UNION ALL SELECT 'Store', COUNT_BIG(*) FROM dbo.Store
UNION ALL SELECT 'Product', COUNT_BIG(*) FROM dbo.Product
UNION ALL SELECT 'DeliveryPartners', COUNT_BIG(*) FROM dbo.DeliveryPartners
UNION ALL SELECT 'Orders', COUNT_BIG(*) FROM dbo.Orders
UNION ALL SELECT 'OrderDetails', COUNT_BIG(*) FROM dbo.OrderDetails;
GO

-- Check order totals against line-item totals. Differences may reflect sample-data design.
SELECT o.OrderID, o.TotalAmount,
       SUM(od.Quantity * od.UnitPrice) AS LineItemTotal
FROM dbo.Orders AS o
LEFT JOIN dbo.OrderDetails AS od ON od.OrderID = o.OrderID
GROUP BY o.OrderID, o.TotalAmount
ORDER BY o.OrderID;
GO

-- Check whether any order detail points to a missing order or product.
SELECT od.*
FROM dbo.OrderDetails AS od
LEFT JOIN dbo.Orders AS o ON o.OrderID = od.OrderID
LEFT JOIN dbo.Product AS p ON p.ProductID = od.ProductID
WHERE o.OrderID IS NULL OR p.ProductID IS NULL;
GO

-- Check missing contact fields.
SELECT CustomerID, CustomerName, Email, Phone
FROM dbo.Customer
WHERE Email IS NULL OR Phone IS NULL;
GO
