using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("ProductDestination")]
    public class ProductDestination : BaseModel
    {
        [Key]
        public int ProductDestinationId { get; set; }
        public int? OrderId { get; set; }
        [ForeignKey("OrderId")]
        public Order Order { get; set; }
        public int? CropId { get; set; }
        [ForeignKey("CropId")]
        public Crop Crop { get; set; }
    }
}
