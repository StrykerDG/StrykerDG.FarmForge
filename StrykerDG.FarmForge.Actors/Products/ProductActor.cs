using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.DTO.Responses;
using StrykerDG.FarmForge.Actors.Products.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Products
{
    public class ProductActor : FarmForgeActor
    {
        public ProductActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForInventory>(HandleAskForInventory);
            Receive<AskToTransferInventory>(HandleAskToTransferInventory);
            Receive<AskForProductTypes>(HandleAskForProductTypes);
        }

        // Message Methods
        public void HandleAskForInventory(AskForInventory message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = new List<InventoryDTO>();

                var currentInventory = context.Products
                    .WithIncludes("ProductType,UnitType,Location")
                    .AsNoTracking()
                    .Where(p =>
                        p.Status.Name == "inventory" &&
                        p.IsDeleted == false
                    )
                    .ToList();

                // Group inventory by location
                var locationGroupedInventory = currentInventory
                    .GroupBy(p => p.LocationId)
                    .ToList();

                foreach(var location in locationGroupedInventory)
                {
                    var locationId = location.Key;
                    var locationProducts = location.ToList();

                    // For each location, group the products by type
                    var typeGroupedInventory = locationProducts
                        .GroupBy(p => p.ProductTypeId)
                        .ToList();


                    foreach(var type in typeGroupedInventory)
                    {
                        var typeId = type.Key;
                        var typeProducts = type.ToList();

                        // For each type, group the products by unit
                        var unitTypedInventory = typeProducts
                            .GroupBy(p => p.UnitTypeId)
                            .ToList();

                        foreach(var unit in unitTypedInventory)
                        {
                            var unitId = unit.Key;
                            var unitProducts = unit.ToList();

                            results.Add(new InventoryDTO
                            {
                                ProductTypeId = typeId,
                                ProductType = unitProducts.First().ProductType,
                                Quantity = unitProducts.Count,
                                UnitTypeId = unitId,
                                UnitType = unitProducts.First().UnitType,
                                LocationId = locationId,
                                Location = unitProducts.First().Location,
                                Products = unitProducts
                            });
                        }
                    }
                }

                Sender.Tell(results);
            });
        }

        public void HandleAskToTransferInventory(AskToTransferInventory message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var requestedLocation = context.Locations
                        .AsNoTracking()
                        .Where(l =>
                            l.LocationId == message.LocationId &&
                            l.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (requestedLocation == null)
                        throw new Exception("Location does not exist");

                    var dbProducts = context.Products
                        .Where(p => message.ProductIds.Contains(p.ProductId))
                        .ToList();

                    foreach(var product in dbProducts)
                        product.LocationId = message.LocationId;

                    context.SaveChanges();

                    Sender.Tell(dbProducts);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskForProductTypes(AskForProductTypes message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var productTypes = context.ProductTypes
                    .Where(pt => pt.IsDeleted == false)
                    .ToList();

                Sender.Tell(productTypes);
            });
        }

        // Helper Methods
    }
}
