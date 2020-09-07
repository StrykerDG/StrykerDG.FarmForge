using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.WebSockets.Messages
{
    public enum WebSocketRequest
    {
        request,
        action,
        config,
        response
    }

    public class AskToHandleWebSocketRequest
    {
        public WebSocketRequest RequestType { get; set; }
        public string Interface { get; set; }
        public dynamic Data { get; private set; }

        public AskToHandleWebSocketRequest(
            WebSocketRequest requestType,
            string interfaceName,
            dynamic data
        ) 
        {
            RequestType = requestType;
            Interface = interfaceName;
            Data = data;
        }
    }
}
