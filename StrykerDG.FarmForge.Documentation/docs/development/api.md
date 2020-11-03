---
id: 'api'
title: 'API'
sidebar_label: 'API'
---

## Description

The FarmForge API is written in C#, and uses .Net Core.

## Dependencies

- [.Net Core](https://www.google.com)
- [Akka.Net](https://www.google.com) for logic
- [FluentMigrator](https://www.google.com) for running migrations at startup
- [Entity Framework](https://www.google.com) for database connections
- [NSwag](https://www.google.com) for openAPI documentation

## Endpoints

### Auth

#### POST /Auth/Login
Description: Used to receive a token<br />
Body:
```
{
    "Username": "string",
    "Password": "string"
}
```

#### GET /Auth/Users
Description: Used to get a list of users

#### POST /Auth/Users
Description: Used to create a user<br />
Body:
```
{
    "Username": "string",
    "Password": "string"
}
```

#### DELETE/Auth/Users/{userId}
Description: Used to delete a user<br />
Parameters:
- userId (int) - the Id of the user you want to delete

### Crops

#### GET /Crops
Description: Get a list of crops<br />
Parameters
- begin (string) - String that is parsed for a DateTime
- end (string) - String that is parsed for a DateTime
- includes (string) - Specifies which joins to include
- status (string) - Specifies the status of crops you want
- location (string) - Specifies the location of crops you want

#### POST /Crops
Description: Creates a new Crop
Body: 
```
{
    "CropTypeId": "int",
    "VarietyId": "int",
    "LocationId": "int",
    "Quantity": "int",
    "Date": "dateTime"
}
```

#### PATCH /Crops/{cropId}/Logs
Description: Creates a new log for the specified crop
Parameters
- cropId (int) - The id of the crop that the new log is attached to
Body:
```
{
    "LogTypeId": "int",
    "CropStatusId": "int",
    "Notes": "string",
    "UnitTypeId": "int",
    "Quantity": "int"
}
```

### CropClassifications

#### GET /CropClassifications
Description: Get a list of CropClassifications

### CropLogs

#### GET /CropLogs
Description: Used to get a list logs<br />
Parameters:
- type (string) - specify the type of log you want

### CropTypes

#### GET /CropTypes
Description: Used to get a list crop types

#### POST /CropTypes
Description: Used to create a new type<br />
Body:
```
{
    "Name": "string",
    "ClassificationId": "int"
}
```

#### DELETE /CropTypes/{id}
Description: Used to get a list logs<br />
Parameters:
- id (int) - specify the id of the crop type you want to delete

#### POST /CropTypes/{cropTypeId}/Variety/{varietyName}
Description: Used to create a new variety for the specified crop type<br />
Parameters:
- cropTypeId (int) - The id of the crop type you're adding a variety to
- varietyName (string) - The name of the variety you want to add

#### DELETE /CropTypes/{cropTypeId}/Variety/{varietyId}
Description: Used to delete a variety from a crop<br />
Parameters:
- cropTypeId (int) - the id of the crop type you're removing the variety from
- varietyId (int) - the id of the variety you want to remove

### Devices

- Coming soon!

### Locations

#### GET /Locations
Description: Used to get a list of locations

#### POST /Locations
Description: Used to create a new location<br />
Body: 
```
{
    "Label": "string",
    "ParentId: "int"
}
```

#### PATCH /Locations
Description: Used to update a location<br />
Body: 
```
{
    "Fields" : "string"
    "Location": "Location"
}
```

#### DELETE /Locations/{locationId}
Description: Used to delete the specified location<br />
Parameters:
- locationId (int) - the id of the location you wish to delete

### LogTypes

#### GET /LogTypes/{entityType}
Description: Used to get the log types related to an entity<br />
Parameters:
- entityType (string) - the entity you want to get logs types for

### Products

#### GET /Products/Inventory
Description: Gets a list of products that are currently in inventory

#### POST /Products/Inventory
Description: Creates a new item in inventory
Body: 
```
{
    "SupplierId": "int",
    "ProductTypeId": "int",
    "LocationId": "int",
    "Quantity": "int",
    "UnitTypeId": "int"
}
```

#### POST /Products/Consume
Description: Consumes the specified products
Body: 
```
{
    "ProductIds": "List<int>"
}
```

#### POST /Products/Inventory/Transfer
Description: Transfers inventory from one location to another
Body:
```
{
    "ProductIds": "int[]",
    "LocationId": "int"
}
```

#### POST /Products/Inventory/Split
Description: Converts the specified products into a new unit based on the UnitTypeConversion
Body:
```
{
    "ProductIds": "List<int>",
    "UnitTypeConversionId": "int",
    "LocationId": "int"
}
```

#### GET /Products
Description: Retrieves a list of product types

#### POST /Products
Description: Creates a new ProductType
Body:
```
{
    "ProductTypeId": "int",
    "ProductCategoryId": "int",
    "Name": "string",
    "Label": "string",
    "ReorderLevel": "int"
}
```

#### PATCH /Products
Description: Updates the specified product type
Body: 
```
{
    "ProductTypeId": "int",
    "ProductCategoryId": "int",
    "Name": "string",
    "Label": "string",
    "ReorderLevel": "int"
}
```

#### DELETE /Products/{productTypeId}
Description: Deletes the specified product type
Parameters:
- productTypeId (int) - The id of the product type you wish to delete

#### GET /Products/Categories
Description: Retrieves a list of product categories

#### POST /Products/Categories
Description: Creates a new product category
Body:
```
{
    "ProductCategoryId": "int",
    "Name": "string",
    "Label": "string",
    "Description": "string"
}
```

#### DELETE /Products/Categories/{productCategoryId}
Description: Deletes the specified product category
Parameters:
- productCategoryId (int) - The id of the category you want to delete

### Statuses

#### GET /Statuses/{entityType}
Description: Used to get the statuses related to an entity<br />
Parameters:
- entityType (string) - the entity you want to get statuses for

### Suppliers

#### GET /Suppliers
Description: Retrieves a list of suppliers
Parameters:
- includes (string) - specify if you wish to include the supplier products

#### POST /Suppliers
Description: Create a new supplier
Body:
```
{
    "Supplier": "Supplier",
    "ProductIds": "List<int>"
}
```

#### PATCH /Suppliers
Description: Updates the specified Supplier
Body: 
```
{
    "Supplier": "Supplier",
    "ProductIds": "List<int>"
}
```

#### DELETE /Suppliers/{supplierId}
Description: Deletes the specified supplier
Parameters:
- supplierId (int) - The id of the supplier you want to delete

#### GET /Suppliers/{supplierId}/Products
Description: Retrieves the products that the supplier provides
Parameters:
- supplierId (int) - The id of the supplier you want products for

### Units

#### GET /Units
Description: Retrieves the unit types

#### POST /Units
Description: Creates a new unit type
Body: 
```
{
    "UnitTypeId": "int",
    "Name": "string",
    "Label": "string",
    "Description": "string"
}
```

#### DELETE /Units/{unitTypeId}
Description: Delete the specified unit type
Parameters:
- unitTypeId (int) - The id of the unit type you want to delete

#### GET /Units/Conversions
Description: Retrieve a list of unit type conversions

#### GET /Units/Conversions/{unitId}
Description: Retrieve a list of conversions for a speficic unit
Parameters:
- unitId (int) - The id of the unit you want conversions for

#### POST /Units/Conversions
Description: Creates a new UnitTypeConversion
Body: 
```
{
    "UnitTypeConversionId": "int",
    "FromUnitId": "int",
    "ToUnitId": "int",
    "FromQuantity": "int",
    "ToQuantity": "int"
}
```

#### PATCH /Units/Conversions
Description: Updates the specified UnitTypeConversion
Body: 
```
{
    "UnitTypeConversionId": "int",
    "FromUnitId": "int",
    "ToUnitId": "int",
    "FromQuantity": "int",
    "ToQuantity": "int"
}
```

#### DELETE /Units/Conversions/{conversionId}
Description: Deletes the specified unit type conversion
Parameters:
- conversionId (int) - The id of the unit type conversion you want to delete