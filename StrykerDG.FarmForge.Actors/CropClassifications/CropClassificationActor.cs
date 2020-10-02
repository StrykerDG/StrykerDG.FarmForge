using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.CropClassifications.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropClassifications
{
    public class CropClassificationActor : FarmForgeActor
    {
        public CropClassificationActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForCropClassifications>(HandleAskForClassifications);
        }

        // Message Methods
        public void HandleAskForClassifications(AskForCropClassifications message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.CropClassifications
                    .Where(c => c.IsDeleted == false)
                    .ToList();

                Sender.Tell(results);
            });
        }
    }
}
