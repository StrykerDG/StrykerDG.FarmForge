using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToCreateProductCategory
    {
        public ProductCategory ProductCategory { get; private set; }

        public AskToCreateProductCategory(ProductCategory category)
        {
            ProductCategory = category;
        }
    }
}
