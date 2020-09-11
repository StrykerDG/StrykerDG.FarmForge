using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("CropType")]
    public class CropType : BaseModel
    {
        [Key]
        public int CropTypeId { get; set; }
        public int CropClassificationId { get; set; }
        [ForeignKey("CropClassificationId")]
        public CropClassification Classification { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public long? AverageGermination { get; set; }
        public long? AverageTimeToHarvest { get; set; }
        public double? AverageYield { get; set; }
        public ICollection<CropVariety> Varieties { get; set; }
    }
}
