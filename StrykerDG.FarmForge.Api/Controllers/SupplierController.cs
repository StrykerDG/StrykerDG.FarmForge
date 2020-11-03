using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Suppliers.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
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
        public async Task<IActionResult> GetSuppliers(string includes)
        {
            var result = await SupplierActor.Ask(new AskForSuppliers(includes));
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> AddSupplier([FromBody]NewSupplierDTO supplier)
        {
            var result = await SupplierActor.Ask(new AskToCreateSupplier(
                supplier.Supplier,
                supplier.ProductIds
            ));
            return ValidateActorResult(result);
        }

        [HttpPatch]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> UpdateSupplier([FromBody]NewSupplierDTO supplier)
        {
            var result = await SupplierActor.Ask(new AskToUpdateSupplier(
                supplier.Supplier,
                supplier.ProductIds
            ));
            return ValidateActorResult(result);
        }

        [HttpDelete("{supplierId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteSupplier(int supplierId)
        {
            var result = await SupplierActor.Ask(new AskToDeleteSupplier(supplierId));
            return ValidateActorResult(result);
        }

        [HttpGet("{supplierId}/Products")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetSupplierProducts(int supplierId)
        {
            var result = await SupplierActor.Ask(new AskForSupplierProducts(supplierId));
            return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
