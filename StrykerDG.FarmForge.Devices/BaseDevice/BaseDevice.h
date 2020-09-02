#include <Arduino.h>
#include <ArduinoJson.h>
#include "FarmForge.h"

#define DNS_NAME "basic_device"
#define LED 2

class BaseDevice {
    public:
        // Constructor
        BaseDevice();

        // Interfaces
        unsigned long long GetNumberOfInterfaces();
        String GetInterfaceName(int index);
        int GetInterfacePin(int index);

        // Message Handling
        void HandleMessage(char* message);

        void ToggleLed();
        double* QueryDHT11();
        
    private:
        Interface interfaces[2];
};
