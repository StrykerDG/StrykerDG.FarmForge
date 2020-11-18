using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.CropClassifications.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("CropClassifications")]
    public class CropClassificationController : FarmForgeController
    {
        private IActorRef CropClassificationActor { get; set; }

        public CropClassificationController(List<IActorRef> actorRefs)
        {
            CropClassificationActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("CropClassificationActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetClassifications()
        {
            var result = await CropClassificationActor.Ask(
                new AskForCropClassifications(),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
