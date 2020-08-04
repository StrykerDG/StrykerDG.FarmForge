#include <Arduino.h>

struct InterfaceType {
    String name;
    String label;
    String modelNumber;
};

struct Interface {
    String name;
    String serialNumber;
    InterfaceType interfaceType;
};

class BasicMoistureSensor_V1 {
    public:
        BasicMoistureSensor_V1();

    private:
        Interface interfaces[1];
};