using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewInventoryDTO
    {
        public int SupplierId { get; set; }
        public int ProductTypeId { get; set; }
        public int LocationId { get; set; }
        public int Quantity { get; set; }
        public int UnitTypeId { get; set; }
    }
}
