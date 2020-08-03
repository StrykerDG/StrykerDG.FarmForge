using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Status")]
    public class Status : BaseModel
    {
        [Key]
        public int StatusId { get; set; }
        public string EntityType { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
    }
}
