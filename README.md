# FarmForge
FarmForge is an open source project that allows farmers, gardeners, and hobbyists to enhance their operations by utilizing IoT devices with minimal effort.

FarmForge is designed to be low-cost and configurable in order to meet each individual's specific needs. The Priority and emphasis is on working via the local network, but it can be reached everywhere through the use of a cloud provider such as Azure.

In addition to having open access to the source code, there are also opportunities to purchase pre-built and pre-configured devices to speed up deployment and utilization.

# Contact & Contributing
The easiest way to reach out is the [Discord](https://discord.gg/rfyhhTE) server. There are channels for general discussion, feature requests, issues, and ongoing development.

For those looking to activly participate or assist in development, there is plenty to do, including web & mobile (Flutter), api (.net core), embedded (c++ / c#), cloud, and even graphics or design.

Additional information coming soon!

# Architecture
FarmForge can be as small as a single IoT device connected to a wireless network, but it can be expanded exponentially. Below are the high-level architectures that FarmForge utilizes.

## Local - Individual Devices
This is the smallest, most simple configuration you can have. This is probably sufficient for a small garden or hobbyist wanting to connect a sensor to one or two of their plants. No data is saved or preserved in this configuration.

![Diagram](Docs/Local_Individual.png)

## Local - Devices and API
This is the next stage up in configuration, and is slightly more complex. Here, a central FarmForge server is running on your local network that hosts a web client, api, and database. The primary interactions take place between your personal device and the web client, but you can still access the FarmForge devices directly should you desire. Since a database is present, historical data can be / is saved.

![Diagram](Docs/Local_Api.png)

## External - Devices and API
This configuration is the same as the previous (Local - Devices and API); however, it has an additional cloud-hosted API that connects to and interacts with the local API through an IoT hub. This allows us to reach our local devices from anywhere we have internet access.

![Diagram](Docs/External_Api.png)

## External - Interconnected Systems
The Interconnected system has the same architecture as the External - Devices and API. There is just one additional link between the user's cloud-hosted API and a central FarmForge api and database. This allows FarmForge users to view device data from all other connected FarmForge systems to help them grow crops more effectively, if they desire to do so.

*NOTE* - When choosing to connect your system to the central FarmForge system, you will have the ability to choose what, if anything, gets shared.

![Diagram](Docs/External_Interconnected.png)

# Components
There are multiple components that can be utilized within FarmForge, depending on how you want to utilize the system and what your end goals are.

## [Devices](https://github.com/StrykerDG/StrykerDG.FarmForge/tree/master/StrykerDG.FarmForge.Devices)
Devices are the actual IoT components that are utilized within your farm, garden, or greenhouse. They can be as simple as complex as desired, from a single sensor all the way up to multiple sensors, guages, motors, touch screens, and more. Devices can be used on their own, or connect to a central API, from which a web app can be utilized to easily control and monitor your operation.

All devices should follow the standard FarmForge Device Guidelines, and a list of currently available devices can be found in the FarmForge.Devices folder.

## [API](https://github.com/StrykerDG/StrykerDG.FarmForge/tree/master/StrykerDG.FarmForge.Api)
The FarmForge API acts as the central hub of your local FarmForge installation. All devices can / will connect to the API and send their telemetry for storage in a database. Utilizing the API also enables use of a web app to view various report data, device controls, and receive text notifications.

If desired, it can be conected to an external facing API in a cloud provider so your FarmForge network can be accessed anywhere you have an internet connection.

## [Database](https://github.com/StrykerDG/StrykerDG.FarmForge/tree/master/StykerDG.FarmForge.DataModel)
The Database is where all historical telemetry from your Devices is saved. A record of each device is saved here as well.

## IoT Hub
The IoT hub is what allows your local FarmForge network to be accessed from the outside world. The local API connects to the Hub as a client while the External API connects as a server. This allows communication from anywhere without having to open your network.

## External API
The external API is just an externally facing gateway that calls methods on your local API through the user of an IoT Hub. When outside of your local network, the mobile app utilizes this external API.

## Web App
The web app is accessible through both your local and external networks when utilizing the associated API. The web app will allow easy access of your devices and report information.

## Mobile App
The mobile app provides the same functionality as the web app, but will also receive push notifications (as opposed to text messages) if desired.