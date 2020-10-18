using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewCropLogDTO
    {
        public int LogTypeId { get; set; }
        public int CropStatusId { get; set; }
        public string Notes { get; set; }
        public int? UnitTypeId { get; set; }
        public int? Quantity { get; set; }
    }
}
