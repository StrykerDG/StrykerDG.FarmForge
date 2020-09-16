using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Locations.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Locations")]
    public class LocationController : ControllerBase
    {
        private IActorRef LocationActor { get; set; }

        public LocationController(List<IActorRef> actorRefs)
        {
            LocationActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("LocationActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetLocations()
        {
            var result = await LocationActor.Ask(new AskForLocations());
            return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
