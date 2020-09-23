using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.CropTypes.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Extensions;
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
    }
}
