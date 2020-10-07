---
id: 'installation'
title: 'Installation'
sidebar_label: 'Installation'
---

There are a number of ways that you can install and utilize FarmForge, depending 
on your particular use case and what you want to get out of it.

## Devices
FarmForge Devices are IoT devices that can be used individually, or connect to 
the centeral FarmForge system. This sections specifies how to create and utilize 
the devices found in the [FarmForge Repo](https://github.com/StrykerDG/StrykerDG.FarmForge), 
as well as going into detail about how you can create your own custom devices 
that will work with the system.

### Install a Preconfigured FarmForge Device

- Coming soon!

### Create your own FarmForge Device

- Coming soon!

## Web / Mobile App
Before using the web app, you will need to build and deploy it. You can use the 
wwwroot folder of the API if you wish, or you can host it elsewhere, such as in the 
cloud. The web app is build using [Flutter](https://flutter.dev/docs/get-started/install), 
so you will need to install that before continuing.

### Clone the project
If you haven't already, you will need to clone the project from 
[github](https://github.com/StrykerDG/StrykerDG.FarmForge).

### Update the url settings.
Navigate to the StrykerDG.FarmForge.Client/farmforge_client/lib/utilities/settings/settings.dart file, and update the development, test, and production urls to the appropriate 
values. These urls are the root address of the FarmForge API

```
  static String developmentUrl = 'https://localhost:44310';
  static String testUrl = '';
  static String productionUrl = '';
```

### Perform a Build
From the terminal, make sure you are in the StrykerDG.FarmForge.Client/farmforge_client 
directory. From here, perform a build with the following command

```
flutter build web
```

The build files should be located in the StrykerDG.FarmForge.Client\farmforge_client\build\web folder

### Host the files
Depending on your preferences, you can host the files directly on the API, on IIS, or 
on a cloud provider of your choice.

The simplest option is to copy the contents of the /build folder to the /wwwroot folder 
of the API.

## API
The FarmForge API is the core of the project. They are what aid
in the actual management of your garden, greenhouse, or farm, and connect 
individual Devices together. There are a few different ways to host / install
the API, depending on your budget and desires.

### Clone the Project
If you haven't already, you will need to clone the project from 
[github](https://github.com/StrykerDG/StrykerDG.FarmForge).

### Create the appsettings.json Files
The API gets its configuration from the appsettings.json files, however these need 
to be created. You can create them in the StrykerDG.FarmForge.API directory.

appsettings.json is the main settings file, and contains settings that are shared 
throught all environments. The format should be as follows

```
{
  "ApiSettings": {
    "MajorVersion": 0,
    "MinorVersion": 1,
    "SwaggerSettings": {
      "Title": "StrykerDG.FarmForge",
      "Description": "An API to manage and interact with FarmForge devices",
      "TermsOfService": "",
      "ContactName": "StrykerDG",
      "ContactEmail": "Stryker@StrykerDG.com",
      "ContactURL": "www.StrykerDG.com",
      "LicenseName": "",
      "LicenseURL": ""
    },
    "Logging": {
      "LogLevel": {
        "Default": "Information",
        "Microsoft": "Warning",
        "Microsoft.Hosting.Lifetime": "Information"
      }
    }
  },
  "AllowedHosts": "*"
}
```

appsettings.Development.json, appsettings.Test.json, and appsettings.Production.json 
all have the same format, but contain settings that are specific to, and can change 
between, environments. The format should be as follows

```
{
  "ApiSettings": {
    "CORS": [ <Allowed_Client_Addresses> ],
    "DatabaseType": "SQLSERVER",
    "ConnectionStrings": {
      "Database": "<DB_Connection_String>",
    }
  },
  "SecuritySettings": {
    "SecretKey": "<Secret_Key_For_Token_Generation>",
    "Audience": "FarmForge.io",
    "Issuer": "FarmForge.io"
  }
}
```

- The "DatabaseType" can be "SQLITE" or "SQLSERVER" depending on which you prefer 
to use.
- The "Database" connection string can be "Data Source=FarmForge.db" if using SQLITE. 
If using SQLSERVER, you will need to use "Server=ServerName;Database=DatabaseName;Integrated Security=True;

### Create the Database
If you decide to use SQLITE, no further configuration is needed. If you perfer to use 
SQL Server however, you will need to create the database at this point, and make sure 
you specify the connection string in the appsettings.json file

### Add the Client Files
If you wish to host the API and web client together, you'll need to build the 
client at this point if you havent already. Then, copy the contents of the client's 
"build" folder into the "wwwroot" folder of the api. You can overwrite any files that
are present there.

### Publish the API
Once you creat the appsettings.json files and create the database, you need to 
decide how you want to host the API.

#### Local Installation (Rasberry PI)

1. Install Ubuntu for Raspberry Pi on an SD card following the [tutorial](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview)
2. 

#### Local Installation (IIS)

1. Install IIS on the machine that you will be hosting FarmForge on
2. Install the [.Net Core Hosting Bundle](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/?view=aspnetcore-3.1#install-the-net-core-hosting-bundle)

3. Create a new site

![NewSite](/img/installation/iis_001.PNG)

4. Enter the site settings

![NewSite](/img/installation/iis_002.PNG)

**Note** If you run into an error while creating the site, open an admin command 
prompt and run the command *iisreset*

5. Specify the correct Environemnt variable based on the settings you want to
use (Development, Test, or Production)

![NewSite](/img/installation/iis_003.PNG)

6. Create a release build and publish the API project to a folder profile

![NewSite](/img/installation/iis_004.PNG)

7. Stop the IIS site, copy the contents of the publish folder to the IIS site 
directory, and then start the IIS site

**Note** When attempting to access the site, you may be presented with an inprocess
startup error. This seems to be due to the fact that it can't find 
"appsettings..json" even though it finds the correct file while running in IIS 
Express. Investigation is ongoing

#### Cloud Installation (Azure Web App)
Details coming soon!