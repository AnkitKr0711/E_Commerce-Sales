CREATE TABLE [Suppliers] (
  [SupplierID] integer PRIMARY KEY,
  [CompanyName] nvarchar(255),
  [Address] nvarchar(255),
  [City] nvarchar(255),
  [State] nvarchar(255),
  [PostalCode] integer,
  [Country] nvarchar(255),
  [Phone] integer,
  [Email] nvarchar(255)
)
GO

CREATE TABLE [Products] (
  [ProductID] integer PRIMARY KEY,
  [Product] nvarchar(255),
  [CategoryID] integer,
  [SubCategory] nvarchar(255),
  [Brand] nvarchar(255),
  [SalePrice] integer,
  [MarketPrice] integer,
  [Type] nvarchar(255),
  [Rating] integer
)
GO

CREATE TABLE [Category] (
  [CategoryID] integer PRIMARY KEY,
  [CategoryName] nvarchar(255),
  [Active] integer
)
GO

CREATE TABLE [Shippers] (
  [ShipperID] integer PRIMARY KEY,
  [CompanyName] nvarchar(255),
  [Phone] integer
)
GO

CREATE TABLE [OrderDetails] (
  [OrderDetailID] integer PRIMARY KEY,
  [OrderID] integer,
  [ProductID] integer,
  [Quantity] integer,
  [SupplierID] integer
)
GO

CREATE TABLE [Orders] (
  [OrderID] integer PRIMARY KEY,
  [CustomerID] integer,
  [PaymentID] integer,
  [OrderDate] timestamp,
  [ShipperID] integer,
  [TotalOrderAmount] integer,
  [shipDate] timestamp,
  [DeliveryDate] timestamp
)
GO

CREATE TABLE [Customers] (
  [CustomerID] integer PRIMARY KEY,
  [FirstName] nvarchar(255),
  [LastName] nvarchar(255),
  [City] nvarchar(255),
  [State] nvarchar(255),
  [Country] nvarchar(255),
  [PostalCode] integer,
  [Phone] integer,
  [Email] nvarchar(255),
  [DateEntered] timestamp
)
GO

CREATE TABLE [Payments] (
  [PaymentID] integer PRIMARY KEY,
  [PaymentType] nvarchar(255),
  [Allowed] integer
)
GO

ALTER TABLE [OrderDetails] ADD FOREIGN KEY ([SupplierID]) REFERENCES [Suppliers] ([SupplierID])
GO

ALTER TABLE [OrderDetails] ADD FOREIGN KEY ([ProductID]) REFERENCES [Products] ([ProductID])
GO

ALTER TABLE [Products] ADD FOREIGN KEY ([CategoryID]) REFERENCES [Category] ([CategoryID])
GO

ALTER TABLE [OrderDetails] ADD FOREIGN KEY ([OrderID]) REFERENCES [Orders] ([OrderID])
GO

ALTER TABLE [Orders] ADD FOREIGN KEY ([ShipperID]) REFERENCES [Shippers] ([ShipperID])
GO

ALTER TABLE [Orders] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customers] ([CustomerID])
GO

ALTER TABLE [Orders] ADD FOREIGN KEY ([PaymentID]) REFERENCES [Payments] ([PaymentID])
GO
