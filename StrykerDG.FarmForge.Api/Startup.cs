using Akka.Actor;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using StrykerDG.FarmForge.Actors.Devices;
using StrykerDG.FarmForge.Actors.WebSockets;
using StrykerDG.FarmForge.Actors.WebSockets.Messages;
using StrykerDG.FarmForge.DataModel.Contexts;
using StrykerDG.FarmForge.LocalApi.Configuration;
using System;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.Api
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        IActorRef DeviceActor { get; set; }
        IActorRef WebSocketActor { get; set; }

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
                WebSocketActor = actorSystem.ActorOf(Props.Create(() => new WebSocketActor(serviceScopeFactory)), "WebSocketActor");

                return actorSystem;
            });

            // Access Actors via Dependency Injection
            services.AddSingleton(_ => DeviceActor);
            services.AddSingleton(_ => WebSocketActor);

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

            app.UseWebSockets();
            app.Use(async (context, next) =>
            {
                if(context.Request.Path == "/ws" && context.WebSockets.IsWebSocketRequest)
                {
                    var webSocket = await context.WebSockets.AcceptWebSocketAsync();
                    await HandleWebSocket(webSocket);
                }
                else
                    await next();
            });

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

        private async Task HandleWebSocket(WebSocket webSocket)
        {
            var token = CancellationToken.None;
            var buffer = new ArraySegment<byte>(new byte[4096]);
            var received = await webSocket.ReceiveAsync(buffer, token);
            
            switch(received.MessageType)
            {
                case WebSocketMessageType.Text:
                    var request = Encoding.UTF8.GetString(buffer.Array, buffer.Offset, buffer.Count);
                    try
                    {
                        var message = JsonConvert
                            .DeserializeObject<AskToHandleWebSocketRequest>(request);
                        var askResult = await WebSocketActor.Ask(message);
                        var response = JsonConvert.SerializeObject(askResult);
                        var responseData = Encoding.UTF8.GetBytes(response);
                        buffer = new ArraySegment<byte>(responseData);
                        await webSocket.SendAsync(buffer, WebSocketMessageType.Text, true, token);
                    }
                    catch(Exception ex)
                    {
                        var responseData = Encoding.UTF8.GetBytes(ex.Message);
                        buffer = new ArraySegment<byte>(responseData);
                        await webSocket.SendAsync(buffer, WebSocketMessageType.Text, true, token);
                    }
                    break;
            }
        }
    }
}
