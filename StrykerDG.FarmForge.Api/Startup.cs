using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.LocalApi.Configuration;

namespace StrykerDG.FarmForge.Api
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

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

            services.AddControllers();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
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
        }
    }
}
