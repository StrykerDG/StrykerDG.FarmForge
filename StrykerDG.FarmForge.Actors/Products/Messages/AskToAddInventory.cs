using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToAddInventory
    {
        public int SupplierId { get; private set; }
        public int ProductTypeId { get; private set; }
        public int LocationId { get; private set; }
        public int Quantity { get; private set; }
        public int UnitTypeId { get; private set; }

        public AskToAddInventory(
            int supplierId,
            int productId,
            int locationId,
            int quantity,
            int unitTypeId
        )
        {
            SupplierId = supplierId;
            ProductTypeId = productId;
            LocationId = locationId;
            Quantity = quantity;
            UnitTypeId = unitTypeId;
        }
    }
}
