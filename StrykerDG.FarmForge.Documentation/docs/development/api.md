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

### Statuses

#### GET /Statuses/{entityType}
Description: Used to get the statuses related to an entity<br />
Parameters:
- entityType (string) - the entity you want to get statuses for