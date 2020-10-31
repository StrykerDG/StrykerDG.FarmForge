using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units.Messages
{
    public class AskToCreateUnitType
    {
        public UnitType UnitType { get; private set; }

        public AskToCreateUnitType(UnitType type)
        {
            UnitType = type;
        }
    }
}
