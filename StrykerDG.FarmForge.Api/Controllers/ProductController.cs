using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Products.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Products")]
    public class ProductController : FarmForgeController
    {
        private IActorRef ProductActor { get; set; }

        public ProductController(List<IActorRef> actorRefs)
        {
            ProductActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("ProductActor"))
                .FirstOrDefault();
        }

        [HttpGet("Inventory")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetCurrentInventory()
        {
            var result = await ProductActor.Ask(new AskForInventory());
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost("Inventory/Transfer")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> TransferInventoryToNewLocation([FromBody]TransferInventoryDTO transferData)
        {
            var result = await ProductActor.Ask(new AskToTransferInventory(
                transferData.ProductIds.ToList(),
                transferData.LocationId
            ));

            return ValidateActorResult(result);
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetProductTypes()
        {
            var result = await ProductActor.Ask(new AskForProductTypes());
            return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
