using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Crops.Messages
{
    public class AskToCreateLog
    {
        public int CropId { get; private set; }
        public int LogTypeId { get; private set; }
        public int CropStatusId { get; private set; }
        public string Notes { get; private set; }

        public AskToCreateLog(
            int cropId,
            int logTypeId, 
            int statusId, 
            string notes
        )
        {
            CropId = cropId;
            LogTypeId = logTypeId;
            CropStatusId = statusId;
            Notes = notes;
        }
    }
}
