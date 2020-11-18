using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Statuses.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Statuses")]
    public class StatusController : FarmForgeController
    {
        private IActorRef StatusActor { get; set; }

        public StatusController(List<IActorRef> actorRefs)
        {
            StatusActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("StatusActor"))
                .FirstOrDefault();
        }

        [HttpGet("{entityType}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetStatusesByEntityType(string entityType)
        {
            var results = await StatusActor.Ask(
                new AskForStatusesByEntity(entityType),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(results));
        }
    }
}
