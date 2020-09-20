using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Locations.Messages
{
    public class AskToDeleteLocation
    {
        public int LocationId { get; private set; }

        public AskToDeleteLocation(int id)
        {
            LocationId = id;
        }
    }
}
