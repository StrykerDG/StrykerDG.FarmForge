#include <Arduino.h>
#include "ESP8266WiFi.h"
#include "ESP8266WebServer.h"

// Private defines that stay out of version control
#include "private.h"
// BasicMoistureSensor class, as required by StrykerDG.FarmForge.DataModel
#include "BasicMoistureSensorV1.h"

// Webserver that listens on port 80
ESP8266WebServer server(80);

String ipAddress;
BasicMoistureSensor_V1 device;

// Web server handlers
void handleRootRequest();
void handleConfigRequest();
void handleNotFound();

void setup() {
  Serial.begin(9800);

  // Connect to wireless
  WiFi.disconnect();
  WiFi.begin(SSID, PASSWORD);

  Serial.println("Connecting...");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  ipAddress = WiFi.localIP().toString();
  Serial.println();
  Serial.print("Connected! IP Address is ");
  Serial.println(ipAddress);

  // Start the webserver
  server.on("/", HTTP_GET, handleRootRequest);
  server.on("/config", HTTP_POST, handleConfigRequest);
  server.onNotFound(handleNotFound);
  server.begin();
  Serial.println("WebServer Started");

  // TODO: Enable web server requests
  // TODO: Post registration to FarmForge
}

void loop() {
  // Listen for requests from clients
  server.handleClient();

  // TODO: Check the moisture every x seconds
  // TODO: If moisture reaches x, turn on motor to water plant
}

void handleRootRequest() {
  server.send(200, "text/plain", "Hello! See a list of requests you can make");
}

void handleConfigRequest() {
  if(!server.hasArg("token") || server.arg("token") != TOKEN)
    server.send(401, "application/json", "{\"error\": \"401: Unauthorized\"}");
  else
    server.send(200, "application/json", "{\"property\": \"value\"}");
}

void handleNotFound() {
  server.send(404, "text/plain", "404: Not Found");
}