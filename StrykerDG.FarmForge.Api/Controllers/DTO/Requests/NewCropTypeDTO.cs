using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewCropTypeDTO
    {
        public string Name { get; set; }
        public int ClassificationId { get; set; }
    }
}
