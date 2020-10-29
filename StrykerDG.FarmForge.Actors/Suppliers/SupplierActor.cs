using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Suppliers.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Suppliers
{
    public class SupplierActor : FarmForgeActor
    {
        public SupplierActor(IServiceScopeFactory factory) : base(factory) 
        {
            Receive<AskForSuppliers>(HandleAskForSuppliers);
            Receive<AskToCreateSupplier>(HandleAskToCreateSupplier);
            Receive<AskToUpdateSupplier>(HandleAskToUpdateSupplier);
            Receive<AskToDeleteSupplier>(HandleAskToDeleteSupplier);
            Receive<AskForSupplierProducts>(HandleAskForSupplierProducts);
        }

        // Message Methods
        public void HandleAskForSuppliers(AskForSuppliers message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var suppliers = context.Suppliers
                    .Where(s => s.IsDeleted == false)
                    .ToList();

                Sender.Tell(suppliers);
            });
        }

        public void HandleAskToCreateSupplier(AskToCreateSupplier message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var result = new Supplier();

                try
                {
                    if (message.Supplier.SupplierId != 0)
                        throw new Exception("New Suppliers cannot have an Id");

                    var existingSupplier = context.Suppliers
                        .Where(s => s.Name == message.Supplier.Name)
                        .FirstOrDefault();

                    if (existingSupplier != null && existingSupplier.IsDeleted == false)
                        throw new Exception("Supplier with the provided name already exists");

                    else if (existingSupplier != null && existingSupplier.IsDeleted == true)
                    {
                        existingSupplier.Address = message.Supplier.Address;
                        existingSupplier.Phone = message.Supplier.Phone;
                        existingSupplier.Email = message.Supplier.Email;
                        existingSupplier.IsDeleted = false;

                        result = existingSupplier;
                    }

                    else
                        result = context.Add(message.Supplier).Entity;

                    // Save to get the Id before adding supplier maps
                    context.SaveChanges();

                    // Create any Supplier Product Maps that are specified
                    if (message.ProductIds != null)
                    {
                        var existingProducts = context.ProductTypes
                            .AsNoTracking()
                            .Where(p =>
                                message.ProductIds.Contains(p.ProductTypeId) &&
                                p.IsDeleted == false
                            )
                            .ToList();

                        foreach (var product in existingProducts)
                            context.Add(new SupplierProductTypeMap
                            {
                                SupplierId = result.SupplierId,
                                ProductTypeId = product.ProductTypeId
                            });

                        context.SaveChanges();
                    }

                    Sender.Tell(result);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleAskToUpdateSupplier(AskToUpdateSupplier message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var result = new Supplier();

                try
                {
                    var existingSupplier = context.Suppliers
                        .Where(s => s.Name == message.Supplier.Name)
                        .FirstOrDefault();

                    if (existingSupplier == null)
                        throw new Exception("Supplier does not exist");

                    if (existingSupplier.IsDeleted == true)
                        existingSupplier.IsDeleted = false;

                    // Update using the latest supplied properties
                    var properties = message.Supplier.GetType().GetProperties();
                    foreach (var property in properties)
                    {
                        var providedValue = message
                            .Supplier
                            .GetType()
                            .GetProperty(property.Name)
                            .GetValue(message.Supplier, null);

                        existingSupplier
                            .GetType()
                            .GetProperty(property.Name)
                            .SetValue(existingSupplier, providedValue);
                    }

                    // Update any Supplier Product Maps
                    var existingSupplierMaps = context.SupplierProductTypeMaps
                        .Where(sptm => sptm.SupplierId == existingSupplier.SupplierId)
                        .ToList();

                    var existingSupplierMapProductIds = existingSupplierMaps
                        .Select(m => m.ProductTypeId)
                        .ToList();

                    if (message.ProductIds == null)
                        foreach (var map in existingSupplierMaps)
                            map.IsDeleted = true;
                    else
                    {
                        var mapsToRemove = existingSupplierMaps
                            .Where(m => !message.ProductIds.Contains(m.ProductTypeId))
                            .ToList();

                        var mapsToEnable = existingSupplierMaps
                            .Where(m =>
                                message.ProductIds.Contains(m.ProductTypeId) &&
                                m.IsDeleted == true
                            )
                            .ToList();

                        var mapsToAdd = message.ProductIds
                            .Where(id => !existingSupplierMapProductIds.Contains(id))
                            .ToList();

                        var existingProducts = context.ProductTypes
                            .AsNoTracking()
                            .Where(pt => mapsToAdd.Contains(pt.ProductTypeId))
                            .ToList();

                        // Remove
                        foreach (var map in mapsToRemove)
                            map.IsDeleted = true;

                        // Update
                        foreach (var map in mapsToEnable)
                            map.IsDeleted = false;

                        // Create
                        foreach (var product in existingProducts)
                            context.Add(new SupplierProductTypeMap
                            {
                                SupplierId = existingSupplier.SupplierId,
                                ProductTypeId = product.ProductTypeId
                            });
                    }

                    context.SaveChanges();

                    Sender.Tell(existingSupplier);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleAskToDeleteSupplier(AskToDeleteSupplier message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var existingSupplier = context.Suppliers
                        .Where(s =>
                            s.SupplierId == message.SupplierId &&
                            s.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingSupplier == null)
                        throw new Exception("Supplier not found");

                    existingSupplier.IsDeleted = true;

                    var supplierProductMaps = context.SupplierProductTypeMaps
                        .Where(sptm => sptm.SupplierId == existingSupplier.SupplierId)
                        .ToList();

                    foreach (var map in supplierProductMaps)
                        map.IsDeleted = true;

                    context.SaveChanges();
                    Sender.Tell(true);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        public void HandleAskForSupplierProducts(AskForSupplierProducts message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var supplierProducts = context.SupplierProductTypeMaps
                    .Include("ProductType")
                    .Where(sptm =>
                        sptm.SupplierId == message.SupplierId &&
                        sptm.IsDeleted == false
                    )
                    .Select(sptm => sptm.ProductType)
                    .ToList();

                Sender.Tell(supplierProducts);
            });
        }

        // Helpers
    }
}
