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
                try
                {
                    // Get all results within the specified time frame
                    var results = context.Crops
                        .WithIncludes(message.Includes)
                        .Where(c =>
                            c.PlantedAt >= message.Begin &&
                            c.PlantedAt <= message.End &&
                            c.IsDeleted == false
                        )
                        .ToList();

                    // Apply filters if there are any
                    if (message.Status != null)
                    {
                        var statusList = message.Status.Split(",").ToList();

                        results = results
                            .Where(c => statusList.Contains(c.Status?.Name))
                            .ToList();
                    }

                    if (message.Location != null)
                    {
                        var locationList = message.Location.Split(",").ToList();

                        results = results
                            .Where(c => locationList.Contains(c.Location?.Name))
                            .ToList();
                    }

                    Sender.Tell(results);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }

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

                    // Make sure we have required data                    
                    if (message.CropId == 0 | message.LogTypeId == 0 | message.CropStatusId == 0)
                        throw new Exception("Invalid CropId, CropTypeId, or StatusId");

                    var dbCrop = context.Crops
                        .Include("CropType")
                        .Where(c => c.CropId == message.CropId)
                        .FirstOrDefault();

                    var existingUnitType = context.UnitTypes
                        .Where(u =>
                            u.UnitTypeId == message.UnitTypeId &&
                            u.IsDeleted == false
                        )
                        .FirstOrDefault();

                    var harvestLogType = context.LogTypes
                        .AsNoTracking()
                        .Where(lt =>
                            lt.EntityType == "Crop.Log" &&
                            lt.Name == "harvest"
                        )
                        .FirstOrDefault();

                    if (dbCrop == null)
                        throw new Exception("Invalid CropId");

                    if (existingUnitType == null && message.LogTypeId == harvestLogType.LogTypeId)
                        throw new Exception("UnitType does not exist");

                    // Create a new log
                    var newLog = new CropLog
                    {
                        CropId = dbCrop.CropId,
                        LogTypeId = message.LogTypeId,
                        Notes = message.Notes
                    };

                    context.Add(newLog);

                    // Create product if we're recording a harvest
                    if(message.LogTypeId == harvestLogType.LogTypeId)
                    {
                        var inventoryStatus = context.Statuses
                            .AsNoTracking()
                            .Where(s =>
                                s.EntityType == "Product.Status" &&
                                s.Name == "inventory"
                            )
                            .Select(s => s.StatusId)
                            .FirstOrDefault();

                        for(var i = 0; i < message.Quantity; i++)
                        {
                            context.Add(new Product
                            {
                                ProductTypeId = dbCrop.CropType.OutputTypeId,
                                LocationId = dbCrop.LocationId,
                                StatusId = inventoryStatus,
                                UnitTypeId = (int)message.UnitTypeId,
                                Sources = new List<ProductSource> { 
                                    new ProductSource 
                                    {
                                        CropId = dbCrop.CropId
                                    }
                                }
                            });
                        }
                    }

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
