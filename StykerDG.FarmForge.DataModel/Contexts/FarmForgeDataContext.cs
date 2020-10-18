using EntityFrameworkCore.Triggers;
using Microsoft.EntityFrameworkCore;
using StrykerDG.FarmForge.DataModel.Models;
using StrykerDG.FarmForge.DataModel.Triggers;

namespace StrykerDG.FarmForge.DataModel.Contexts
{
    public class FarmForgeDataContext : DbContextWithTriggers
    {
        public FarmForgeDataContext(DbContextOptions<FarmForgeDataContext> options) : base(options) { }

        // General
        public DbSet<Location> Locations { get; set; }
        public DbSet<Log> Logs { get; set; }
        public DbSet<LogType> LogTypes { get; set; }
        public DbSet<Status> Statuses { get; set; }
        public DbSet<User> Users { get; set; }

        // Devices
        public DbSet<Device> Devices { get; set; }
        public DbSet<Interface> Interfaces { get; set; }
        public DbSet<InterfaceType> InterfaceTypes { get; set; }
        public DbSet<Telemetry> Telemetry { get; set; }

        // Crops
        public DbSet<Crop> Crops { get; set; }
        public DbSet<CropClassification> CropClassifications { get; set; }
        public DbSet<CropLog> CropLogs { get; set; }
        public DbSet<CropType> CropTypes { get; set; }
        public DbSet<CropVariety> CropVarieties { get; set; }

        // Inventory & Sales
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<ProductCategory> ProductCategories { get; set; }
        public DbSet<ProductDestination> ProductDestinations { get; set; }
        public DbSet<ProductSource> ProductSources { get; set; }
        public DbSet<ProductType> ProductTypes { get; set; }
        public DbSet<Supplier> Suppliers { get; set; }
        public DbSet<SupplierProductTypeMap> SupplierProductTypeMaps { get; set; }
        public DbSet<UnitType> UnitTypes { get; set; }
        public DbSet<UnitTypeConversion> UnitTypeConversions { get; set; }

        public static void SetTriggers()
        {
            SetBaseTriggers();
        }

        private static void SetBaseTriggers()
        {
            // TODO: Simplify this so we don't have an ever expanding list
            Triggers<Location>.Inserting += BaseTriggers<Location>.OnInserting;
            Triggers<Location>.Updating += BaseTriggers<Location>.OnUpdating;

            Triggers<Log>.Inserting += BaseTriggers<Log>.OnInserting;
            Triggers<Log>.Updating += BaseTriggers<Log>.OnUpdating;

            Triggers<LogType>.Inserting += BaseTriggers<LogType>.OnInserting;
            Triggers<LogType>.Updating += BaseTriggers<LogType>.OnUpdating;

            Triggers<Status>.Inserting += BaseTriggers<Status>.OnInserting;
            Triggers<Status>.Updating += BaseTriggers<Status>.OnUpdating;

            Triggers<User>.Inserting += BaseTriggers<User>.OnInserting;
            Triggers<User>.Updating += BaseTriggers<User>.OnUpdating;

            Triggers<Device>.Inserting += BaseTriggers<Device>.OnInserting;
            Triggers<Device>.Updating += BaseTriggers<Device>.OnUpdating;

            Triggers<Interface>.Inserting += BaseTriggers<Interface>.OnInserting;
            Triggers<Interface>.Updating += BaseTriggers<Interface>.OnUpdating;

            Triggers<InterfaceType>.Inserting += BaseTriggers<InterfaceType>.OnInserting;
            Triggers<InterfaceType>.Updating += BaseTriggers<InterfaceType>.OnUpdating;

            Triggers<Telemetry>.Inserting += BaseTriggers<Telemetry>.OnInserting;
            Triggers<Telemetry>.Updating += BaseTriggers<Telemetry>.OnUpdating;

            Triggers<Crop>.Inserting += BaseTriggers<Crop>.OnInserting;
            Triggers<Crop>.Updating += BaseTriggers<Crop>.OnUpdating;

            Triggers<CropClassification>.Inserting += BaseTriggers<CropClassification>.OnInserting;
            Triggers<CropClassification>.Updating += BaseTriggers<CropClassification>.OnUpdating;

            Triggers<CropLog>.Inserting += BaseTriggers<CropLog>.OnInserting;
            Triggers<CropLog>.Updating += BaseTriggers<CropLog>.OnUpdating;

            Triggers<CropType>.Inserting += BaseTriggers<CropType>.OnInserting;
            Triggers<CropType>.Updating += BaseTriggers<CropType>.OnUpdating;

            Triggers<CropVariety>.Inserting += BaseTriggers<CropVariety>.OnInserting;
            Triggers<CropVariety>.Updating += BaseTriggers<CropVariety>.OnUpdating;

            Triggers<Customer>.Inserting += BaseTriggers<Customer>.OnInserting;
            Triggers<Customer>.Updating += BaseTriggers<Customer>.OnUpdating;

            Triggers<Order>.Inserting += BaseTriggers<Order>.OnInserting;
            Triggers<Order>.Updating += BaseTriggers<Order>.OnUpdating;

            Triggers<Payment>.Inserting += BaseTriggers<Payment>.OnInserting;
            Triggers<Payment>.Updating += BaseTriggers<Payment>.OnUpdating;

            Triggers<Product>.Inserting += BaseTriggers<Product>.OnInserting;
            Triggers<Product>.Updating += BaseTriggers<Product>.OnUpdating;

            Triggers<ProductCategory>.Inserting += BaseTriggers<ProductCategory>.OnInserting;
            Triggers<ProductCategory>.Updating += BaseTriggers<ProductCategory>.OnUpdating;

            Triggers<ProductDestination>.Inserting += BaseTriggers<ProductDestination>.OnInserting;
            Triggers<ProductDestination>.Updating += BaseTriggers<ProductDestination>.OnUpdating;

            Triggers<ProductSource>.Inserting += BaseTriggers<ProductSource>.OnInserting;
            Triggers<ProductSource>.Updating += BaseTriggers<ProductSource>.OnUpdating;

            Triggers<ProductType>.Inserting += BaseTriggers<ProductType>.OnInserting;
            Triggers<ProductType>.Updating += BaseTriggers<ProductType>.OnUpdating;

            Triggers<Supplier>.Inserting += BaseTriggers<Supplier>.OnInserting;
            Triggers<Supplier>.Updating += BaseTriggers<Supplier>.OnUpdating;

            Triggers<SupplierProductTypeMap>.Inserting += BaseTriggers<SupplierProductTypeMap>.OnInserting;
            Triggers<SupplierProductTypeMap>.Updating += BaseTriggers<SupplierProductTypeMap>.OnUpdating;

            Triggers<UnitType>.Inserting += BaseTriggers<UnitType>.OnInserting;
            Triggers<UnitType>.Updating += BaseTriggers<UnitType>.OnUpdating;

            Triggers<UnitTypeConversion>.Inserting += BaseTriggers<UnitTypeConversion>.OnInserting;
            Triggers<UnitTypeConversion>.Updating += BaseTriggers<UnitTypeConversion>.OnUpdating;
        }
    }
}