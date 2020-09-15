using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Crops.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.Actors.Crops
{
    public class CropActor : FarmForgeActor
    {
        public CropActor(IServiceScopeFactory factory) : base(factory)
        {

            Receive<AskForCrops>(HandleAskForCrops);
            Receive<AskToCreateCrop>(HandleCropCreation);
        }

        // Message Methods
        public void HandleAskForCrops(AskForCrops message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.Crops
                    .Where(c =>
                        c.PlantedAt >= message.Begin &&
                        c.PlantedAt <= message.End
                    )
                    .ToList();

                Sender.Tell(results);
            });
        }

        public void HandleCropCreation(AskToCreateCrop message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    // Make sure the CropType, Variety, and Location actually exist
                    var cropType = context.CropTypes
                        .Include("Varieties")
                        .AsNoTracking()
                        .Where(ct => ct.CropTypeId == message.CropTypeId)
                        .FirstOrDefault();

                    var cropVariety = cropType != null
                        ? cropType.Varieties
                            .Where(v => v.CropVarietyId == message.VarietyId)
                            .FirstOrDefault()
                        : null;

                    var location = context.Locations
                        .AsNoTracking()
                        .Where(l => l.LocationId == message.LocationId)
                        .FirstOrDefault();

                    if (cropType == null || cropVariety == null || location == null || message.Date == null)
                        throw new Exception("Invalid data provided");

                    var plantedStatus = context.Statuses
                        .AsNoTracking()
                        .Where(s =>
                            s.Name == "planted" &&
                            s.EntityType == "Crop.Status"
                        )
                        .FirstOrDefault();

                    // Create the crop
                    var newCrop = new Crop
                    {
                        CropTypeId = cropType.CropTypeId,
                        CropType = cropType,
                        CropVarietyId = cropVariety.CropVarietyId,
                        CropVariety = cropVariety,
                        LocationId = location.LocationId,
                        Location = location,
                        StatusId = plantedStatus.StatusId,
                        Status = plantedStatus,
                        PlantedAt = message.Date,
                        Quantity = message.Quantity,
                        Logs = new List<CropLog>()
                    };

                    context.Add(newCrop);
                    context.SaveChanges();
                    Sender.Tell(newCrop);
                }
                catch (Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        // Helper Methods
    }
}
