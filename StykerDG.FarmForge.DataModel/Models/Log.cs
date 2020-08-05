using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Log")]
    public class Log
    {
        [Key]
        public int LogId { get; set; }
        public DateTime TimeStamp { get; set; }
        public string Message { get; set; }
        public string Data { get; set; }
    }
}
