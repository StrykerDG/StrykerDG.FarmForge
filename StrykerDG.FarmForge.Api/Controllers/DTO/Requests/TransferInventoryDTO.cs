using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class TransferInventoryDTO
    {
        public int[] ProductIds { get; set; }
        public int LocationId { get; set; }
    }
}
