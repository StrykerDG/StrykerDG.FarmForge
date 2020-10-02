using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropTypes.Messages
{
    public class AskToCreateCropType
    {
        public string Name { get; private set; }
        public int ClassificationId { get; private set; }

        public AskToCreateCropType(string name, int id)
        {
            Name = name;
            ClassificationId = id;
        }
    }
}
