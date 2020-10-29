using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("ProductType")]
    public class ProductType : BaseModel
    {
        [Key]
        public int ProductTypeId { get; set; }
        public int ProductCategoryId { get; set; }
        [ForeignKey("ProductCategoryId")]
        public ProductCategory ProductCategory { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public int? ReorderLevel { get; set; }
    }
}
