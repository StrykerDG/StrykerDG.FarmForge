using System;
using FluentMigrator.Runner;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using StrykerDG.FarmForge.LocalApi.Configuration;
using StrykerDG.FarmForge.Migrations.Release_0001;

namespace StrykerDG.FarmForge.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            // Get the appsettings connection string
            var config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", optional: false)
                .Build();

            var settings = new ApiSettings();
            config.GetSection("ApiSettings").Bind(settings);

            var serviceProvider = CreateServices(
                settings.ConnectionStrings["Database"]);

            using (var scope = serviceProvider.CreateScope())
            {
                UpdateDatabase(scope.ServiceProvider);
            }

            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });

        public static IServiceProvider CreateServices(string connectionString)
        {
            return new ServiceCollection()
                .AddFluentMigratorCore()
                .ConfigureRunner(rb =>
                    rb.AddSQLite()
                    .WithGlobalConnectionString(connectionString)
                    .ScanIn(typeof(Release_0001).Assembly).For
                    .Migrations()
                )
                .AddLogging(lb => lb.AddFluentMigratorConsole())
                .BuildServiceProvider(false);
        }

        public static void UpdateDatabase(IServiceProvider serviceProvider)
        {
            var runner = serviceProvider.GetRequiredService<IMigrationRunner>();
            runner.MigrateUp();
        }
    }
}
