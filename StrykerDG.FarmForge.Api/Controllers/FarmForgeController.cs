using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    public class FarmForgeController : ControllerBase
    {
        protected IActionResult ValidateActorResult(object result)
        {
            var resultType = result.GetType();
            if (resultType == typeof(Exception))
            {
                var ex = (Exception)result;
                return Ok(FarmForgeApiResponse.Failure(ex.Message));
            }
            else
                return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
