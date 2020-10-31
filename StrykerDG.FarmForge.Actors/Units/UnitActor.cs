using Akka.Actor;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using StrykerDG.FarmForge.Actors.Crops;
using StrykerDG.FarmForge.Actors.Units.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.DataModel.Extensions;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Units
{
    public class UnitActor : FarmForgeActor
    {
        public UnitActor(IServiceScopeFactory factory) : base(factory)
        {
            Receive<AskForUnitTypes>(HandleAskForUnitTypes);
            Receive<AskToCreateUnitType>(HandleAskToCreateUnitType);
            Receive<AskToDeleteUnitType>(HandleAskToDeleteUnitType);
            Receive<AskForUnitConversions>(HandleAskForConversions);
            Receive<AskToCreateUnitConversion>(HandleAskToCreateUnitConversion);
            Receive<AskToUpdateUnitConversion>(HandleAskToUpdateUnitConversion);
            Receive<AskToDeleteUnitConversion>(HandleAskToDeleteUnitConversion);
        }

        // Message Methods
        private void HandleAskForUnitTypes(AskForUnitTypes message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.UnitTypes
                    .Where(u => u.IsDeleted == false)
                    .ToList();

                Sender.Tell(results);
            });
        }

        private void HandleAskToCreateUnitType(AskToCreateUnitType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    if (message.UnitType == null)
                        throw new Exception("Invalid Unit Type");

                    if (message.UnitType.UnitTypeId != 0)
                        throw new Exception("New Units can't have an Id specified");

                    if (message.UnitType.Name == null && message.UnitType.Label == null)
                        throw new Exception("Units must have a name or label specified");

                    if (message.UnitType.Name == null || message.UnitType.Name == string.Empty)
                        message.UnitType.Name = message.UnitType.Label.ToLower().Replace(" ", "_");

                    if (message.UnitType.Label == null || message.UnitType.Label == string.Empty)
                        message.UnitType.Label = message.UnitType.Name;

                    var existingUnitType = context.UnitTypes
                        .Where(u => u.Name == message.UnitType.Name)
                        .FirstOrDefault();

                    if (existingUnitType != null && existingUnitType.IsDeleted == false)
                        throw new Exception("Unit already exists");

                    else if (existingUnitType != null && existingUnitType.IsDeleted == true)
                        existingUnitType.IsDeleted = false;

                    else
                        existingUnitType = context.Add(message.UnitType).Entity;

                    context.SaveChanges();

                    Sender.Tell(existingUnitType);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskToDeleteUnitType(AskToDeleteUnitType message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var existingUnitType = context.UnitTypes
                        .Where(u =>
                            u.UnitTypeId == message.UnitTypeId &&
                            u.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingUnitType == null)
                        throw new Exception("UnitType does not exist");

                    // We can't delete if there are products or conversions are using the unit
                    var dependentProducts = context.Products
                        .AsNoTracking()
                        .Where(p =>
                            p.UnitTypeId == existingUnitType.UnitTypeId &&
                            p.IsDeleted == false
                        );

                    var dependentConversions = context.UnitTypeConversions
                        .AsNoTracking()
                        .Where(c =>
                            c.FromUnitId == existingUnitType.UnitTypeId ||
                            c.ToUnitId == existingUnitType.UnitTypeId
                        )
                        .FirstOrDefault();

                    if (dependentProducts != null || dependentConversions != null)
                        throw new Exception("Cannot delete unit type. In use by products and/or conversions");

                    existingUnitType.IsDeleted = true;

                    context.SaveChanges();
                    Sender.Tell(true);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskForConversions(AskForUnitConversions message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                var results = context.UnitTypeConversions
                    .WithIncludes("FromUnit,ToUnit")
                    .Where(c => c.IsDeleted == false)
                    .ToList();

                Sender.Tell(results);
            });
        }

        private void HandleAskToCreateUnitConversion(AskToCreateUnitConversion message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    if (message.Conversion == null || message.Conversion.UnitTypeConversionId != 0)
                        throw new Exception("Invalid Conversion Object");

                    if (message.Conversion.FromUnitId == 0 || message.Conversion.ToUnitId == 0)
                        throw new Exception("FromUnitId and ToUnitId must be specified");

                    if (message.Conversion.FromQuantity <= 0 || message.Conversion.ToQuantity <= 0)
                        throw new Exception("FromQuantity and ToQuantity must be positive integers");

                    var existingUnits = context.UnitTypes
                        .AsNoTracking()
                        .Where(u =>
                            u.UnitTypeId == message.Conversion.FromUnitId ||
                            u.UnitTypeId == message.Conversion.ToUnitId
                        )
                        .ToList();

                    if (existingUnits.Count != 2)
                        throw new Exception("Invalid UnitIds specified");

                    var existingConversion = context.UnitTypeConversions
                        .Where(c =>
                            c.FromUnitId == message.Conversion.FromUnitId &&
                            c.ToUnitId == message.Conversion.ToUnitId &&
                            c.FromQuantity == message.Conversion.FromQuantity &&
                            c.ToQuantity == message.Conversion.ToQuantity
                        )
                        .FirstOrDefault();

                    if (existingConversion != null && existingConversion.IsDeleted == false)
                        throw new Exception("Conversion already exists");

                    else if (existingConversion != null && existingConversion.IsDeleted == true)
                    {
                        existingConversion.IsDeleted = false;
                        UpdateUnitTypeConversionProperties(ref existingConversion, message.Conversion);
                    }

                    else
                    {
                        // Make sure we're not updating units
                        message.Conversion.FromUnit = null;
                        message.Conversion.ToUnit = null;

                        existingConversion = context.Add(message.Conversion).Entity;
                    }

                    context.SaveChanges();

                    // Return the entire object
                    var toUnit = existingUnits
                        .Where(u => u.UnitTypeId == message.Conversion.ToUnitId)
                        .FirstOrDefault();
                    var fromUnit = existingUnits
                        .Where(u => u.UnitTypeId == message.Conversion.FromUnitId)
                        .FirstOrDefault();

                    existingConversion.ToUnit = toUnit;
                    existingConversion.FromUnit = fromUnit;

                    Sender.Tell(existingConversion);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskToUpdateUnitConversion(AskToUpdateUnitConversion message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var existingConversion = context.UnitTypeConversions
                        .Where(c => c.UnitTypeConversionId == message.Conversion.UnitTypeConversionId)
                        .FirstOrDefault();

                    if (existingConversion == null)
                        throw new Exception("UnitTypeConversion not found");

                    var existingUnits = context.UnitTypes
                        .AsNoTracking()
                        .Where(u =>
                            u.UnitTypeId == message.Conversion.FromUnitId ||
                            u.UnitTypeId == message.Conversion.ToUnitId
                        )
                        .ToList();

                    if (existingUnits.Count != 2)
                        throw new Exception("Invalid UnitIds specified");

                    if (existingConversion.IsDeleted == true)
                        existingConversion.IsDeleted = false;

                    UpdateUnitTypeConversionProperties(ref existingConversion, message.Conversion);

                    context.SaveChanges();

                    // Return the entire object
                    var toUnit = existingUnits
                        .Where(u => u.UnitTypeId == message.Conversion.ToUnitId)
                        .FirstOrDefault();
                    var fromUnit = existingUnits
                        .Where(u => u.UnitTypeId == message.Conversion.FromUnitId)
                        .FirstOrDefault();

                    existingConversion.ToUnit = toUnit;
                    existingConversion.FromUnit = fromUnit;

                    Sender.Tell(existingConversion);
                }
                catch(Exception ex)
                {
                    Sender.Tell(ex);
                }
            });
        }

        private void HandleAskToDeleteUnitConversion(AskToDeleteUnitConversion message)
        {
            Using<FarmForgeDataContext>((context) =>
            {
                try
                {
                    var existingUnitTypeConversion = context.UnitTypeConversions
                        .Where(c =>
                            c.UnitTypeConversionId == message.UnitConversionId &&
                            c.IsDeleted == false
                        )
                        .FirstOrDefault();

                    if (existingUnitTypeConversion == null)
                        throw new Exception("Conversion does not exist");

                    existingUnitTypeConversion.IsDeleted = true;

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
        private void UpdateUnitTypeConversionProperties(
            ref UnitTypeConversion existingConversion,
            UnitTypeConversion newConversion
        )
        {
            var properties = newConversion.GetType().GetProperties();
            foreach (var property in properties)
            {
                var providedValue = newConversion
                    .GetType()
                    .GetProperty(property.Name)
                    .GetValue(newConversion, null);

                existingConversion
                    .GetType()
                    .GetProperty(property.Name)
                    .SetValue(existingConversion, providedValue);
            }
        }
    }
}
