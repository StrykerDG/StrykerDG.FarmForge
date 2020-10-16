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
        public int SourceId { get; set; }
        [ForeignKey("SourceId")]
        public ProductSource Source { get; set; }
        public int? DestinationId { get; set; }
        [ForeignKey("DestinationId")]
        public ProductDestination Destination { get; set; }
        public int LocationId { get; set; }
        [ForeignKey("LocationId")]
        public Location Location { get; set; }
        public int StatusId { get; set; }
        [ForeignKey("StatusId")]
        public Status Status { get; set; }
    }
}
