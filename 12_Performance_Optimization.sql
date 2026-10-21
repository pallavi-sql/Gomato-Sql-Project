/* GOMATO PROJECT - 12 PERFORMANCE OPTIMIZATION
   Purpose: Add useful indexes only when equivalent indexes do not already exist,
            and provide examples for checking query plans and index metadata.
   Note: Compare actual execution plans and timings before/after on representative data.
*/
USE GomatoDB;
GO

-- Indexes supporting common filters and joins
IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.Orders')
      AND name = 'IX_Orders_CustomerID_OrderDateTime'
)
    CREATE INDEX IX_Orders_CustomerID_OrderDateTime
    ON dbo.Orders (CustomerID, OrderDateTime)
    INCLUDE (TotalAmount, OrderStatus, DeliveryStatus);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.OrderDetails')
      AND name = 'IX_OrderDetails_ProductID'
)
    CREATE INDEX IX_OrderDetails_ProductID
    ON dbo.OrderDetails (ProductID)
    INCLUDE (OrderID, Quantity, UnitPrice);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.Product')
      AND name = 'IX_Product_CategoryID'
)
    CREATE INDEX IX_Product_CategoryID
    ON dbo.Product (CategoryID)
    INCLUDE (ProductName, Price, StoreID);
GO

-- SARGable date filter: can use an index on OrderDateTime if one exists.
DECLARE @StartDate DATETIME2(0) = DATEADD(DAY, -7, SYSDATETIME());
SELECT OrderID, OrderDateTime, TotalAmount
FROM dbo.Orders
WHERE OrderDateTime >= @StartDate;
GO

-- Avoid wrapping the date column in a function in the WHERE clause when possible.
-- Less index-friendly pattern example (for learning only):
SELECT OrderID, OrderDateTime
FROM dbo.Orders
WHERE CAST(OrderDateTime AS DATE) = CAST(SYSDATETIME() AS DATE);
GO

-- Review indexes for the core tables
SELECT OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,
       OBJECT_NAME(i.object_id) AS TableName,
       i.name AS IndexName, i.type_desc, i.is_primary_key, i.is_unique
FROM sys.indexes AS i
WHERE i.object_id IN
(
    OBJECT_ID('dbo.Orders'),
    OBJECT_ID('dbo.OrderDetails'),
    OBJECT_ID('dbo.Product')
)
ORDER BY TableName, IndexName;
GO

-- Inspect index usage since the last SQL Server service restart.
SELECT OBJECT_NAME(i.object_id) AS TableName, i.name AS IndexName,
       us.user_seeks, us.user_scans, us.user_lookups, us.user_updates
FROM sys.indexes AS i
LEFT JOIN sys.dm_db_index_usage_stats AS us
    ON us.object_id = i.object_id
   AND us.index_id = i.index_id
   AND us.database_id = DB_ID()
WHERE i.object_id IN
(
    OBJECT_ID('dbo.Orders'),
    OBJECT_ID('dbo.OrderDetails'),
    OBJECT_ID('dbo.Product')
)
ORDER BY TableName, IndexName;
GO

-- In SSMS, enable Include Actual Execution Plan (Ctrl+M) before running representative queries.
