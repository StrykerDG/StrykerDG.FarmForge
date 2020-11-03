using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("ProductCategory")]
    public class ProductCategory : BaseModel
    {
        [Key]
        public int ProductCategoryId { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public string Description { get; set; }
    }
}
