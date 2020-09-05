#include <Arduino.h>
#include <ArduinoJson.h>
#include "FarmForge.h"
#include "DHT.h"

#define DNS_NAME "basic_device"
#define LED 2
#define DHTPIN 4
#define DHTTYPE DHT11
#define LED_INTERFACE "led_01"
#define DHT_INTERFACE "temp_01"

class BaseDevice {
    public:
        // Constructor
        BaseDevice();

        // Interfaces
        unsigned long long GetNumberOfInterfaces();
        String GetInterfaceName(int index);

        // Message Handling
        String HandleMessage(char* message, DHT& dht);

        void ToggleLed(int& value);
        void QueryLED(int& value);
        void QueryDHT11(DHT& dht, float* data);
        String SerializeDHT(float temp, float humidity);
        String SerializeLED(int value);
        
    private:
        Interface interfaces[2];
};
