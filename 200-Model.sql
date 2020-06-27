IF NOT EXISTS (SELECT * FROM sys.schemas AS sch WHERE (sch.name = 'PBI'))
BEGIN
	EXEC('CREATE SCHEMA PBI');
END;
GO

CREATE OR ALTER VIEW PBI.Customer
AS
SELECT
dc.Title
,dc.FirstName AS [First name]
,dc.MiddleName AS [Middle name]
,dc.LastName AS [Last name]
,dc.Suffix
,COALESCE(dc.Title + ' ', '') + COALESCE(dc.FirstName + ' ', '') + COALESCE(dc.MiddleName + ' ', '') + COALESCE(dc.LastName + ' ', '') + COALESCE(dc.Suffix, '') AS Name
,dc.BirthDate AS [Birth date]
,dc.MaritalStatus AS [Marital status]
,CASE dc.Gender WHEN 'F' THEN 'Female' WHEN 'M' THEN 'Male' ELSE dc.gender END AS Gender
,dc.YearlyIncome AS [Yearly income]
,dc.TotalChildren AS [Number of children]
,dc.NumberChildrenAtHome AS [Number of children at home]
,dc.EnglishEducation AS Education
,dc.EnglishOccupation AS Occupation
,CASE dc.HouseOwnerFlag WHEN 1 THEN 'Yes' ELSE 'No' END AS [House owner]
,dc.NumberCarsOwned AS [Number of cars]
,dc.DateFirstPurchase AS [First purchase]
,dc.CommuteDistance AS [Commute distance]
,dg.EnglishCountryRegionName AS Country
,dg.CountryRegionCode AS [Country code]
,dg.StateProvinceName AS State
,dg.StateProvinceCode AS [State code]
,dg.City
,dg.PostalCode AS [Postal code]
,dst.SalesTerritoryGroup AS [Sales territory group]
,dst.SalesTerritoryRegion AS [Sales territory region]
,dc.CustomerKey
,dc.GeographyKey
FROM dbo.DimCustomer AS dc
LEFT OUTER JOIN dbo.DimGeography AS dg ON (dg.GeographyKey = dc.GeographyKey)
LEFT OUTER JOIN dbo.DimSalesTerritory AS dst ON (dst.SalesTerritoryKey = dg.SalesTerritoryKey);
GO

CREATE OR ALTER VIEW PBI.Date
AS
SELECT
dd.CalendarYear AS Year
,'Qtr' + CAST(dd.CalendarQuarter AS nvarchar) AS Quarter
,dd.EnglishMonthName AS Month
,dd.MonthNumberOfYear AS [Month number]
,dd.EnglishDayNameOfWeek AS [Day name]
,dd.DayNumberOfMonth AS Day
,dd.DayNumberOfWeek AS [Day number of week]
,dd.FullDateAlternateKey AS Date
FROM dbo.DimDate AS dd;
GO

CREATE OR ALTER VIEW PBI.Geography
AS
SELECT
dg.EnglishCountryRegionName AS Country
,dg.CountryRegionCode AS [Country code]
,dg.StateProvinceName AS State
,dg.StateProvinceCode AS [State code]
,dg.City
,dg.PostalCode AS [Postal code]
,dst.SalesTerritoryGroup AS [Sales territory group]
,dst.SalesTerritoryRegion AS [Sales territory region]
,dg.GeographyKey
,dg.SalesTerritoryKey
FROM dbo.DimGeography AS dg
LEFT OUTER JOIN dbo.DimSalesTerritory AS dst ON (dst.SalesTerritoryKey = dg.SalesTerritoryKey);
GO

CREATE OR ALTER VIEW PBI.InternetSales
AS
SELECT
fis.OrderQuantity AS Quantity
,fis.UnitPrice AS [Unit price]
,fis.UnitPriceDiscountPct AS [Unit discount %]
,fis.DiscountAmount AS Discount
,fis.ProductStandardCost AS [Standard cost]
,fis.TotalProductCost AS [Total cost]
,fis.SalesAmount AS [Sales amount]
,fis.TaxAmt AS [Tax amount]
,fis.Freight AS [Freight amount]
,fis.OrderDate
,fis.DueDate
,fis.ShipDate
,fis.ProductKey
,fis.OrderDateKey
,fis.DueDateKey
,fis.ShipDateKey
,fis.CustomerKey
,fis.PromotionKey
,fis.CurrencyKey
,fis.SalesTerritoryKey
FROM dbo.FactInternetSales AS fis;
GO

CREATE OR ALTER VIEW PBI.Product
AS
SELECT
dp.EnglishProductName AS Product
,dps.EnglishProductSubcategoryName AS [Product subcategory]
,dpc.EnglishProductCategoryName AS [Product category]
,dp.EnglishDescription AS Description
,dp.Color
,dp.Class
,dp.SizeRange AS [Size range]
,dp.Size
,dp.StandardCost AS Cost
,dp.ListPrice AS [List price]
,dp.DealerPrice AS [Dealer price]
,dp.ProductKey
,dp.ProductSubcategoryKey
FROM dbo.DimProduct AS dp
LEFT OUTER JOIN dbo.DimProductSubcategory AS dps ON (dps.ProductSubcategoryKey = dp.ProductSubcategoryKey)
LEFT OUTER JOIN dbo.DimProductCategory AS dpc ON (dpc.ProductCategoryKey = dps.ProductCategoryKey);
GO

CREATE OR ALTER VIEW PBI.ProductCategory
AS
SELECT
dpc.EnglishProductCategoryName AS [Product category]
,dpc.ProductCategoryKey
FROM dbo.DimProductCategory AS dpc;
GO

CREATE OR ALTER VIEW PBI.ProductSubcategory
AS
SELECT
dps.EnglishProductSubcategoryName AS [Product subcategory]
,dpc.EnglishProductCategoryName AS [Product category]
,dps.ProductSubcategoryKey
,dps.ProductCategoryKey
FROM dbo.DimProductSubcategory AS dps
LEFT OUTER JOIN dbo.DimProductCategory AS dpc ON (dpc.ProductCategoryKey = dps.ProductCategoryKey);
GO

CREATE OR ALTER VIEW PBI.SalesTerritory
AS
SELECT
dst.SalesTerritoryCountry AS Country
,dst.SalesTerritoryGroup AS [Group]
,dst.SalesTerritoryRegion AS Region
,dst.SalesTerritoryKey
FROM dbo.DimSalesTerritory AS dst;
GO
