using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Suppliers.Messages
{
    public class AskToCreateSupplier
    {
        public Supplier Supplier { get; private set; }
        public List<int> ProductIds { get; private set; }

        public AskToCreateSupplier(Supplier supplier, List<int> productIds = null)
        {
            Supplier = supplier;
            ProductIds = productIds;
        }
    }
}
