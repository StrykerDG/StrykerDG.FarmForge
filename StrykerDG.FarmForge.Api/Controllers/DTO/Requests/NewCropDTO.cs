using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewCropDTO
    {
        public int CropTypeId { get; set; }
        public int VarietyId { get; set; }
        public int LocationId { get; set; }
        public int Quantity { get; set; }
        public DateTime Date { get; set; }
    }
}
