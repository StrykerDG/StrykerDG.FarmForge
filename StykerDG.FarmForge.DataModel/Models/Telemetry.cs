using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Telemetry")]
    public class Telemetry : BaseModel
    {
        [Key]
        public int TelemetryId { get; set; }
        public int InterfaceId { get; set; }
        public DateTime TimeStamp { get; set; }
        public double? Value { get; set; }
        public string StringValue { get; set; }
        public bool? BoolValue { get; set; }
    }
}
