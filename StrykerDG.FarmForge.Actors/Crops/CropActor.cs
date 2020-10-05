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
            Receive<AskToUpdateCrop>(HandleCropUpdate);
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
                        c.PlantedAt <= message.End &&
                        c.IsDeleted == false
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

        public void HandleCropUpdate(AskToUpdateCrop message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var now = DateTime.Now;

                    var dbCrop = context.Crops
                        .Where(c =>
                            c.CropId == message.Crop.CropId &&
                            c.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (dbCrop == null)
                        throw new Exception("Crop not found");

                    // If the status changed to germinated or harvested, then 
                    // set the GerminatedAt or HarvestedAt properties, and create an 
                    // associated CropLog
                    var planted = context.Statuses
                        .AsNoTracking()
                        .Where(s =>
                            s.EntityType == "Crop.Status" &&
                            s.Name == "planted"
                        )
                        .FirstOrDefault();

                    var germinated = context.Statuses
                        .AsNoTracking()
                        .Where(s =>
                            s.EntityType == "Crop.Status" &&
                            s.Name == "germinated"
                        )
                        .FirstOrDefault();

                    var harvested = context.Statuses
                        .AsNoTracking()
                        .Where(s =>
                            s.EntityType == "Crop.Status" &&
                            s.Name == "harvested"
                        )
                        .FirstOrDefault();

                    var observationLog = context.LogTypes
                        .AsNoTracking()
                        .Where(lt =>
                            lt.EntityType == "Crop.Log" &&
                            lt.Name == "observation"
                        )
                        .FirstOrDefault();

                    if (
                        dbCrop.StatusId != message.Crop.StatusId && 
                        message.Crop.StatusId == germinated.StatusId
                    )
                    {
                        dbCrop.GerminatedAt = now;
                        context.Add(new CropLog
                        {
                            CropId = dbCrop.CropId,
                            LogTypeId = observationLog.LogTypeId,
                            Notes = "Auto Germination Log generated by changing the status"
                        });
                    }

                    if(
                        dbCrop.StatusId != message.Crop.StatusId &&
                        message.Crop.StatusId == harvested.StatusId
                    )
                    {
                        var harvestLog = context.LogTypes
                            .AsNoTracking()
                            .Where(lt =>
                                lt.EntityType == "Crop.Log" &&
                                lt.Name == "harvest"
                            )
                            .FirstOrDefault();

                        dbCrop.HarvestedAt = now;
                        dbCrop.QuantityHarvested = dbCrop.Quantity;
                        dbCrop.Yield = dbCrop.QuantityHarvested / dbCrop.Quantity * 100;

                        // User may have skiped the germinated status
                        if (dbCrop.GerminatedAt == null)
                        {
                            dbCrop.GerminatedAt = now;
                            context.Add(new CropLog
                            {
                                CropId = dbCrop.CropId,
                                LogTypeId = observationLog.LogTypeId,
                                Notes = "Auto Germination Log generated by changing the status"
                            });
                        }

                        context.Add(new CropLog
                        {
                            CropId = dbCrop.CropId,
                            LogTypeId = harvestLog.LogTypeId,
                            Notes = "Auto Harvest Log generated by changing the status"
                        });
                    }

                    // If the status changed to anything other than germinated, and there is
                    // no germinated at, we need to set that here, since germinated is the fist
                    // status a crop can be, aside from planted
                    if(
                        dbCrop.StatusId != message.Crop.StatusId &&
                        dbCrop.GerminatedAt == null &&
                        message.Crop.StatusId != planted.StatusId
                    )
                    {
                        context.Add(new CropLog
                        {
                            CropId = dbCrop.CropId,
                            LogTypeId = observationLog.LogTypeId,
                            Notes = "AutoLog generated by changing the status"
                        });
                    }

                    // Update the provided values
                    var updateFields = message.Fields.Split(",");

                    foreach(var field in updateFields)
                    {
                        var providedValue = message
                            .Crop
                            .GetType()
                            .GetProperty(field)
                            .GetValue(message.Crop, null);

                        dbCrop
                            .GetType()
                            .GetProperty(field)
                            .SetValue(dbCrop, providedValue);
                    }

                    dbCrop.Modified = now;

                    context.SaveChanges();

                    // Return the full crop object
                    var cropType = context.CropTypes
                        .AsNoTracking()
                        .Where(ct => ct.CropTypeId == dbCrop.CropTypeId)
                        .FirstOrDefault();
                    var cropVariety = context.CropVarieties
                        .AsNoTracking()
                        .Where(cv => cv.CropVarietyId == dbCrop.CropVarietyId)
                        .FirstOrDefault();
                    var location = context.Locations
                        .AsNoTracking()
                        .Where(l => l.LocationId == dbCrop.LocationId)
                        .FirstOrDefault();
                    var status = context.Statuses
                        .AsNoTracking()
                        .Where(s => s.StatusId == dbCrop.StatusId)
                        .FirstOrDefault();
                    var cropLogs = context.CropLogs
                        .AsNoTracking()
                        .Include("LogType")
                        .Where(l => l.CropId == dbCrop.CropId)
                        .ToList();

                    dbCrop.CropType = cropType;
                    dbCrop.CropVariety = cropVariety;
                    dbCrop.Location = location;
                    dbCrop.Status = status;
                    dbCrop.Logs = cropLogs;

                    Sender.Tell(dbCrop);
                }
                catch(Exception ex)
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
                        Notes = message.Notes
                    };

                    context.Add(newLog);

                    if(dbCrop.StatusId != message.CropStatusId)
                        dbCrop.StatusId = message.CropStatusId;

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
