using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Crops;
using StrykerDG.FarmForge.Actors.Locations.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Locations
{
    public class LocationActor : FarmForgeActor
    {
        public LocationActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForLocations>(HandleAskForLocations);
        }

        // Message Methods
        public void HandleAskForLocations(AskForLocations message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.Locations
                    .AsNoTracking()
                    .ToList();

                Sender.Tell(results);
            });
        }
    }
}
