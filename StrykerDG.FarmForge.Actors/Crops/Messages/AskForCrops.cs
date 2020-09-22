using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Crops.Messages
{
    public class AskForCrops
    {
        public DateTime Begin { get; private set; }
        public DateTime End { get; private set; }
        public string Includes { get; private set; }

        public AskForCrops(DateTime begin, DateTime end, string includes)
        {
            Begin = begin;
            End = end;
            Includes = includes;
        }
    }
}
