using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Crops.Messages
{
    public class AskForCrops
    {
        public DateTime Begin { get; private set; }
        public DateTime End { get; set; }

        public AskForCrops(DateTime begin, DateTime end)
        {
            Begin = begin;
            End = end;
        }
    }
}
