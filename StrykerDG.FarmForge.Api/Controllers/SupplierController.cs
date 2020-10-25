using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Suppliers.Messages;
using StrykerDG.FarmForge.DataModel.Models;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Suppliers")]
    public class SupplierController : FarmForgeController
    {
        private IActorRef SupplierActor { get; set; }

        public SupplierController(List<IActorRef> actorRefs)
        {
            SupplierActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("SupplierActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetSuppliers()
        {
            var result = await SupplierActor.Ask(new AskForSuppliers());
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> AddSupplier([FromBody]Supplier newSupplier)
        {
            var result = await SupplierActor.Ask(new AskToCreateSupplier(newSupplier));
            return ValidateActorResult(result);
        }

        [HttpDelete("{supplierId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteSupplier(int supplierId)
        {
            var result = await SupplierActor.Ask(new AskToDeleteSupplier(supplierId));
            return ValidateActorResult(result);
        }
    }
}
