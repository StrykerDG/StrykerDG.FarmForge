using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Locations.Messages
{
    public class AskToUpdateLocation
    {
        public string Fields { get; private set; }
        public Location Location { get; set; }

        public AskToUpdateLocation(string fields, Location location)
        {
            Fields = fields;
            Location = location;
        }
    }
}
