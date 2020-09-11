using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Location")]
    public class Location : BaseModel
    {
        [Key]
        public int LocationId { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
    }
}
