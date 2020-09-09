using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses
{
    public class FarmForgeApiResponse : ActionResult
    {
        public object Data { get; set; }
        public string Error { get; set; }

        public static FarmForgeApiResponse Success(object data)
        {
            return new FarmForgeApiResponse
            {
                Data = data
            };
        }

        public static FarmForgeApiResponse Failure(string error)
        {
            return new FarmForgeApiResponse
            {
                Error = error
            };
        }
    }
}
