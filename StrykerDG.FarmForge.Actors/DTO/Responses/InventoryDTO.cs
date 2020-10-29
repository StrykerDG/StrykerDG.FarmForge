using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.Actors.DTO.Responses
{
    public class InventoryDTO
    {
        public int ProductTypeId { get; set; }
        public ProductType ProductType { get; set; }
        public int Quantity { get; set; }
        public int UnitTypeId { get; set; }
        public UnitType UnitType { get; set; }
        public int LocationId { get; set; }
        public Location Location { get; set; }
        public List<Product> Products { get; set; }
    }
}
