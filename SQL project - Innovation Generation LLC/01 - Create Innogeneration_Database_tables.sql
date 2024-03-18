CREATE DATABASE [Innogeneration]
GO

USE [Innogeneration]
GO



CREATE TABLE [dbo].[Addresses](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[CityID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED ([AddressID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Cities](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[ProvinceID] [int] NOT NULL,
	[Population] [bigint] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED (	[CityID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Countries](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[CountryCode] [nvarchar](3) NULL,
	[Population] [bigint] NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED ([CountryID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[FullName]  AS (([FirstName]+' ')+[LastName]),
	[Title] [nvarchar](30) NOT NULL,
	[DeliveryAddressID] [int] NOT NULL,
	[BillingAddressID] [int] NOT NULL,
	[PhoneNumber] [nvarchar](24) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[Title] [nvarchar](25) NOT NULL,
	[BirthDate] [datetime] NOT NULL,
	[Gender] [nchar](10) NOT NULL,
	[HireDate] [datetime] NOT NULL,
	[JobTitle] [nvarchar](100) NOT NULL,
	[AddressID] [int] NOT NULL,
	[ManagerID] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ingredients](
	[IngredientID] [int] IDENTITY(1,1) NOT NULL,
	[IngredientName] [nvarchar](200) NULL,
	[UnitOfMeasureID] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Ingredients] PRIMARY KEY CLUSTERED ([IngredientID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InventoryItems](
	[InventoryItemID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[IngredientID] [int] NULL,
	[PackageTypeID] [int] NOT NULL,
	[UnitOfMeasureID] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[VATRate] [decimal](18, 3) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[RecommendedRetailPrice] [decimal](18, 2) NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_InventoryItems] PRIMARY KEY CLUSTERED ([InventoryItemID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[InventoryTransactions](
	[InventoryTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryItemID] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[OrderID] [int] NULL,
	[TransactionDate] [datetime2](7) NOT NULL,
	[Quantity] [decimal](18, 3) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_InventoryTransactions] PRIMARY KEY CLUSTERED ([InventoryTransactionID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[OrderLines](
	[OrderLineID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[PromotionID] [int] NULL,
	[InventoryItemID] [int] NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Discount] [decimal](18, 2) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[LineNumber] [nvarchar](10) NULL,
	[VATRate] [decimal](18, 2) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[EmployeeID] [int] NOT NULL,
	[DeliveryAddressID] [int] NOT NULL,
	[PaymentTypeID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DeliveryDate] [datetime] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[Status] [int] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[PaymentTypes](
	[PaymentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PaymentTypeName] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PaymentTypes] PRIMARY KEY CLUSTERED ([PaymentTypeID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProductCategories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](15) NOT NULL,
	[CategoryDescription] [nvarchar](200) NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProductDepartments](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductDepartments] PRIMARY KEY CLUSTERED ([DepartmentID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[ProductCode] [nvarchar](10) NOT NULL,
	[ProductDescription] [nvarchar](200) NOT NULL,
	[SubcategoryID] [int] NOT NULL,
	[UnitOfMeasureID] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[Discontinued] [bit] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Products2] PRIMARY KEY CLUSTERED ([ProductID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProductSubcategories](
	[ProductSubcategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[SubcategoryName] [nvarchar](200) NOT NULL,
	[SubcategoryDescription] [nvarchar](200) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductSubcategories] PRIMARY KEY CLUSTERED ([ProductSubcategoryID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Promotions](
	[PromotionID] [int] IDENTITY(1,1) NOT NULL,
	[DealDescription] [nvarchar](30) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[DiscountAmount] [decimal](18, 2) NULL,
	[DiscountPercentage] [decimal](18, 3) NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Promotions] PRIMARY KEY CLUSTERED ([PromotionID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Provinces](
	[ProvinceID] [int] IDENTITY(1,1) NOT NULL,
	[ProvinceCode] [nvarchar](5) NOT NULL,
	[ProvinceName] [nvarchar](200) NOT NULL,
	[CountryID] [int] NOT NULL,
	[Population] [bigint] NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Provinces] PRIMARY KEY CLUSTERED ([ProvinceID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Recipes](
	[RecipeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[IngredientID] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Comments] [nvarchar](2000) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ValidFrom] [datetime2](0) NOT NULL,
	[ValidTo] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_Recipes] PRIMARY KEY CLUSTERED ([RecipeID] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Stores](
	[StoreID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[ManagerID] [int] NULL,
	[AddressID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Stores] PRIMARY KEY CLUSTERED ([StoreID] ASC)
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnitsOfMeasure](
	[UnitOfMeasureID] [int] IDENTITY(1,1) NOT NULL,
	[UnitMeasureCode] [nchar](3) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UnitsOfMeasure] PRIMARY KEY CLUSTERED ([UnitOfMeasureID] ASC)
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[Addresses] ADD  CONSTRAINT [DF_Addresses_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Cities] ADD  CONSTRAINT [DF_Cities_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Countries] ADD  CONSTRAINT [DF_Countries_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Customers] ADD  CONSTRAINT [DF_Customers_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Ingredients] ADD  CONSTRAINT [DF_Ingredients_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  CONSTRAINT [DF_InventoryItems_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[InventoryTransactions] ADD  CONSTRAINT [DF_InventoryTransactions_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[OrderLines] ADD  CONSTRAINT [DF_OrderLines_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [dbo].[PaymentTypes] ADD  CONSTRAINT [DF_PaymentTypes_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  CONSTRAINT [DF_ProductCategories_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[ProductDepartments] ADD  CONSTRAINT [DF_ProductDepartments_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products2_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[ProductSubcategories] ADD  CONSTRAINT [DF_ProductSubcategories_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Promotions] ADD  CONSTRAINT [DF_Promotions_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Provinces] ADD  CONSTRAINT [DF_Provinces_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF_Recipes_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Stores] ADD  CONSTRAINT [DF_Stores_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[UnitsOfMeasure] ADD  CONSTRAINT [DF_UnitsOfMeasure_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
