using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Units.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Units")]
    public class UnitController : FarmForgeController
    {
        private IActorRef UnitActor { get; set; }

        public UnitController(List<IActorRef> actorRefs)
        {
            UnitActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("UnitActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetUnitTypes()
        {
            var results = await UnitActor.Ask(new AskForUnitTypes());
            return Ok(FarmForgeApiResponse.Success(results));
        }
    }
}
