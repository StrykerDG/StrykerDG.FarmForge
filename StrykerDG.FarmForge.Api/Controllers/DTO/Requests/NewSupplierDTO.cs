using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewSupplierDTO
    {
        public Supplier Supplier { get; set; }
        public List<int> ProductIds { get; set; }
    }
}
