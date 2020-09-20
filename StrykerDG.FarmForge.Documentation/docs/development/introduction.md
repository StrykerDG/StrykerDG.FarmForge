---
id: 'dev_introduction'
title: 'Introduction'
sidebar_label: 'Introduction'
---

FarmForge is 100% open source and can be used however you see fit. If you would
like to contribute to the project, or just want to know more about how the 
system works, you're in the right place!

The following sections contain detailed information about how various portions
of the FarmForge software work. 

## System Architecture

FarmForge is designed so that it can be used on low cost hardware. There is also an emphasis on being able to run locally without external depencies, due to the
fact that a lot of rurual areas still lack access to high speed internet. 

FarmForge is architechted so that it can be utilized in the following ways:

### Local - Individual Devices
This is the smallest, most simple configuration you can have. This is probably sufficient for a small garden or hobbyist wanting to connect a sensor to one or two of their plants. No data is saved or preserved in this configuration.

![Diagram](/img/Local_Individual.PNG)

### Local - Devices and API
This is the next stage up in configuration, and is slightly more complex. Here, a central FarmForge server is running on your local network that hosts a web client, api, and database. The primary interactions take place between your personal device and the web client, but you can still access the FarmForge devices directly should you desire. Since a database is present, historical data can be / is saved.

![Diagram](/img/Local_Api.PNG)

### External - Devices and API
This configuration is the same as the previous (Local - Devices and API); however, it has an additional cloud-hosted API that connects to and interacts with the local API through an IoT hub. This allows us to reach our local devices from anywhere we have internet access.

![Diagram](/img/External_Api.PNG)

### External - Interconnected Systems
The Interconnected system has the same architecture as the External - Devices and API. There is just one additional link between the user's cloud-hosted API and a central FarmForge api and database. This allows FarmForge users to view device data from all other connected FarmForge systems to help them grow crops more effectively, if they desire to do so.

*NOTE* - When choosing to connect your system to the central FarmForge system, you will have the ability to choose what, if anything, gets shared.

![Diagram](/img/External_Interconnected.PNG)

## System Components
There are several components that make up the FarmForge system.

### [Devices](/docs/development/devices)

Devices are the actual IoT components that are utilized within your garden, 
greenhouse, or farm. They can be as simple as complex as desired, from a single 
sensor all the way up to multiple sensors, guages, motors, touch screens, and 
more. Devices can be used on their own, or connect to a central API, from which 
a web app can be utilized to easily control and monitor your operation.

### [Client (Web / Mobile)](/docs/development/client)

The FarmForge client is accessible through both your local and external networks when utilizing the associated API. The client allows easy access to your devices, 
in addition to farm management functionalities.

### [Local API](/docs/development/api)

The FarmForge API acts as the central hub of your local FarmForge installation. 
All devices can / will connect to the API and send their telemetry for storage 
in a database. Utilizing the API also enables use of a web app to view various 
report data, device controls, and receive text notifications.

If desired, it can be conected to an external facing API in a cloud provider so your FarmForge network can be accessed anywhere you have an internet connection.

### [External API](/docs/development/ext_api)

The external API is just an externally facing gateway that calls methods on your 
local API through the use of an IoT Hub. When outside of your local network, the 
mobile app utilizes this external API.

### [Actors](/docs/development/actors)

### [Data Model](/docs/development/data_model)

### [Migrations](/docs/development/migrations)

### [IoT Hub](/docs/development/iot_hub)

The IoT hub is what allows your local FarmForge network to be accessed from the 
outside world. The local API connects to the Hub as a client while the External 
API connects as a server. This allows communication from anywhere without having 
to open your network.