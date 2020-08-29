#include <Arduino.h>

struct Interface {
    String name;
    String sn;
};

struct WebsocketMessage {
    String type;
    String interface;
    String data[];
};