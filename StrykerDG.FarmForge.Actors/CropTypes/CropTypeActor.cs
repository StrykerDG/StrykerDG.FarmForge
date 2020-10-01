using Akka.Actor;
using Akka.Util.Internal;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.CropTypes.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Extensions;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropTypes
{
    public class CropTypeActor : FarmForgeActor
    {
        public CropTypeActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForCropTypes>(HandleAskForCropTypes);
            Receive<AskToCreateCropType>(HandleAskToCreateCropType);
            Receive<AskToDeleteCropType>(HandleDeleteCropType);
        }

        // Message Methods
        public void HandleAskForCropTypes(AskForCropTypes message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.CropTypes
                    .AsNoTracking()
                    .WithIncludes(message.Includes)
                    .Where(ct => ct.IsDeleted == false)
                    .ToList();

                Sender.Tell(results);
            });
        }

        public void HandleAskToCreateCropType(AskToCreateCropType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var existingClassification = context.CropClassifications
                        .AsNoTracking()
                        .Where(c =>
                            c.CropClassificationId == message.ClassificationId &
                            c.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingClassification == null)
                        throw new Exception("Classification not found");

                    var existingType = context.CropTypes
                        .AsNoTracking()
                        .Where(t =>
                            t.Label == message.Name &&
                            t.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingType != null)
                        throw new Exception("Type already exists");

                    var name = message.Name.ToLower().Replace(" ", "_");
                    var newCropType = new CropType
                    {
                        CropClassificationId = message.ClassificationId,
                        Name = name,
                        Label = message.Name,
                        Varieties = new List<CropVariety>
                        {
                            { new CropVariety { Name = "generic", Label = "Generic" } }
                        }
                    };

                    context.Add(newCropType);
                    context.SaveChanges();

                    newCropType.Classification = existingClassification;
                    Sender.Tell(newCropType);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleDeleteCropType(AskToDeleteCropType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var existingCropType = context.CropTypes
                        .Include("Varieties")
                        .Where(ct =>
                            ct.CropTypeId == message.CropTypeId &&
                            ct.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingCropType == null)
                        throw new Exception("CropType does not exist");

                    var existingCrops = context.Crops
                        .AsNoTracking()
                        .Where(c => c.CropTypeId == message.CropTypeId)
                        .FirstOrDefault();

                    if (existingCrops != null)
                        throw new Exception("Unable to delete. Crops exist with this type");

                    existingCropType.IsDeleted = true;
                    foreach (var variety in existingCropType.Varieties)
                        variety.IsDeleted = true;

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
