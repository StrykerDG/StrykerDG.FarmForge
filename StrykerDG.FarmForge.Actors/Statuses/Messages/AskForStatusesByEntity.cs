using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Statuses.Messages
{
    public class AskForStatusesByEntity
    {
        public string EntityType { get; private set; }

        public AskForStatusesByEntity(string entityType)
        {
            EntityType = entityType;
        }
    }
}
