using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Crops.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Crops")]
    public class CropController : ControllerBase
    {
        private IActorRef CropActor { get; set; }

        public CropController(List<IActorRef> actorRefs)
        {
            CropActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("CropActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetCrops(string begin, string end, string includes)
        {
            if (
                DateTime.TryParse(begin, out var beginDateTime) &&
                DateTime.TryParse(end, out var endDateTime)
            )
            {
                var result = await CropActor.Ask(new AskForCrops(
                    beginDateTime, 
                    endDateTime,
                    includes
                ));
                return Ok(FarmForgeApiResponse.Success(result));
            }
            else
                return Ok(FarmForgeApiResponse.Failure("Error Retrieving Crops"));
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateCrop([FromBody]NewCropDTO newCrop)
        {
            var result = await CropActor.Ask(new AskToCreateCrop(
                newCrop.CropTypeId,
                newCrop.VarietyId,
                newCrop.LocationId,
                newCrop.Quantity,
                newCrop.Date
            ));

            var resultType = result.GetType();
            if(resultType == typeof(Exception))
            {
                var ex = (Exception)result;
                return Ok(FarmForgeApiResponse.Failure(ex.Message));
            }
            else
                return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
