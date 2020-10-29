using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units.Messages
{
    public class AskToCreateUnitConversion
    {
        public UnitTypeConversion Conversion { get; private set; }

        public AskToCreateUnitConversion(UnitTypeConversion conversion)
        {
            Conversion = conversion;
        }
    }
}
