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
            Receive<AskToUpdateLocation>(HandleUpdateLocation);
            Receive<AskToDeleteLocation>(HandleDeleteLocation);
        }

        // Message Methods
        public void HandleAskForLocations(AskForLocations message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.Locations
                    .AsNoTracking()
                    .Where(l => l.IsDeleted == false)
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
                    var result = new Location();
                    var now = DateTime.Now;

                    var duplicateLocation = context.Locations
                        .Where(l => l.Name == message.Name)
                        .FirstOrDefault();

                    // Trying to add a Location that already exists
                    if (duplicateLocation != null && duplicateLocation.IsDeleted == false)
                        throw new Exception("Location names must be unique");

                    // Adding a Location that was previously deleted
                    else if (duplicateLocation != null && duplicateLocation.IsDeleted == true)
                    {
                        duplicateLocation.IsDeleted = false;
                        duplicateLocation.ParentLocationId = null;
                        duplicateLocation.Modified = now;
                        result = duplicateLocation;
                    }

                    // Adding a location that is new
                    else
                    {
                        var newLocation = new Location
                        {
                            ParentLocationId = message.ParentId,
                            Name = message.Name,
                            Label = message.Label
                        };

                        context.Add(newLocation);
                        result = newLocation;
                    }

                    context.SaveChanges();
                    Sender.Tell(result);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleUpdateLocation(AskToUpdateLocation message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var now = DateTime.Now;

                    var dbLocation = context.Locations
                        .Where(l => 
                            l.LocationId == message.Location.LocationId &&
                            l.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (dbLocation == null)
                        throw new Exception("Location not found");

                    var updatedFields = message.Fields.Split(",");

                    foreach(var field in updatedFields)
                    {
                        var providedValue = message
                            .Location
                            .GetType()
                            .GetProperty(field)
                            .GetValue(message.Location, null);

                        dbLocation
                            .GetType()
                            .GetProperty(field)
                            .SetValue(dbLocation, providedValue);
                    }

                    context.SaveChanges();
                    Sender.Tell(dbLocation);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleDeleteLocation(AskToDeleteLocation message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var now = DateTime.Now;

                    var existingLocation = context.Locations
                        .Where(l =>
                            l.LocationId == message.LocationId &&
                            l.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingLocation == null)
                        throw new Exception("Location not found");

                    existingLocation.IsDeleted = true;

                    var childLocations = context.Locations
                        .Where(l => l.ParentLocationId == message.LocationId)
                        .ToList();

                    foreach(var location in childLocations)
                        location.ParentLocationId = null;

                    context.SaveChanges();
                    Sender.Tell(true);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }
    }
}
