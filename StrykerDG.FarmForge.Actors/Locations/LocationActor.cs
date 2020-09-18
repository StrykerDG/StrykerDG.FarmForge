using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Crops;
using StrykerDG.FarmForge.Actors.Locations.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Models;
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
            Receive<AskToCreateLocation>(HandleAskToCreateLocation);
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

        public void HandleAskToCreateLocation(AskToCreateLocation message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var duplicateLocation = context.Locations
                        .Where(l => l.Name == message.Name)
                        .FirstOrDefault();

                    if (duplicateLocation != null)
                        throw new Exception("Location names must be unique");

                    var now = DateTime.Now;
                    var newLocation = new Location
                    {
                        ParentLocationId = message.ParentId,
                        Name = message.Name,
                        Label = message.Label,
                        Created = now,
                        Modified = now,
                        IsDeleted = false
                    };

                    context.Add(newLocation);
                    context.SaveChanges();
                    Sender.Tell(newLocation);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }
    }
}
