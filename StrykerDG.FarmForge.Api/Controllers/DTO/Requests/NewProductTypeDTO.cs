using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewProductTypeDTO
    {
        public string Label { get; set; }
        public int ReOrderLevel { get; set; }
        public int ProductCategoryId { get; set; }
    }
}
