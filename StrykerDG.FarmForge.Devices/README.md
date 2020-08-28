# Devices
Devices are the basis of the FarmForge ecosystem. Each device can be utilized by itself, or connect to a larger FarmForge network.

Code for all devices is open source, and each device should follow a standard set of guidelines, as well as having a common set of functionalities.

## Functionalities
Every FarmForge device will have the following capabilities at a minimum, but could have more. See each device for specifics

1. Be able to act as both a wifi station and access point
2. Store an index.html on the filesystem to allow interaction with the device
3. Supply a friendly name via mDNS
4. Support over the air updates
5. Include FarmForge.h to define it's interfaces and interact with the FarmForge API
6. Include endpoints for retrieving any sensor values and manipulating any inputs

## Guidelines
The following guidelines should be followed when designing and submitting any FarmForge device

1. Every device should include a detailed README explaining how to build and utilize it
2. Every device should include an electrical or circuit schematic
3. ...