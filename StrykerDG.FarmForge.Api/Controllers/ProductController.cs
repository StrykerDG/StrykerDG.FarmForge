using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Products.Messages;
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
            var result = await ProductActor.Ask(
                new AskForInventory(),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost("Inventory")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> AddInventory([FromBody]NewInventoryDTO newInventory)
        {
            var result = await ProductActor.Ask(
                new AskToAddInventory(
                    newInventory.SupplierId,
                    newInventory.ProductTypeId,
                    newInventory.LocationId,
                    newInventory.Quantity,
                    newInventory.UnitTypeId
                ),
                TimeSpan.FromSeconds(15)
            );
            return ValidateActorResult(result);
        }

        [HttpPost("Inventory/Consume")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> ConsumeInventory([FromBody]ConsumeInventoryDTO consumedInventory)
        {
            var result = await ProductActor.Ask(
                new AskToConsumeInventory(consumedInventory.ProductIds),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost("Inventory/Transfer")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> TransferInventoryToNewLocation([FromBody]TransferInventoryDTO transferData)
        {
            var result = await ProductActor.Ask(
                new AskToTransferInventory(
                    transferData.ProductIds.ToList(),
                    transferData.LocationId
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpPost("Inventory/Split")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> SplitInventory([FromBody]SplitInventoryDTO request)
        {
            var result = await ProductActor.Ask(
                new AskToSplitInventory(
                    request.ProductIds, 
                    request.UnitTypeConversionId,
                    request.LocationId
                ),
                TimeSpan.FromSeconds(15)
            );
            return ValidateActorResult(result);
        }

        [HttpGet]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetProductTypes()
        {
            var result = await ProductActor.Ask(
                new AskForProductTypes(),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateProductType([FromBody]ProductType newProduct)
        {
            var result = await ProductActor.Ask(
                new AskToCreateProductType(
                    newProduct
                ),
                TimeSpan.FromSeconds(15)
            );

            return ValidateActorResult(result);
        }

        [HttpPatch]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> UpdateProductType([FromBody]ProductType product)
        {
            var result = await ProductActor.Ask(
                new AskToUpdateProductType(product),
                TimeSpan.FromSeconds(15)
            );
            return ValidateActorResult(result);
        }

        [HttpDelete("{productTypeId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteProductType(int productTypeId)
        {
            var result = await ProductActor.Ask(
                new AskToDeleteProductType(productTypeId),
                TimeSpan.FromSeconds(15)
            );
            return ValidateActorResult(result);
        }

        [HttpGet("Categories")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetProductCategories()
        {
            var result = await ProductActor.Ask(
                new AskForProductCategories(),
                TimeSpan.FromSeconds(15)
            );
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost("Categories")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateProductCategory([FromBody]ProductCategory productCategory)
        {
            var result = await ProductActor.Ask(
                new AskToCreateProductCategory(productCategory),
                TimeSpan.FromSeconds(15)
            );
            return ValidateActorResult(result);
        }

        [HttpDelete("Categories/{productCategoryId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteProductCategory(int productCategoryId)
        {
            var result = await ProductActor.Ask(
                new AskToDeleteProductCategory(productCategoryId),
                TimeSpan.FromSeconds(15)
            );
            return ValidateActorResult(result);
        }
    }
}
