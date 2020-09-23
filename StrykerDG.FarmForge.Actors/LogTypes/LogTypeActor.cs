using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.LogTypes.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.LogTypes
{
    public class LogTypeActor : FarmForgeActor
    {
        public LogTypeActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForLogsByEntity>(HandleAskForLogsByEntity);
        }

        // Message Methods
        public void HandleAskForLogsByEntity(AskForLogsByEntity message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.LogTypes
                    .Where(lt => 
                        lt.EntityType == message.EntityType && 
                        lt.IsDeleted == false
                    )
                    .ToList();

                Sender.Tell(results);
            });
        }
    }
}
