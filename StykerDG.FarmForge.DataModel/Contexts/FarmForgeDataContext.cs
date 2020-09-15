using Microsoft.EntityFrameworkCore;
using StrykerDG.FarmForge.DataModel.Models;

namespace StrykerDG.FarmForge.DataModel.Contexts
{
    public class FarmForgeDataContext : DbContext
    {
        public FarmForgeDataContext() { }

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
    }
}
