using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products.Messages
{
    public class AskToDeleteProductCategory
    {
        public int ProductCategoryId { get; private set; }

        public AskToDeleteProductCategory(int productCategoryId) 
        {
            ProductCategoryId = productCategoryId;
        }
    }
}
