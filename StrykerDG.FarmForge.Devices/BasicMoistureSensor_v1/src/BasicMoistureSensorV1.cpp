#include "BasicMoistureSensorV1.h"

BasicMoistureSensor_V1::BasicMoistureSensor_V1() {
    interfaces[0] = { 
        "Moisture Sensor", 
        "serialNumber", 
        { 
            "name",
            "label",
            "modelNumber"
        }
    };
}