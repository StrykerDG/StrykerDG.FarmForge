using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units.Messages
{
    public class AskToUpdateUnitConversion
    {
        public UnitTypeConversion Conversion { get; private set; }

        public AskToUpdateUnitConversion(UnitTypeConversion conversion)
        {
            Conversion = conversion;
        }
    }
}
