using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Locations.Messages;
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
    [Route("Locations")]
    public class LocationController : FarmForgeController
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
            var result = await LocationActor.Ask(
                new AskForLocations(),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> AddLocation([FromBody]NewLocationDTO newLocation)
        {
            var result = await LocationActor.Ask(
                new AskToCreateLocation(
                    newLocation.Label,
                    newLocation.ParentId
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpPatch]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> UpdateLocation([FromBody]UpdateLocationDTO updatedLocation)
        {
            var result = await LocationActor.Ask(
                new AskToUpdateLocation(
                    updatedLocation.Fields,
                    updatedLocation.Location
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpDelete("{locationId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteLocation(int locationId)
        {
            var result = await LocationActor.Ask(
                new AskToDeleteLocation(locationId),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }
    }
}
