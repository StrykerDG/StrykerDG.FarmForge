using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units.Messages
{
    public class AskToDeleteUnitConversion
    {
        public int UnitConversionId { get; private set; }

        public AskToDeleteUnitConversion(int id)
        {
            UnitConversionId = id;
        }
    }
}
