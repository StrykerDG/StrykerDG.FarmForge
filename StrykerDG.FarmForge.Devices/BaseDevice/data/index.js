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
    try {
        let dataObject = JSON.parse(event.data.toString());
        if(dataObject.type === "config")
            handleConfigMessage(dataObject.token, dataObject.data);
        if(dataObject.type === "response")
            handleResponseMessage(dataObject.interface, dataObject.data);
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
    if(Array.isArray(data) && data.length === 5) {
        ledInterface = data[0];
        tempInterface = data[2];

        setLed(data[1]);
        setTemp(data[3]);
        setHumidity(data[4]);
    }
}

function handleResponseMessage(interface, data) {
    if(interface === ledInterface)
        setLed(data[0]);
    if(interface === tempInterface) {
        setTemp(data[0]);
        setHumidity(data[1]);
    }
}

function getTempAndHumidity() {
    let messageObject = {
        type: "request",
        interface: tempInterface
    }

    let message = JSON.stringify(messageObject);

    connection.send(message);
}

function toggleLed() {
    let messageObject = {
        type: "action",
        interface: ledInterface,
    };

    let message = JSON.stringify(messageObject);

    connection.send(message);
}

function setLed(value) {
    document.getElementById("led_value").innerHTML = value ? "On" : "Off";
}

function setTemp(value) {
    document.getElementById("temp_value").innerHTML = value + '&#176;F';
}

function setHumidity(value) {
    document.getElementById("humidity_value").innerText = `${value}%`;
}
    