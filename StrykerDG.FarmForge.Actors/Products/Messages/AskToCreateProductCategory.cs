using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToCreateProductCategory
    {
        //public string Label { get; private set; }
        //public string Description { get; private set; }
        public ProductCategory ProductCategory { get; private set; }

        public AskToCreateProductCategory(ProductCategory category)
        {
            //Label = label;
            //Description = description;
            ProductCategory = category;
        }
    }
}
