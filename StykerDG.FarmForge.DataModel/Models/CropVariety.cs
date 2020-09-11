using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("CropVariety")]
    public class CropVariety : BaseModel
    {
        [Key]
        public int CropVarietyId { get; set; }
        public int CropTypeId { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
    }
}
