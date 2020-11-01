using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class ConsumeInventoryDTO
    {
        public List<int> ProductIds { get; set; }
    }
}
