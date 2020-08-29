#include "BaseDevice.h"

BaseDevice::BaseDevice() {
    // LED
    interfaces[0] = {
      "led_01",
      "0001"
    };
    // DHT 11
    interfaces[1] = {
      "temp_01",
      "0001"
    };
}

unsigned long long BaseDevice::GetNumberOfInterfaces() {
  return sizeof(interfaces) / sizeof(*interfaces);
}

String BaseDevice::GetInterfaceName(int index) {
  if(index < GetNumberOfInterfaces()) {
    return interfaces[index].name;
  }
  else return "";
}