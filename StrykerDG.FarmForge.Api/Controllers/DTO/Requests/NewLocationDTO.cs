using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class NewLocationDTO
    {
        public string Label { get; set; }
        public int ParentId { get; set; }
    }
}
