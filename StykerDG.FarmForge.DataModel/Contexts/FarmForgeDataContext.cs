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
        }
    }
}
