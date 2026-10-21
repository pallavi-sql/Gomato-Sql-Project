/* GOMATO PROJECT - 11 SQL OBJECTS
   Purpose: Create reusable views, stored procedures, a function, an audit table/trigger,
            and safe transaction examples.
   Review object names before running if you already created objects with these names.
*/
USE GomatoDB;
GO

-- VIEW: reusable order summary
CREATE OR ALTER VIEW dbo.vw_GomatoOrderSummary
AS
SELECT o.OrderID, c.CustomerName, o.OrderDateTime, o.TotalAmount,
       o.PaymentStatus, o.OrderStatus, o.DeliveryStatus
FROM dbo.Orders AS o
JOIN dbo.Customer AS c ON c.CustomerID = o.CustomerID;
GO

-- View usage
SELECT * FROM dbo.vw_GomatoOrderSummary;
GO

-- STORED PROCEDURE: return orders for one customer
CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT OrderID, CustomerID, OrderDateTime, TotalAmount, PaymentStatus, OrderStatus, DeliveryStatus
    FROM dbo.Orders
    WHERE CustomerID = @CustomerID
    ORDER BY OrderDateTime DESC;
END;
GO

-- Procedure usage example
EXEC dbo.usp_GetCustomerOrders @CustomerID = 1;
GO

-- FUNCTION: calculate a line amount
CREATE OR ALTER FUNCTION dbo.ufn_GomatoLineAmount
(
    @Quantity INT,
    @UnitPrice DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN CAST(@Quantity * @UnitPrice AS DECIMAL(12,2));
END;
GO

-- Function usage
SELECT dbo.ufn_GomatoLineAmount(2, 120.00) AS ExampleLineAmount;
GO

-- Trigger audit table
IF OBJECT_ID('dbo.GomatoOrderStatusAudit','U') IS NULL
BEGIN
    CREATE TABLE dbo.GomatoOrderStatusAudit
    (
        AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
        OrderID INT NOT NULL,
        OldOrderStatus VARCHAR(30) NULL,
        NewOrderStatus VARCHAR(30) NULL,
        ChangedAt DATETIME2(0) NOT NULL CONSTRAINT DF_GomatoAudit_ChangedAt DEFAULT (SYSDATETIME()),
        ChangedBy SYSNAME NOT NULL CONSTRAINT DF_GomatoAudit_ChangedBy DEFAULT (SUSER_SNAME())
    );
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_GomatoOrders_StatusAudit
ON dbo.Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(OrderStatus)
    BEGIN
        INSERT dbo.GomatoOrderStatusAudit (OrderID, OldOrderStatus, NewOrderStatus)
        SELECT i.OrderID, d.OrderStatus, i.OrderStatus
        FROM inserted AS i
        JOIN deleted AS d ON d.OrderID = i.OrderID
        WHERE ISNULL(i.OrderStatus, '') <> ISNULL(d.OrderStatus, '');
    END;
END;
GO

-- Trigger test: use a transaction and roll it back so the sample order stays unchanged.
BEGIN TRANSACTION;
UPDATE dbo.Orders
SET OrderStatus = CASE WHEN OrderStatus = 'Processing' THEN 'Placed' ELSE 'Processing' END
WHERE OrderID = (SELECT MIN(OrderID) FROM dbo.Orders);
SELECT TOP (10) * FROM dbo.GomatoOrderStatusAudit ORDER BY AuditID DESC;
ROLLBACK TRANSACTION;
GO

-- Transaction example: demonstrate rollback without leaving a permanent change.
BEGIN TRANSACTION;
UPDATE dbo.Orders
SET PaymentStatus = 'Test Status'
WHERE OrderID = -999; -- no sample order is expected to match
ROLLBACK TRANSACTION;
GO
