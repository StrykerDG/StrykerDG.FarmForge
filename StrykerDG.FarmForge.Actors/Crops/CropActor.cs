using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Crops.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Extensions;
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
            Receive<AskToCreateLog>(HandleLogCreation);
        }

        // Message Methods
        public void HandleAskForCrops(AskForCrops message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.Crops
                    .WithIncludes(message.Includes)
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
                        CropVarietyId = cropVariety.CropVarietyId,
                        LocationId = location.LocationId,
                        StatusId = plantedStatus.StatusId,
                        PlantedAt = message.Date,
                        Quantity = message.Quantity,
                    };

                    context.Add(newCrop);
                    context.SaveChanges();

                    // Add included values to the result
                    newCrop.CropType = cropType;
                    newCrop.CropVariety = cropVariety;
                    newCrop.Location = location;
                    newCrop.Status = plantedStatus;
                    newCrop.Logs = new List<CropLog>();

                    Sender.Tell(newCrop);
                }
                catch (Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleLogCreation(AskToCreateLog message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var now = DateTime.Now;
                    
                    if (message.CropId == 0 | message.LogTypeId == 0 | message.CropStatusId == 0)
                        throw new Exception("Invalid CropId, CropTypeId, or StatusId");

                    var dbCrop = context.Crops
                        .Where(c => c.CropId == message.CropId)
                        .FirstOrDefault();

                    if (dbCrop == null)
                        throw new Exception("Invalid CropId");

                    var newLog = new CropLog
                    {
                        CropId = dbCrop.CropId,
                        LogTypeId = message.LogTypeId,
                        Notes = message.Notes,
                        Created = now,
                        Modified = now,
                        IsDeleted = false
                    };

                    context.Add(newLog);

                    if(dbCrop.StatusId != message.CropStatusId)
                    {
                        dbCrop.StatusId = message.CropStatusId;
                        dbCrop.Modified = now;
                    }

                    context.SaveChanges();

                    var logType = context.LogTypes
                        .Where(lt => lt.LogTypeId == newLog.LogTypeId)
                        .FirstOrDefault();
                    newLog.LogType = logType;

                    Sender.Tell(newLog);
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
