using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.CropTypes.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("CropTypes")]
    public class CropTypeController : ControllerBase
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
    }
}
