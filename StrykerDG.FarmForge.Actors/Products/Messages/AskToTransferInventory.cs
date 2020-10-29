using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToTransferInventory
    {
        public List<int> ProductIds { get; private set; }
        public int LocationId { get; private set; }

        public AskToTransferInventory(List<int> productIds, int locationId)
        {
            ProductIds = productIds;
            LocationId = locationId;
        }
    }
}
