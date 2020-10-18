using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Crops;
using StrykerDG.FarmForge.Actors.Units.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units
{
    public class UnitActor : FarmForgeActor
    {
        public UnitActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForUnitTypes>(HandleAskForUnitTypes);
        }

        // Message Methods
        private void HandleAskForUnitTypes(AskForUnitTypes message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.UnitTypes
                    .Where(u => u.IsDeleted == false)
                    .ToList();

                Sender.Tell(results);
            });
        }

        // Helpers
    }
}
