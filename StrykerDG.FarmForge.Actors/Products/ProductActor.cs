using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.DTO.Responses;
using StrykerDG.FarmForge.Actors.Products.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Extensions;
using StrykerDG.FarmForge.DataModel.Models;
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
            Receive<AskToAddInventory>(HandleAskToAddInventory);
            Receive<AskToTransferInventory>(HandleAskToTransferInventory);
            Receive<AskToConsumeInventory>(HandleAskToConsumeInventory);
            Receive<AskForProductTypes>(HandleAskForProductTypes);
            Receive<AskToCreateProductType>(HandleAskToCreateProductType);
            Receive<AskToUpdateProductType>(HandleAskToUpdateProductType);
            Receive<AskToDeleteProductType>(HandleAskToDeleteProductType);
            Receive<AskForProductCategories>(HandleAskForProductCategories);
            Receive<AskToCreateProductCategory>(HandleAskToCreateProductCategory);
            Receive<AskToDeleteProductCategory>(HandleAskToDeleteProductCategory);
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

        public void HandleAskToAddInventory(AskToAddInventory message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = new List<Product>();

                try
                {
                    // Check that the provided information is correct
                    var dbSupplier = context.Suppliers
                        .AsNoTracking()
                        .Where(s => s.SupplierId == message.SupplierId && s.IsDeleted == false)
                        .FirstOrDefault();

                    var dbProductType = context.ProductTypes
                        .AsNoTracking()
                        .Where(pt => pt.ProductTypeId == message.ProductTypeId && pt.IsDeleted == false)
                        .FirstOrDefault();

                    var dbLocation = context.Locations
                        .AsNoTracking()
                        .Where(l => l.LocationId == message.LocationId && l.IsDeleted == false)
                        .FirstOrDefault();

                    var dbUnitType = context.UnitTypes
                        .AsNoTracking()
                        .Where(u => u.UnitTypeId == message.UnitTypeId && u.IsDeleted == false)
                        .FirstOrDefault();

                    if (dbSupplier == null)
                        throw new Exception("Supplier not found");

                    if (dbProductType == null)
                        throw new Exception("ProductType not found");

                    if (dbLocation == null)
                        throw new Exception("Location not found");

                    if (dbUnitType == null)
                        throw new Exception("UnitType not found");

                    if (message.Quantity <= 0)
                        throw new Exception("Quantity must be greater than 0");

                    var inventoryStatus = context.Statuses
                        .AsNoTracking()
                        .Where(s =>
                            s.EntityType == "Product.Status" &&
                            s.Name == "inventory"
                        )
                        .Select(s => s.StatusId)
                        .FirstOrDefault();

                    for(var i = 0; i < message.Quantity; i++)
                    {
                        results.Add(new Product
                        {
                            ProductTypeId = dbProductType.ProductTypeId,
                            LocationId = dbLocation.LocationId,
                            StatusId = inventoryStatus,
                            UnitTypeId = dbUnitType.UnitTypeId,
                            Sources = new List<ProductSource> {
                                new ProductSource
                                {
                                    SupplierId = dbSupplier.SupplierId
                                }
                            }
                        });
                    }

                    context.AddRange(results);
                    context.SaveChanges();
                    Sender.Tell(results);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
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

        private void HandleAskToConsumeInventory(AskToConsumeInventory message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var dbProducts = context.Products
                    .Where(p => message.ProductIds.Contains(p.ProductId))
                    .ToList();

                var consumedStatus = context.Statuses
                    .Where(s => s.Name == "consumed")
                    .Select(s => s.StatusId)
                    .FirstOrDefault();

                var unknownLocation = context.Locations
                    .Where(l => l.Name == "unknown")
                    .Select(l => l.LocationId)
                    .FirstOrDefault();

                foreach (var product in dbProducts)
                {
                    product.StatusId = consumedStatus;
                    product.LocationId = unknownLocation;
                }

                context.SaveChanges();

                Sender.Tell(true);
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

        private void HandleAskToCreateProductType(AskToCreateProductType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    if (message.ProductType == null || message.ProductType.ProductTypeId != 0)
                        throw new Exception("Invalid Type Object");

                    if (
                        message.ProductType.Label == null || 
                        message.ProductType.Label == string.Empty ||
                        message.ProductType.ProductCategoryId == 0
                    )
                        throw new Exception("Must provide a label and categoryId");

                    if (
                        message.ProductType.Name == null || 
                        message.ProductType.Name == string.Empty
                    )
                        message.ProductType.Name = message.ProductType.Label
                            .ToLower()
                            .Replace(" ", "_");

                    var existingProductType = context.ProductTypes
                        .Where(pt => 
                            pt.Name == message.ProductType.Name &&
                            pt.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingProductType != null)
                        throw new Exception("ProductType already exists");

                    var existingCategory = context.ProductCategories
                        .AsNoTracking()
                        .Where(pc => 
                            pc.ProductCategoryId == message.ProductType.ProductCategoryId &&
                            pc.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingCategory == null)
                        throw new Exception("ProductCategory does not exist");

                    // Remove the category object so a new item isn't created or an existing
                    // item isn't updated
                    if (message.ProductType.ProductCategory != null)
                        message.ProductType.ProductCategory = null;

                    var result = context.Add(message.ProductType).Entity;
                    context.SaveChanges();

                    // Build the full ProductType object
                    result.ProductCategory = existingCategory;

                    Sender.Tell(result);
                }
                catch (Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskToUpdateProductType(AskToUpdateProductType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    // Make sure the product exists
                    if (message.ProductType == null)
                        throw new Exception("ProductType cannot be null");

                    if (message.ProductType.Label == null && message.ProductType.Name == null)
                        throw new Exception("ProductType must have a name or label");

                    var existingProductType = context.ProductTypes
                        .Where(pt =>
                            pt.ProductTypeId == message.ProductType.ProductTypeId &&
                            pt.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingProductType == null)
                        throw new Exception("ProductType does not exist");

                    var properties = message.ProductType.GetType().GetProperties();
                    foreach (var property in properties)
                    {
                        var providedValue = message
                            .ProductType
                            .GetType()
                            .GetProperty(property.Name)
                            .GetValue(message.ProductType, null);

                        existingProductType
                            .GetType()
                            .GetProperty(property.Name)
                            .SetValue(existingProductType, providedValue);
                    }

                    if (existingProductType.Name == null)
                        existingProductType.Name = existingProductType.Label.ToLower().Replace(" ", "_");
                    if (existingProductType.Label == null)
                        existingProductType.Label = existingProductType.Name;

                    context.SaveChanges();
                    Sender.Tell(existingProductType);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskToDeleteProductType(AskToDeleteProductType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    // Make sure the product exists
                    var existingProductType = context.ProductTypes
                        .Where(pt =>
                            pt.ProductTypeId == message.ProductTypeId &&
                            pt.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingProductType == null)
                        throw new Exception("ProductType does not exist");

                    // We cant delete if there are products or crops using the type
                    var dependentCrops = context.Crops
                        .AsNoTracking()
                        .Where(c => 
                            c.CropType.OutputTypeId == existingProductType.ProductTypeId &&
                            c.IsDeleted == false
                        )
                        .FirstOrDefault();

                    var dependentProducts = context.Products
                        .Where(p =>
                            p.ProductTypeId == existingProductType.ProductTypeId &&
                            p.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (dependentCrops != null || dependentProducts != null)
                        throw new Exception("Cannot delete product type. In use by products and / or crops");

                    existingProductType.IsDeleted = true;

                    context.SaveChanges();
                    Sender.Tell(true);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskForProductCategories(AskForProductCategories message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var productCategories = context.ProductCategories
                    .Where(pc => pc.IsDeleted == false)
                    .ToList();

                Sender.Tell(productCategories);
            });
        }

        private void HandleAskToCreateProductCategory(AskToCreateProductCategory message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    if (message.ProductCategory == null || message.ProductCategory.ProductCategoryId != 0)
                        throw new Exception("Invalid Cateogry Object");

                    if (
                        (message.ProductCategory.Label == null ||
                        message.ProductCategory.Label == string.Empty) &&
                        (message.ProductCategory.Name == null ||
                        message.ProductCategory.Name == string.Empty)
                    )
                        throw new Exception("Categories must have a name or label");


                    if (message.ProductCategory.Name == null)
                        message.ProductCategory.Name = message.ProductCategory.Label
                            .ToLower()
                            .Replace(" ", "_");
                    else if (message.ProductCategory.Label == null)
                        message.ProductCategory.Label = message.ProductCategory.Name;

                    var result = context.Add(message.ProductCategory).Entity;
                    context.SaveChanges();

                    Sender.Tell(result);
                }
                catch (Exception ex) 
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskToDeleteProductCategory(AskToDeleteProductCategory message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    // Make sure the category exists
                    var existingCategory = context.ProductCategories
                        .Where(pc =>
                            pc.ProductCategoryId == message.ProductCategoryId &&
                            pc.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingCategory == null)
                        throw new Exception("Product Category does not exist");

                    // Make sure there arent any product types using the category
                    var dependentTypes = context.ProductTypes
                        .Where(pt =>
                            pt.ProductCategoryId == existingCategory.ProductCategoryId &&
                            pt.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (dependentTypes != null)
                        throw new Exception("Cannot delete product category. In use by product types");

                    existingCategory.IsDeleted = true;

                    context.SaveChanges();
                    Sender.Tell(true);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        // Helper Methods
    }
}
