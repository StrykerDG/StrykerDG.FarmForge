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