using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropTypes.Messages
{
    public class AskToCreateCropTypeVariety
    {
        public int CropTypeId { get; private set; }
        public string VarietyName { get; private set; }

        public AskToCreateCropTypeVariety(int id, string name)
        {
            CropTypeId = id;
            VarietyName = name;
        }
    }
}
