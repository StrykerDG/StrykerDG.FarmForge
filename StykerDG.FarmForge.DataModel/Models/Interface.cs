using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("Interface")]
    public class Interface : BaseModel
    {
        [Key]
        public int InterfaceId { get; set; }
        public int DeviceId { get; set; }
        public string Name { get; set; }
        public string SerialNumber { get; set; }
        public int InterfaceTypeId { get; set; }
        [ForeignKey("InterfaceTypeId")]
        public InterfaceType InterfaceType { get; set; }
        public ICollection<Telemetry> Telemetry { get; set; }
    }
}
