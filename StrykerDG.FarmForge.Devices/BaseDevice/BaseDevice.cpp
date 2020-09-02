#include "BaseDevice.h"

BaseDevice::BaseDevice() {
    // LED
    interfaces[0] = {
      "led_01",
      "0001",
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

int BaseDevice::GetInterfacePin(int index) {
  if(index < GetNumberOfInterfaces())
    return interfaces[index].pin;
  else 
    return -1;
}

void BaseDevice::HandleMessage(char* message) {
  Serial.printf("Message: %s", message);
  Serial.println();

  StaticJsonDocument<200> doc;
  DeserializationError error = deserializeJson(doc, message);
  if (error) {
    Serial.print(F("deserializeJson() failed: "));
    Serial.println(error.c_str());
    return;
  }

  const char* type = doc["type"];
  const char* interface = doc["interface"];

  if(strcmp(type, "request") == 0 && strcmp(interface, "temp_01") == 0)
  {

  }
  if(strcmp(type, "action") == 0 && strcmp(interface, "led_01") == 0) {
    BaseDevice::ToggleLed();
    // TODO: Return string
  }
    
}

double* BaseDevice::QueryDHT11() {
  double test[2] = {75.3, 11.2};
  return test;
}

void ToggleLed() {
  digitalWrite(LED, !digitalRead(LED));
}