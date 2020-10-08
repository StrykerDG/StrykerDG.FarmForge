using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropLogs.Messages
{
    public class AskForCropLogs
    {
        public string Type { get; private set; }

        public AskForCropLogs(string type)
        {
            Type = type;
        }
    }
}
