using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToConsumeInventory
    {
        public List<int> ProductIds { get; private set; }

        public AskToConsumeInventory(List<int> productIds)
        {
            ProductIds = productIds;
        }
    }
}
