using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Crop")]
    public class Crop : BaseModel
    {
        [Key]
        public int CropId { get; set; }
        public int CropTypeId { get; set; }
        [ForeignKey("CropTypeId")]
        public CropType CropType { get; set; }
        public int CropVarietyId { get; set; }
        [ForeignKey("CropVarietyId")]
        public CropVariety CropVariety { get; set; }
        public int LocationId { get; set; }
        [ForeignKey("LocationId")]
        public Location Location { get; set; }
        public int StatusId { get; set; }
        [ForeignKey("StatusId")]
        public Status Status { get; set; }
        public DateTime PlantedAt { get; set; }
        public DateTime? GerminatedAt { get; set; }
        public DateTime? HarvestedAt { get; set; }
        public long? TimeToGerminate { get; set; }
        public long? TimeToHarvest { get; set; }
        public int Quantity { get; set; }
        public int? QuantityHarvested { get; set; }
        public double? Yield { get; set; }
        public ICollection<CropLog> Logs { get; set; }
    }
}
