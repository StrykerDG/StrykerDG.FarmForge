# DataModel
FarmForge.DataModel contains the definitions for tables that are used within the FarmForge project. 

FarmForge uses the SQLite database due to the fact that it is light weight and can be used on Windows IoT Core. The goal is to use something that can run locally on a small, cheap piece of hardware.

# Models
The following tables make up the FarmForge Data Model

- **FarmForgeBaseModel**: A base model that all other models inherit

| Column        | Type          | Description  |
|:-------------:|:-------------:|:------------:|
| Created | DateTime | When the object was created |
| Modified | DateTime | When the object was last modified |
| IsDeleted | Bool | If the object should be treated as if it is deleted |

- **Device**: Represents an IoT device that is connected to FarmForge

| Column        | Type          | Description  |
|:-------------:|:-------------:|:------------:|
| DeviceId | Int | Primary Key |
| Name | String | A friendly name of the connected device |
| IpAddress | String | The IP Address of the connected device |
| SerialNumber | String | A unique identifier that ties the FarmForge device to the physical device |
| Status | Int | The current status of the device (connected, disconnected, etc) |

- **Interface**: Represents an interface on a device, such as a sensor, screen, motor, etc

| Column        | Type          | Description  |
|:-------------:|:-------------:|:------------:|
| InterfaceId | Int | Primary Key |
| DeviceId | Int | The Id of the device that this interface belongs to |
| Name | String | A name corresponding to the interface on the device, such as "clock 1" |
| SerialNumber | String | A Unique Identifier that ties the FarmForge interface to the physical device |
| InterfaceTypeId | Int | Ties the interface to a specific interface type |

- **InterfaceType**: Defines different types of interfaces, such as sensors, motors, etc

| Column        | Type          | Description  |
|:-------------:|:-------------:|:------------:|
| InterfaceTypeId | Int | Primary Key |
| Name | String | The name of the Interface type, such as DS1307RTC |
| Label | String | The string representing the interface type that is shown to the user |
| ModelNumber | String | The model number of the particular Interface |
| ParentInterfaceId | Int | An Id that ties to another InterfaceType that parents this, such as one with the name "Real Time Clock" |

- **Telemetry**: Describes the telemetry sent from an IoT device to FarmForge

| Column        | Type          | Description  |
|:-------------:|:-------------:|:------------:|
| TelemetryId | Int | Primary Key |
| InterfaceId | Int | The Interface that the telemetry belongs to |
| Value | Double | The number value of the telemetry |
| StringValue | String | The string value of the telemetry |
| BoolValue | Bool | The bool value of the telemetry |

# Example Object
An example of an object would be a FarmForge device that has multiple interfaces, each of which send telemetry back to the main system.

```
Device: {
    DeviceId: 1,
    Name: DemoDevice,
    IpAddress: "192.168.1.100",
    SerialNumber: "1234567890",
    Interfaces: [
        {
            InterfaceId: 1,
            DeviceId: 1,
            Name: Temp_1,
            SerialNumber: 0001,
            InterfaceTypeId: 1,
            InterfaceType: {
                InterfaceTypeId: 1,
                Name: DHT22,
                Label: "DHT22 Temperature Sensor",
                ModelNumber: DHT22A3,
                ParentInterfaceTypeId: 2
            },
            Telemetry: [
                {
                    TelemetryId: 1,
                    InterfaceId: 1,
                    TimeStamp: "2020-07-10 10:15:00"
                    Value: 88.5,
                    StringValue: null,
                    BoolValue: null
                },
                {
                    TelemetryId: 2,
                    InterfaceId: 1,
                    TimeStamp: "2020-07-10 10:16:00",
                    Value: 88.9,
                    StringValue: null,
                    BoolValue: null
                }
            ]
        },
        {
            InterfaceId: 2,
            DeviceId: 1,
            Name: Switch_1,
            SerialNumber: S001,
            InterfaceTypeId: 3,
            InterfaceType: {
                InterfaceTypeId: 3,
                Name: TOGGLE,
                Label: Toggle Switch,
                ModelNumber: TS_01,
                ParentInterfaceTypeId: 4
            },
            Telemetry: [
                {
                    TelemetryId: 3,
                    InterfaceId: 2,
                    TimeStamp: "2020-07-10 05:32:12",
                    Value: null,
                    StringValue: null,
                    BoolValue: true
                },
                {
                    TelemetryId: 4,
                    InterfaceId: 2,
                    TimeStamp: "2020-07-10 09:22:15",
                    Value: null,
                    StringValue: null,
                    BoolValue: false
                }
            ]
        }
    ]
}
```