using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewCropDTO
    {
        public int CropTypeId { get; private set; }
        public int VarietyId { get; private set; }
        public int LocationId { get; private set; }
        public int Quantity { get; private set; }
        public DateTime Date { get; private set; }
    }
}
