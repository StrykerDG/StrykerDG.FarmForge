using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class SplitInventoryDTO
    {
        public List<int> ProductIds { get; set; }
        public int UnitTypeConversionId { get; set; }
        public int LocationId { get; set; }
    }
}
