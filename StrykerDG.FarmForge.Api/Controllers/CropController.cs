using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Crops.Messages;
using StrykerDG.FarmForge.DataModel.Models;
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
    public class CropController : FarmForgeController
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
        public async Task<IActionResult> GetCrops(
            string begin, 
            string end, 
            string includes,
            string status,
            string location
        )
        {
            DateTime.TryParse(begin, out var beginDateTime);

            DateTime endDateTime;
            if (end != null)
                DateTime.TryParse(end, out endDateTime);
            else
                endDateTime = DateTime.Now;

            var result = await CropActor.Ask(
                new AskForCrops(
                    beginDateTime, 
                    endDateTime,
                    includes,
                    status,
                    location
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateCrop([FromBody]NewCropDTO newCrop)
        {
            var result = await CropActor.Ask(
                new AskToCreateCrop(
                    newCrop.CropTypeId,
                    newCrop.VarietyId,
                    newCrop.LocationId,
                    newCrop.Quantity,
                    newCrop.Date
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpPatch]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> UpdateCrop([FromBody]UpdateCropDTO updatedCrop)
        {
            var result = await CropActor.Ask(
                new AskToUpdateCrop(
                    updatedCrop.Fields,
                    updatedCrop.Crop
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpPost("{cropId}/Logs")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateLogForCrop([FromBody]NewCropLogDTO logDto, int cropId)
        {
            var result = await CropActor.Ask(
                new AskToCreateLog(
                    cropId,
                    logDto.LogTypeId,
                    logDto.CropStatusId,
                    logDto.Notes,
                    logDto.Quantity,
                    logDto.UnitTypeId
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }
    }
}
