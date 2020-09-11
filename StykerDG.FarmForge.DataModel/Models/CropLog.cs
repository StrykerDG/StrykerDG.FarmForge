using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("CropLog")]
    public class CropLog : BaseModel
    {
        [Key]
        public int CropLogId { get; set; }
        public int CropId { get; set; }
        public int LogTypeId { get; set; }
        public string Notes { get; set; }
    }
}
