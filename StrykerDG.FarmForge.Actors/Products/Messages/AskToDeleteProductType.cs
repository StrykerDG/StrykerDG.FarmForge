using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToDeleteProductType
    {
        public int ProductTypeId { get; private set; }
        
        public AskToDeleteProductType(int id)
        {
            ProductTypeId = id;
        }
    }
}
