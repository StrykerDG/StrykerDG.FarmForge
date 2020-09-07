using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.WebSockets.Messages;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.WebSockets
{
    public class WebSocketActor : FarmForgeActor
    {
        public WebSocketActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskToHandleWebSocketRequest>(HandleWebSocketRequest);
        }

        // Message Methods
        public void HandleWebSocketRequest(AskToHandleWebSocketRequest message)
        {
            Sender.Tell(true);
        }
    }
}
