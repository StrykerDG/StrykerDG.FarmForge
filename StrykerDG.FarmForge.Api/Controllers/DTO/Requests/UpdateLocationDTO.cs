using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class UpdateLocationDTO
    {
        public string Fields { get; set; }
        public Location Location { get; set; }
    }
}
