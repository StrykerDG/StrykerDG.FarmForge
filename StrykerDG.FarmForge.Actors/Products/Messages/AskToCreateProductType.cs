using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToCreateProductType
    {
        //public string Label { get; private set; }
        //public int ReOrderLevel { get; private set; }
        //public int ProductCategoryId { get; private set; }
        public ProductType ProductType { get; private set; }

        public AskToCreateProductType(ProductType type)//string label, int reorderLevel, int productCategoryId)
        {
            //Label = label;
            //ReOrderLevel = reorderLevel;
            //ProductCategoryId = productCategoryId;
            ProductType = type;
        }
    }
}
