using Akka.Actor;
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
            Receive<AskToDeleteSupplier>(HandleAskToDeleteSupplier);
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

                    if (existingSupplier != null && existingSupplier.IsDeleted == true)
                    {
                        existingSupplier.Address = message.Supplier.Address;
                        existingSupplier.Phone = message.Supplier.Phone;
                        existingSupplier.Email = message.Supplier.Email;
                        existingSupplier.IsDeleted = false;

                        result = existingSupplier;
                    }
                    else if (existingSupplier != null && existingSupplier.IsDeleted == false)
                        throw new Exception("Supplier Already Exists");
                    else
                        result = context.Add(message.Supplier).Entity;

                    context.SaveChanges();

                    Sender.Tell(result);
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

                    context.SaveChanges();
                    Sender.Tell(true);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        // Helpers
    }
}
