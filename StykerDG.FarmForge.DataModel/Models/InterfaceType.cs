using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StrykerDG.FarmForge.DataModel.Models
{
    [Table("InterfaceType")]
    public class InterfaceType : BaseModel
    {
        [Key]
        public int InterfaceTypeId { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public string ModelNumber { get; set; }
        public int ParentInterfaceTypeId { get; set; }
    }
}
