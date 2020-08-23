# FarmForge
FarmForge is an open source project that allows farmers, gardeners, and hobbyists to enhance their operations by utilizing IoT devices with minimal effort.

FarmForge is designed to be low-cost and configurable in order to meet each individual's specific needs. The Priority and emphasis is on working via the local network, but it can be reached everywhere through the use of a cloud provider such as Azure.

In addition to having open access to the source code, there are also opportunities to purchase pre-built and pre-configured devices to speed up deployment and utilization.

# Components
There are multiple components that can be utilized within FarmForge, depending on how you want to utilize the system and what your end goals are.

## Devices
Devices are the actual IoT components that are utilized within your farm, garden, or greenhouse. They can be as simple as complex as desired, from a single sensor all the way up to multiple sensors, guages, motors, touch screens, and more. Devices can be used on their own, or connect to a central API, from which a web app can be utilized to easily control and monitor your operation.

All devices should follow the standard FarmForge Device Guidelines, and a list of currently available devices can be found in the FarmForge.Devices folder.

## API 
The FarmForge API acts as the central hub of your local FarmForge installation. All devices can / will connect to the API and send their telemetry for storage in a database. Utilizing the API also enables use of a web app to view various report data, device controls, and receive text notifications.

If desired, it can be conected to an external facing API in a cloud provider so your FarmForge network can be accessed anywhere you have an internet connection.

## Database
The Database is where all historical telemetry from your Devices is saved. A record of each device is saved here as well.

## IoT Hub
The IoT hub is what allows your local FarmForge network to be accessed from the outside world. The local API connects to the Hub as a client while the External API connects as a server. This allows communication from anywhere without having to open your network.

## External API
The external API is just an externally facing gateway that calls methods on your local API through the user of an IoT Hub. When outside of your local network, the mobile app utilizes this external API.

## Web App
The web app is accessible through both your local and external networks when utilizing the associated API. The web app will allow easy access of your devices and report information.

## Mobile App
The mobile app provides the same functionality as the web app, but will also receive push notifications (as opposed to text messages) if desired.