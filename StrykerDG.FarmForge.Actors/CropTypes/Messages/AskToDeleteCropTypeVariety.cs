using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropTypes.Messages
{
    public class AskToDeleteCropTypeVariety
    {
        public int CropTypeId { get; private set; }
        public int VarietyId { get; private set; }

        public AskToDeleteCropTypeVariety(int cropTypeId, int varietyId)
        {
            CropTypeId = cropTypeId;
            VarietyId = varietyId;
        }
    }
}
