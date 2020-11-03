using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Suppliers.Messages
{
    public class AskForSupplierProducts
    {
        public int SupplierId { get; private set; }

        public AskForSupplierProducts(int id)
        {
            SupplierId = id;
        }
    }
}
