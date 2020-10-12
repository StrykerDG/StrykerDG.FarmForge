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
Navigate to the StrykerDG.FarmForge.Client/farmforge_client/lib/utilities/settings.dart file, and update the development, test, and production urls to the appropriate values. These urls are the root address of the FarmForge API

```
  static String developmentUrl = 'https://localhost:44310';
  static String testUrl = 'https://localhost:443';
  static String productionUrl = '';

  static setApiUrl() {
    var location = window.location.toString();
    if(location.contains('localhost:3000'))
      FarmForgeApiService.apiUrl = developmentUrl;
    else if(location.contains('localhost'))
      FarmForgeApiService.apiUrl = testUrl;
    else 
      FarmForgeApiService.apiUrl = productionUrl;
  }
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
decide how you want to host the API. The following methods are outlined below:

[RaspberryPi - Ubuntu](#local-installation-rasberry-pi---ubuntu)<br />
[RaspberryPi - Windows 10 Iot Core](#local-installation-rasberry-pi---windows-10-iot-core)<br />
[IIS](#local-installation-iis)<br />
[Azure Web App](#cloud-installation-azure-web-app)

#### Local Installation (Rasberry PI - Ubuntu)

1. Install Ubuntu for Raspberry Pi on an SD card following this [tutorial](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview)

2. Install [.Net Core 3.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)

3. Install nginx
```
sudo apt update
sudo apt install nginx
```

4. If you haven't already, publish the api on your dev maching by running the 
following command
```
dotnet publish -o publish --self-contained -r linux-arm
```

5. Copy the contents of the publish folder to /var/www/html

6. Update the nginx service block
```
sudo vim /etc/nginx/sites-available/default
``` 

It should resemble the following
```
server {
    listen        80;
    server_name   farmforge;
    root /var/www/html;
    location / {
        proxy_pass         http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
```

Then restart the service
```
sudo service nginx start
- OR -
sudo service nginx restart
```

7. Create a .Net service
```
sudo vim /etc/systemd/system/farmforge.service
```

It should resemble the following
```
[Unit]
Description=This is a service for running the FarmForge API

[Service]
WorkingDirectory=/var/www/html
ExecStart=<PATH_TO_DOTNET> /var/www/html/StrykerDG.FarmForge.LocalApi.dll
Restart=always
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=farmforge
User=ubuntu
Environment=ASPNETCORE_ENVIRONMENT=<ENV>
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
[WantedBy=multi-user.target]
```

Then enable and start the service
```
sudo systemctl enable farmforge.service
sudo systemctl start farmforge.service
```

#### Local Installation (Rasberry PI - Windows 10 IoT Core)

1. Install the [Windows 10 IoT Core Dashboard](https://docs.microsoft.com/en-us/windows/iot-core/connect-your-device/iotdashboard)

2. Use the dashboard to install Windows 10 IoT Core on an SD, and boot the 
Raspberry Pi with it.

3. If you haven't already, publish the API to a folder. Be sure to build for ARM and uncomment the following line in StrykerDG.FarmForge.LocalApi.csproj
```
<RuntimeIdentifier>win8-arm</RuntimeIdentifier>
```

4. Open windows explorer and navigate to the Raspberry Pi's C:\ drive. Create a 
FarmForge directory and copy the contents of the publish folder to it.

5. Copy the appsettings files, as well as the wwwroot directory to C:\Data\Users\administrator\Documents
directory.

6. From the IoT Core Dashboard, find your device and launch a powershell instance

7. Set the aspnetcore environment variable
```
setx ASPNETCORE_ENVIRONMENT "Production"
```

8. Open a port for the application by running the following command
```
netsh advfirewall firewall add rule name="ASP.NET Core Web Server port" dir=in action=allow protocol=TCP localport=<PORT_NUMBER>
```

9. Start the API by running the following command
```
C:\FarmForge\StrykerDG.FarmForge.LocalApi.exe --urls http://*:<PORT_NUMBER>
```

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

**Note** If you see an inprocess startup error when viewing the site, this 
could be due to the not being able to read the environment variables. Changing
the identity of the Application Pool to a custom account should resolve this.

#### Cloud Installation (Azure Web App)

1. Log into the [AzurePortal](https://portal.azure.com/) and create an App 
Service Plan and WebApp. The app service plan should be windows (linux should work)
and the web app should be .Net Core 3.1

2. In the WebApp configuration, set the ASPNETCORE_ENVIRONMENT to Production

![AppService](/img/installation/azure_001.PNG)

2. From Visual Studio, right click the api project and click publish. Create an
azure publish profile, and select Azure App Service

![AppService](/img/installation/azure_002.PNG)

3. Select the app service you created in step 1, and click publish