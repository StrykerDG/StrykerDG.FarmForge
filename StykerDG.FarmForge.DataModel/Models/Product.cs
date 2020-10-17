using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Product")]
    public class Product : BaseModel
    {
        [Key]
        public int ProductId { get; set; }
        public int ProductTypeId { get; set; }
        [ForeignKey("ProductTypeId")]
        public ProductType ProductType { get; set; }
        public double? Price { get; set; }
        public int LocationId { get; set; }
        [ForeignKey("LocationId")]
        public Location Location { get; set; }
        public int StatusId { get; set; }
        [ForeignKey("StatusId")]
        public Status Status { get; set; }
        public int UnitTypeId { get; set; }
        [ForeignKey("UnitTypeId")]
        public UnitType UnitType { get; set; }
        public ICollection<ProductDestination> Destinations { get; set; }
        public ICollection<ProductSource> Sources { get; set; }
    }
}
