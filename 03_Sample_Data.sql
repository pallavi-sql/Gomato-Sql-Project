/* GOMATO PROJECT - 03 SAMPLE DATA
   Purpose: Insert small sample data once, so the script can be rerun safely.
*/
USE GomatoDB;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Category)
BEGIN
    INSERT dbo.Category (CategoryName)
    VALUES ('Personal Care'), ('Clothing'), ('Jewellery'), ('Wellness');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Store)
BEGIN
    INSERT dbo.Store (StoreName, City, Address, Pincode, StoreStatus)
    VALUES
    ('Gomato Central', 'Pune', 'FC Road', '411004', 'Active'),
    ('Gomato East', 'Pune', 'Kharadi', '411014', 'Active'),
    ('Gomato West', 'Pune', 'Baner Road', '411045', 'Active');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Customer)
BEGIN
    INSERT dbo.Customer (CustomerName, Email, Phone)
    VALUES
    ('Aditi Sharma', 'aditi@example.com', '9000000001'),
    ('Neha Patil', 'neha@example.com', '9000000002'),
    ('Riya Deshmukh', 'riya@example.com', '9000000003'),
    ('Sneha Kulkarni', NULL, '9000000004'),
    ('Maya Joshi', 'maya@example.com', NULL);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Address)
BEGIN
    INSERT dbo.Address (CustomerID, AddressLine, City, Pincode)
    VALUES
    (1, 'Lane 1, Shivajinagar', 'Pune', '411005'),
    (2, 'Phase 2, Kharadi', 'Pune', '411014'),
    (3, 'Near Baner Road', 'Pune', '411045'),
    (4, 'Camp Area', 'Pune', '411001'),
    (5, 'Aundh Road', 'Pune', '411007');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DeliveryPartners)
BEGIN
    INSERT dbo.DeliveryPartners (PartnerName, City, VehicleType, Rating, AvailabilityStatus)
    VALUES
    ('Kavya More', 'Pune', 'Scooter', 4.80, 'Available'),
    ('Pooja Kale', 'Pune', 'Bike', 4.60, 'Available'),
    ('Anaya Shah', 'Pune', 'Scooter', 4.90, 'Unavailable');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Product)
BEGIN
    INSERT dbo.Product (ProductName, CategoryID, StoreID, Price)
    VALUES
    ('Sanitary Pads Pack', 1, 1, 120.00),
    ('Cotton T-Shirt', 2, 2, 499.00),
    ('Silver Earrings', 3, 1, 799.00),
    ('Wellness Kit', 4, 3, 349.00),
    ('Daily Liners', 1, 2, 90.00),
    ('Scarf', 2, 3, 299.00),
    ('Bracelet', 3, 2, 599.00);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Orders)
BEGIN
    INSERT dbo.Orders
        (CustomerID, AddressID, PartnerID, OrderDateTime, TotalAmount, PaymentStatus, OrderStatus, DeliveryStatus)
    VALUES
    (1, 1, 1, DATEADD(DAY,-4,SYSDATETIME()), 240.00, 'Paid', 'Completed', 'Delivered'),
    (2, 2, 2, DATEADD(DAY,-3,SYSDATETIME()), 499.00, 'Paid', 'Completed', 'Delivered'),
    (3, 3, 1, DATEADD(DAY,-2,SYSDATETIME()), 799.00, 'Paid', 'Completed', 'Delivered'),
    (1, 1, 2, DATEADD(DAY,-1,SYSDATETIME()), 439.00, 'Pending', 'Processing', 'In Transit'),
    (4, 4, NULL, SYSDATETIME(), 90.00, 'Pending', 'Placed', 'Pending'),
    (5, 5, 1, DATEADD(DAY,-6,SYSDATETIME()), 648.00, 'Paid', 'Completed', 'Delivered');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.OrderDetails)
BEGIN
    INSERT dbo.OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES
    (1, 1, 2, 120.00),
    (2, 2, 1, 499.00),
    (3, 3, 1, 799.00),
    (4, 4, 1, 349.00),
    (4, 5, 1, 90.00),
    (5, 5, 1, 90.00),
    (6, 6, 1, 299.00),
    (6, 7, 1, 349.00);
END;
GO
