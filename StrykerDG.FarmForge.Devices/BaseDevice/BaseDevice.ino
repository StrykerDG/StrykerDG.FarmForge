#include <Arduino.h>
#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <ESP8266WebServer.h>
#include <ArduinoOTA.h>
#include <WebSocketsServer.h>

// Definitions that should be kept out of version control
#include "private.h"

// Definition of the FarmForge device
#include "BaseDevice.h"

IPAddress localIp(192,168,100,2);
IPAddress gateway(192,168,100,1);
IPAddress subnet(255,255,255,0);

ESP8266WebServer server(80);
WebSocketsServer webSocket(81);

DHT dht(DHTPIN, DHTTYPE);
BaseDevice device;

unsigned long previousTime = millis();
const unsigned long interval = 500;

void InitSpiffs();
void InitWireless();
void InitDns();
void InitOta();
void InitWebServer();
void InitWebSockets();

void OtaStart();
void OtaEnd();
void OtaProgress(unsigned int progress, unsigned int total);
void OtaError(ota_error_t error);
void HandleWebNotFound();
void HandleWebSocketEvent(uint8_t num, WStype_t type, uint8_t* payload, size_t length);

bool HandleFileRead(String path);
String GetContentType(String fileName);

// Runs once on startup
void setup() {
  Serial.begin(115200);
  Serial.println("\n");

  InitSpiffs();
  InitWireless();
  InitDns();
  InitOta();
  InitWebServer();
  InitWebSockets();

  pinMode(LED, OUTPUT);
  digitalWrite(LED, LOW);
  dht.begin();
}

// Runtime loop
void loop() {
  server.handleClient();
  ArduinoOTA.handle();
  webSocket.loop();
}


// Initialization Functions
void InitSpiffs() {
    SPIFFS.begin();
    Serial.println("SPIFFS Ready");
}

void InitWireless() {
  WiFi.softAPConfig(localIp, gateway, subnet);
  WiFi.softAP(AP_SSID, AP_PASSWORD);
  
  WiFi.begin(SSID, PASSWORD);

  Serial.print("Connecting to ");
  Serial.println(SSID);

  while(WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }

  Serial.println('\n');
  Serial.println("Connection Established!");
  Serial.print("Ip Address: \t");
  Serial.println(WiFi.localIP());
}

void InitDns() {
  if(!MDNS.begin(DNS_NAME)) 
    Serial.println("Error setting up mDNS responder@");
  else 
    Serial.printf("mDNS responder started at %s.local", DNS_NAME);
}

void InitOta() {
  ArduinoOTA.setHostname(OTA_HOSTNAME);
  ArduinoOTA.setPassword(OTA_PASSWORD);

  ArduinoOTA.onStart(OtaStart);
  ArduinoOTA.onEnd(OtaEnd);
  ArduinoOTA.onProgress(OtaProgress);
  ArduinoOTA.onError(OtaError);

  ArduinoOTA.begin();
  Serial.println("OTA Ready");
}

void InitWebServer() {
  server.onNotFound(HandleWebNotFound);
  server.begin();
  Serial.println("HTTP Server Started");
}

void InitWebSockets() {
  webSocket.begin();
  webSocket.onEvent(HandleWebSocketEvent);
  Serial.println("Websocket Server Started");
}

// Handlers
void OtaStart() {
  Serial.println("Beginning OTA update...");
}

void OtaEnd() {
  Serial.println("Completed OTA update!");
}

void OtaProgress(unsigned int progress, unsigned int total) {
  Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
}

void OtaError(ota_error_t error) {
  Serial.printf("Error[%u]: ", error);
  if(error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
  if(error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
  if(error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
  if(error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
  if(error == OTA_END_ERROR) Serial.println("End Failed");
}

void HandleWebNotFound() {
  if(!HandleFileRead(server.uri()))
    server.send(404, "text/plain", "404: Not Found");
}

void HandleWebSocketEvent(uint8_t clientId, WStype_t type, uint8_t* payload, size_t length) {
  switch(type) {
    case WStype_DISCONNECTED: {
      Serial.printf("[%u] CDisconnected!\n", clientId);
      break;
    }
      
    case WStype_CONNECTED: {
      IPAddress ip = webSocket.remoteIP(clientId);
      // Object will be {type, token, [led, ledValue, dht11, temp, humidity]}
      const int capacity = JSON_ARRAY_SIZE(5) + JSON_OBJECT_SIZE(3);

      float dhtValues[2];
      int ledValue;
      device.QueryDHT11(dht, dhtValues);
      device.QueryLED(ledValue);

      StaticJsonDocument<capacity> doc;
      doc["type"] = "config";
      doc["token"] = TOKEN;
      JsonArray data = doc.createNestedArray("data");

      data.add(LED_INTERFACE);
      data.add(ledValue);
      data.add(DHT_INTERFACE);
      data.add(dhtValues[0]);
      data.add(dhtValues[1]);

      String text;
      serializeJson(doc, text);

      webSocket.sendTXT(clientId, text);
      break;
    }
      
    case WStype_TEXT: {
      char* stringData = (char*)payload;
      String response = device.HandleMessage(stringData, dht);
      webSocket.sendTXT(clientId, response);
    }
  }
}

// Helper Functions
bool HandleFileRead(String path) {
  Serial.printf("Attempting to access %s\n", &path);
  if (path.endsWith("/")) 
    path += "index.html";

  String contentType = GetContentType(path);

  if (SPIFFS.exists(path)) {
    File file = SPIFFS.open(path, "r");
    server.streamFile(file, contentType);
    file.close();
    return true;
  }

  return false;
}

String GetContentType(String fileName) {
  String type = "text/plain";
  if(fileName.endsWith(".html")) type = "text/html";
  if(fileName.endsWith(".css")) type =  "text/css";
  if(fileName.endsWith(".js")) type = "application/javascript";
  if(fileName.endsWith(".ico")) type = "image/x-icon";
  if(fileName.endsWith(".gz")) type = "application/x-gzip";
  return type;
}
