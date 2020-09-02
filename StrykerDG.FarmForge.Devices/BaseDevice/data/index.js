var connection;
var securityToken;
var ledInterface;
var tempInterface;

function websocketConnect() {
    let address = `ws://${location.hostname}:81`;
    connection = new WebSocket(address);
    connection.onopen = () => { console.log("connected") };
    connection.onerror = (error) => console.log('Websocket Error:', error);
    connection.onmessage = handleMessage;
    connection.onclose = () => console.log('Websocket connection closed');
}

function handleMessage(event) {
    console.log('Server:', event.data);    
    try {
        let dataObject = JSON.parse(event.data.toString());
        console.log("Testing?", dataObject);
        if(dataObject.type === "config")
            handleConfigMessage(dataObject.token, dataObject.data);
        if(dataObject.type === "request")
            handleRequestMessage(dataObject.data);
        if(dataObject.type === "action")
            handleActionMessage(dataObject.data);
    }
    catch(e) {
        console.log("Error:", e.toString());
    }
}

function handleConfigMessage(token, data) {
    securityToken = token;

    /*
        Config message data = [
            led interface, 
            led value,
            dht interface,
            temp,
            humidity
        ]
    */
    if(Array.isArray(data) && data.length >= 2) {
        ledInterface = data[0];
        tempInterface = data[1];
    }
}

function handleActionMessage(data) {

}

function handleRequestMessage(data) {

}

function getTempAndHumidity() {
    console.log("getting temperature...");

    console.log("Temp interface?", tempInterface);
    console.log("LED?", ledInterface);
    console.log("token?", securityToken);

    connection.send("ask:temp");
}

function toggleLed() {
    let messageObject = {
        type: "action",
        interface: ledInterface,
    };

    let message = JSON.stringify(messageObject);

    connection.send(message);
}