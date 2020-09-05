#include "BaseDevice.h"

BaseDevice::BaseDevice() {
    // LED
    interfaces[0] = {
      LED_INTERFACE,
      "0001",
    };
    // DHT 11
    interfaces[1] = {
      DHT_INTERFACE,
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

String BaseDevice::HandleMessage(char* message, DHT& dht) {
  Serial.printf("Message: %s", message);
  Serial.println();

  StaticJsonDocument<200> doc;
  DeserializationError error = deserializeJson(doc, message);
  if (error) {
    Serial.print(F("deserializeJson() failed: "));
    Serial.println(error.c_str());
    return "";
  }

  const char* type = doc["type"];
  const char* interface = doc["interface"];

  if(strcmp(type, "request") == 0 && strcmp(interface, DHT_INTERFACE) == 0) {
    float readings[2];
    BaseDevice::QueryDHT11(dht, readings);

    String serializedResults = BaseDevice::SerializeDHT(readings[0], readings[1]);
    return serializedResults;
  }
  if(strcmp(type, "action") == 0 && strcmp(interface, LED_INTERFACE) == 0) {
    int ledValue;
    BaseDevice::ToggleLed(ledValue);

    String serializedResults = BaseDevice::SerializeLED(ledValue);
    return serializedResults;
  }
    
}

void BaseDevice:: QueryDHT11(DHT& dht, float* data) {
  float tempF = dht.readTemperature(true);
  float hum = dht.readHumidity();

  if(isnan(tempF) || isnan(hum)) {
    data[0] = 0;
    data[1] = 0;
  }
  else {
    data[0] = tempF;
    data[1] = hum;
  }
}

void BaseDevice::QueryLED(int& value) {
  value = digitalRead(LED);
}

void BaseDevice::ToggleLed(int& ledValue) {
  ledValue = !digitalRead(LED);
  digitalWrite(LED, ledValue);
}

String BaseDevice::SerializeDHT(float temp, float humidity) {
  const int capacity = JSON_OBJECT_SIZE(3) + JSON_ARRAY_SIZE(2);
  StaticJsonDocument<capacity> doc;

  doc["type"] = "response";
  doc["interface"] = "temp_01";
  JsonArray data = doc.createNestedArray("data");
  data.add(temp);
  data.add(humidity);

  String dhtString;
  serializeJson(doc, dhtString);

  return dhtString;
}

String BaseDevice::SerializeLED(int value) {
  const int capacity = JSON_OBJECT_SIZE(3) + JSON_ARRAY_SIZE(1);
  StaticJsonDocument<capacity> doc;

  doc["type"] = "response";
  doc["interface"] = "led_01";
  JsonArray data = doc.createNestedArray("data");
  data.add(value);

  String ledString;
  serializeJson(doc, ledString);

  return ledString;
}