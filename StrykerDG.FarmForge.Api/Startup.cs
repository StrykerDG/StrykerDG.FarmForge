using Akka.Actor;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using StrykerDG.FarmForge.Actors.Devices;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.LocalApi.Configuration;

namespace StrykerDG.FarmForge.Api
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        IActorRef DeviceActor { get; set; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            var settings = new ApiSettings();
            Configuration.GetSection("ApiSettings").Bind(settings);

            // Allow DI for Settings
            services.Configure<ApiSettings>(Configuration.GetSection("ApiSettings"));

            // Add versioning
            services.AddApiVersioning(config =>
            {
                config.DefaultApiVersion = new ApiVersion(settings.MajorVersion, settings.MinorVersion);
                config.AssumeDefaultVersionWhenUnspecified = true;
                config.ReportApiVersions = true;
            });

            // Register swagger services
            services.AddOpenApiDocument(config =>
            {
                config.PostProcess = document =>
                {
                    document.Info.Version = $"{settings.MajorVersion}.{settings.MinorVersion}";
                    document.Info.Title = settings.SwaggerSettings.Title;
                    document.Info.Description = settings.SwaggerSettings.Description;
                    document.Info.TermsOfService = settings.SwaggerSettings.TermsOfService;
                    document.Info.Contact = new NSwag.OpenApiContact
                    {
                        Name = settings.SwaggerSettings.ContactName,
                        Email = settings.SwaggerSettings.ContactEmail,
                        Url = settings.SwaggerSettings.ContactURL
                    };
                    document.Info.License = new NSwag.OpenApiLicense
                    {
                        Name = settings.SwaggerSettings.LicenseName,
                        Url = settings.SwaggerSettings.LicenseURL
                    };
                };
            });

            // Add the DbContext
            services.AddDbContext<FarmForgeDataContext>(options => options.UseSqlite(settings.ConnectionStrings["Database"]));

            // Add Akka.net
            services.AddSingleton((serviceProvider) =>
            {
                // Create the actor system
                var actorSystem = ActorSystem.Create("FarmForge");

                // Register the actors
                var serviceScopeFactory = serviceProvider.GetService<IServiceScopeFactory>();
                DeviceActor = actorSystem.ActorOf(Props.Create(() => new DeviceActor(serviceScopeFactory)), "DeviceActor");

                return actorSystem;
            });

            // Access Actors via Dependency Injection
            services.AddSingleton(_ => DeviceActor);

            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IHostApplicationLifetime lifetime)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseOpenApi();
            app.UseSwaggerUi3();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            lifetime.ApplicationStarted.Register(() =>
            {
                // Start Akka.net
                app.ApplicationServices.GetService<ActorSystem>();
            });

            lifetime.ApplicationStopping.Register(() =>
            {
                // Stop Akka.net
                app.ApplicationServices.GetService<ActorSystem>().Terminate().Wait();
            });
        }
    }
}
