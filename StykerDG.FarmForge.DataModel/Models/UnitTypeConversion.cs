using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("UnitTypeConversion")]
    public class UnitTypeConversion : BaseModel
    {
        [Key]
        public int UnitTypeConversionId { get; set; }
        public int FromUnitId { get; set; }
        [ForeignKey("FromUnitId")]
        public UnitType FromUnit { get; set; }
        public int ToUnitId { get; set; }
        [ForeignKey("ToUnitId")]
        public UnitType ToUnit { get; set; }
        public int FromQuantity { get; set; }
        public int ToQuantity { get; set; }
    }
}
