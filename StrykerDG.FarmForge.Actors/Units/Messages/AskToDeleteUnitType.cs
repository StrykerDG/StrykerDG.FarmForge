using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units.Messages
{
    public class AskToDeleteUnitType
    {
        public int UnitTypeId { get; private set; }

        public AskToDeleteUnitType(int id)
        {
            UnitTypeId = id;
        }
    }
}
