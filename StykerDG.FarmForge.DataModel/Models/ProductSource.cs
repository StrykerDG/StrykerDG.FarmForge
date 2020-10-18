using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("ProductSource")]
    public class ProductSource : BaseModel
    {
        [Key]
        public int ProductSourceId { get; set; }
        public int ProductId { get; set; }
        public int? SupplierId { get; set; }
        [ForeignKey("SupplierId")]
        public Supplier Supplier { get; set; }
        public int? CropId { get; set; }
        [ForeignKey("CropId")]
        public Crop Crop { get; set; }
    }
}
