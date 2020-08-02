using System;

namespace StrykerDG.FarmForge.DataModel.Models
{
    public class BaseModel
    {
        public DateTime Created { get; set; }
        public DateTime Modified { get; set; }
        public bool IsDeleted { get; set; }
    }
}
