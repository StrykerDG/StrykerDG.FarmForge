using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Units.Messages;
using StrykerDG.FarmForge.DataModel.Models;
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

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateUnitType([FromBody]UnitType newType)
        {
            var result = await UnitActor.Ask(new AskToCreateUnitType(newType));
            return ValidateActorResult(result);
        }

        [HttpDelete("{unitTypeId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteUnitType(int unitTypeId)
        {
            var result = await UnitActor.Ask(new AskToDeleteUnitType(unitTypeId));
            return ValidateActorResult(result);
        }

        [HttpGet("Conversions")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetUnitConversions()
        {
            var results = await UnitActor.Ask(new AskForUnitConversions());
            return Ok(FarmForgeApiResponse.Success(results));
        }

        [HttpPost("Conversions")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateUnitConversion([FromBody]UnitTypeConversion conversion)
        {
            var result = await UnitActor.Ask(new AskToCreateUnitConversion(conversion));
            return ValidateActorResult(result);
        }

        [HttpPatch("Conversions")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> UpdateUnitConversion([FromBody] UnitTypeConversion conversion)
        {
            var result = await UnitActor.Ask(new AskToUpdateUnitConversion(conversion));
            return ValidateActorResult(result);
        }

        [HttpDelete("Conversions/{conversionId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteUnitConversion(int conversionId)
        {
            var result = await UnitActor.Ask(new AskToDeleteUnitConversion(conversionId));
            return ValidateActorResult(result);
        }
    }
}
