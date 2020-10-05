using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.CropTypes.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("CropTypes")]
    public class CropTypeController : FarmForgeController
    {
        private IActorRef CropTypeActor { get; set; }

        public CropTypeController(List<IActorRef> actorRefs)
        {
            CropTypeActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("CropTypeActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetCropTypes(string includes = null)
        {
            var result = await CropTypeActor.Ask(new AskForCropTypes(includes));
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> AddCropType([FromBody] NewCropTypeDTO newType) 
        {
            var result = await CropTypeActor.Ask(
                new AskToCreateCropType(
                    newType.Name, 
                    newType.ClassificationId
                ));

            return ValidateActorResult(result);
        }

        [HttpDelete("{id}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteCropType(int id)
        {
            var result = await CropTypeActor.Ask(new AskToDeleteCropType(id));
            return ValidateActorResult(result);
        }

        [HttpPost("{cropTypeId}/Variety/{varietyName}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> AddVarietyToCropType(int cropTypeId, string varietyName)
        {
            var result = await CropTypeActor.Ask(
                new AskToCreateCropTypeVariety(
                    cropTypeId,
                    varietyName
                ));

            return ValidateActorResult(result);
        }

        [HttpDelete("{cropTypeId}/Variety/{varietyId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteVarietyFromCropType(int cropTypeId, int varietyId)
        {
            var result = await CropTypeActor.Ask(
                new AskToDeleteCropTypeVariety(
                    cropTypeId,
                    varietyId
                ));

            return ValidateActorResult(result);
        }
    }
}
