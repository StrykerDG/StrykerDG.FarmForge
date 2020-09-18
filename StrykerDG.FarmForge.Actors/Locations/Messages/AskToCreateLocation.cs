using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Locations.Messages
{
    public class AskToCreateLocation
    {
        public string Name { get; private set; }
        public string Label { get; private set; }
        public int ParentId { get; private set; }

        public AskToCreateLocation(string label, int parentId)
        {
            Name = label.ToLower().Replace(" ", "_");
            Label = label;
            ParentId = parentId;
        }
    }
}
