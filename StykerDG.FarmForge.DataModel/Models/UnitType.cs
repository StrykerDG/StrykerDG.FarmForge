using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("UnitType")]
    public class UnitType : BaseModel
    {
        [Key]
        public int UnitTypeId { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public string Description { get; set; }
    }
}
