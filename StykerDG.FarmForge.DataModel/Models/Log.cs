using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Log")]
    public class Log : BaseModel 
    {
        [Key]
        public int LogId { get; set; }
        public string Message { get; set; }
        public string Data { get; set; }
        public int LogTypeId { get; set; }
        [ForeignKey("LogTypeId")]
        public LogType LogType { get; set; }
    }
}
