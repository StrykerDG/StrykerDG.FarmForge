using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropTypes.Messages
{
    public class AskToDeleteCropType
    {
        public int CropTypeId { get; private set; }

        public AskToDeleteCropType(int id)
        {
            CropTypeId = id;
        }
    }
}
