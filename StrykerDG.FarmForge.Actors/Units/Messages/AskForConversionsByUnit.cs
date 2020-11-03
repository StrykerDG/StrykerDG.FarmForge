using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units.Messages
{
    public class AskForConversionsByUnit
    {
        public int UnitTypeId { get; private set; }

        public AskForConversionsByUnit(int unitTypeId)
        {
            UnitTypeId = unitTypeId;
        }
    }
}
