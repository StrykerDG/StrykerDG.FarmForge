using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.CropLogs.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropLogs
{
    public class CropLogActor : FarmForgeActor
    {
        public CropLogActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForCropLogs>(HandleAskForCropLogs);
        }

        // Message Methods
        public void HandleAskForCropLogs(AskForCropLogs message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = message.Type != null
                    ? context.CropLogs
                        .Where(l => l.LogType.Name == message.Type)
                        .ToList()
                    : context.CropLogs
                        .ToList();

                Sender.Tell(results);
            });
        }
    }
}
