using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.LogTypes.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("LogTypes")]
    public class LogTypeController : FarmForgeController
    {
        private IActorRef LogTypeActor { get; set; }

        public LogTypeController(List<IActorRef> actorRefs)
        {
            LogTypeActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("LogTypeActor"))
                .FirstOrDefault();
        }

        [HttpGet("{entityType}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetLogTypesByEntity(string entityType)
        {
            var results = await LogTypeActor.Ask(new AskForLogsByEntity(entityType));
            return Ok(FarmForgeApiResponse.Success(results));
        }
    }
}
