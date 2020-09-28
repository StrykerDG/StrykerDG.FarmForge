using StrykerDG.FarmForge.Actors.Locations.Messages;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Crops.Messages
{
    public class AskToUpdateCrop
    {
        public string Fields { get; private set; }
        public Crop Crop { get; private set; }

        public AskToUpdateCrop(string fields, Crop crop)
        {
            Fields = fields;
            Crop = crop;
        }
    }
}
