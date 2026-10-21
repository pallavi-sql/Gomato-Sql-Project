/* GOMATO PROJECT - 02 TABLE CREATION
   Purpose: Create the eight core project tables and relationships.
   Note: If your existing column names differ, compare before running.
*/
USE GomatoDB;
GO

IF OBJECT_ID('dbo.Category','U') IS NULL
BEGIN
    CREATE TABLE dbo.Category
    (
        CategoryID INT IDENTITY(1,1) CONSTRAINT PK_Category PRIMARY KEY,
        CategoryName VARCHAR(100) NOT NULL CONSTRAINT UQ_Category_CategoryName UNIQUE
    );
END;
GO

IF OBJECT_ID('dbo.Store','U') IS NULL
BEGIN
    CREATE TABLE dbo.Store
    (
        StoreID INT IDENTITY(1,1) CONSTRAINT PK_Store PRIMARY KEY,
        StoreName VARCHAR(150) NOT NULL,
        City VARCHAR(100) NOT NULL,
        Address VARCHAR(250) NULL,
        Pincode VARCHAR(10) NULL,
        StoreStatus VARCHAR(20) NOT NULL CONSTRAINT DF_Store_Status DEFAULT ('Active')
    );
END;
GO

IF OBJECT_ID('dbo.Customer','U') IS NULL
BEGIN
    CREATE TABLE dbo.Customer
    (
        CustomerID INT IDENTITY(1,1) CONSTRAINT PK_Customer PRIMARY KEY,
        CustomerName VARCHAR(150) NOT NULL,
        Email VARCHAR(255) NULL,
        Phone VARCHAR(20) NULL
    );
END;
GO

IF OBJECT_ID('dbo.Address','U') IS NULL
BEGIN
    CREATE TABLE dbo.Address
    (
        AddressID INT IDENTITY(1,1) CONSTRAINT PK_Address PRIMARY KEY,
        CustomerID INT NOT NULL,
        AddressLine VARCHAR(250) NOT NULL,
        City VARCHAR(100) NOT NULL,
        Pincode VARCHAR(10) NULL,
        CONSTRAINT FK_Address_Customer FOREIGN KEY (CustomerID)
            REFERENCES dbo.Customer(CustomerID)
    );
END;
GO

IF OBJECT_ID('dbo.DeliveryPartners','U') IS NULL
BEGIN
    CREATE TABLE dbo.DeliveryPartners
    (
        PartnerID INT IDENTITY(1,1) CONSTRAINT PK_DeliveryPartners PRIMARY KEY,
        PartnerName VARCHAR(150) NOT NULL,
        City VARCHAR(100) NOT NULL,
        VehicleType VARCHAR(50) NULL,
        Rating DECIMAL(3,2) NULL,
        AvailabilityStatus VARCHAR(20) NOT NULL CONSTRAINT DF_Partner_Availability DEFAULT ('Available')
    );
END;
GO

IF OBJECT_ID('dbo.Product','U') IS NULL
BEGIN
    CREATE TABLE dbo.Product
    (
        ProductID INT IDENTITY(1,1) CONSTRAINT PK_Product PRIMARY KEY,
        ProductName VARCHAR(150) NOT NULL,
        CategoryID INT NOT NULL,
        StoreID INT NOT NULL,
        Price DECIMAL(10,2) NOT NULL,
        CONSTRAINT CK_Product_Price CHECK (Price >= 0),
        CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID) REFERENCES dbo.Category(CategoryID),
        CONSTRAINT FK_Product_Store FOREIGN KEY (StoreID) REFERENCES dbo.Store(StoreID)
    );
END;
GO

IF OBJECT_ID('dbo.Orders','U') IS NULL
BEGIN
    CREATE TABLE dbo.Orders
    (
        OrderID INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
        CustomerID INT NOT NULL,
        AddressID INT NOT NULL,
        PartnerID INT NULL,
        OrderDateTime DATETIME2(0) NOT NULL CONSTRAINT DF_Orders_Date DEFAULT (SYSDATETIME()),
        TotalAmount DECIMAL(12,2) NOT NULL,
        PaymentStatus VARCHAR(30) NOT NULL,
        OrderStatus VARCHAR(30) NOT NULL,
        DeliveryStatus VARCHAR(30) NOT NULL,
        CONSTRAINT CK_Orders_TotalAmount CHECK (TotalAmount >= 0),
        CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID) REFERENCES dbo.Customer(CustomerID),
        CONSTRAINT FK_Orders_Address FOREIGN KEY (AddressID) REFERENCES dbo.Address(AddressID),
        CONSTRAINT FK_Orders_Partner FOREIGN KEY (PartnerID) REFERENCES dbo.DeliveryPartners(PartnerID)
    );
END;
GO

IF OBJECT_ID('dbo.OrderDetails','U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderDetails
    (
        OrderDetailID INT IDENTITY(1,1) CONSTRAINT PK_OrderDetails PRIMARY KEY,
        OrderID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10,2) NOT NULL,
        CONSTRAINT CK_OrderDetails_Quantity CHECK (Quantity > 0),
        CONSTRAINT CK_OrderDetails_UnitPrice CHECK (UnitPrice >= 0),
        CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
        CONSTRAINT FK_OrderDetails_Product FOREIGN KEY (ProductID) REFERENCES dbo.Product(ProductID)
    );
END;
GO
