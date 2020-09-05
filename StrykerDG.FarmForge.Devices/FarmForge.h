#include <Arduino.h>

/*
    Purpose: Provides a common structure to define the interfaces of any 
        FarmForge device
    Properties:
        name: The name of the interface (defined in device header file)
        sn: The serial number of the interface (defined in the device header file)
*/
struct Interface {
    String name;
    String sn;
};

/*
    Purpose: Provides a common structure for websocket messages traveling between 
        the FarmForge device and the web interface
    Properties:
        type: String - The type of message. Can have a value of "request", "action"
            "config", or "response". "request" means we're requesting information 
            of some sort while "action" means we're attempting to interact with 
            one of the devices interfaces in some way. "response" is a message
            returning from the device due to receiving a "request" or "action" 
            message, and "config" is a response sent from the device upon 
            successful connection with a list of interface names
        interface: String - Specifies the name of the interface we want to 
            interact with
        data: Array<String> - A list of values that will be dictated by what 
            interface you're working with, and what action you're trying to 
            perform
*/
struct WebsocketMessage {
    String type;
    String interface;
    String data[];
};