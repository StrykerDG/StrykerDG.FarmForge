using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.CropLogs.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("CropLogs")]
    public class CropLogController : FarmForgeController
    {
        private IActorRef CropLogActor { get; set; }

        public CropLogController(List<IActorRef> actorRefs)
        {
            CropLogActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("CropLogActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetCropLogs(string type)
        {
            var result = await CropLogActor.Ask(new AskForCropLogs(type));
            return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
