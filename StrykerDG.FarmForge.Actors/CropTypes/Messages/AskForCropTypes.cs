using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.CropTypes.Messages
{
    public class AskForCropTypes
    {
        public string Includes { get; private set; }

        public AskForCropTypes(string includes)
        {
            Includes = includes;
        }
    }
}
