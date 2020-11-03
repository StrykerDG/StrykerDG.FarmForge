using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToCreateProductType
    {
        public ProductType ProductType { get; private set; }

        public AskToCreateProductType(ProductType type)
        {
            ProductType = type;
        }
    }
}
