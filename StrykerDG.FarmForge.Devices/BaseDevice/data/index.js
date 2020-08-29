var connection;
var ledInterface;
var tempInterface;

function websocketConnect() {
    let address = `ws://${location.hostname}:81`;
    connection = new WebSocket(address);
    connection.onopen = () => connection.send('Connect ' + new Date());
    connection.onerror = (error) => console.log('Websocket Error:', error);
    connection.onmessage = handleMessage;
    connection.onclose = () => console.log('Websocket connection closed');
}

function handleMessage(event) {
    console.log('Server:', event.data);
}

function getTempAndHumidity() {
    console.log("getting temperature...");
    connection.send("ask:temp");
}

function toggleLed() {
    console.log("toggling led...");
    connection.send("ask:toggle:led");
}