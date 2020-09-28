using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.LogTypes.Messages
{
    public class AskForLogsByEntity
    {
        public string EntityType { get; private set; }

        public AskForLogsByEntity(string entityType)
        {
            EntityType = entityType;
        }
    }
}
