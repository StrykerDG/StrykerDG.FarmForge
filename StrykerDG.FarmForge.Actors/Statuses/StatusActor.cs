using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Statuses.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Statuses
{
    public class StatusActor : FarmForgeActor
    {
        public StatusActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForStatusesByEntity>(HandleAskForStatusesByEntity);
        }

        // Message Methods
        public void HandleAskForStatusesByEntity(AskForStatusesByEntity message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.Statuses
                    .Where(s =>
                        s.EntityType == message.EntityType &&
                        s.IsDeleted == false
                    )
                    .ToList();

                Sender.Tell(results);
            });
        }
    }
}
