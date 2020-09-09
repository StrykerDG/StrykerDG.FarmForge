using Microsoft.EntityFrameworkCore;
using StrykerDG.FarmForge.DataModel.Models;

namespace StrykerDG.FarmForge.DataModel.Contexts
{
    public class FarmForgeDataContext : DbContext
    {
        public FarmForgeDataContext() { }

        public FarmForgeDataContext(DbContextOptions<FarmForgeDataContext> options) : base(options) { }

        public DbSet<Device> Devices { get; set; }
        public DbSet<Interface> Interfaces { get; set; }
        public DbSet<InterfaceType> InterfaceTypes { get; set; }
        public DbSet<Telemetry> Telemetry { get; set; }
        public DbSet<Status> Statuses { get; set; }
        public DbSet<Log> Logs { get; set; }
        public DbSet<User> Users { get; set; }
    }
}
