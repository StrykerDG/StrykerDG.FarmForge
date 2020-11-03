using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Suppliers.Messages
{
    public class AskToDeleteSupplier
    {
        public int SupplierId { get; private set; }

        public AskToDeleteSupplier(int id)
        {
            SupplierId = id;
        }
    }
}
