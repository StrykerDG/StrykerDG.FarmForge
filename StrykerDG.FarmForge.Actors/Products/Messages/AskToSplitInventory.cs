using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToSplitInventory
    {
        public List<int> ProductIds { get; private set; }
        public int UnitTypeConversionId { get; private set; }
        public int LocationId { get; set; }

        public AskToSplitInventory(List<int> productIds, int unitTypeConversionId, int locationId)
        {
            ProductIds = productIds;
            UnitTypeConversionId = unitTypeConversionId;
            LocationId = locationId;
        }
    }
}
