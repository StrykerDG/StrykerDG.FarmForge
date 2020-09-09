using Akka.Actor;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors
{
    public class FarmForgeActor : ReceiveActor
    {
        protected IServiceScopeFactory ServiceScopeFactory { get; set; }
        
        public FarmForgeActor(IServiceScopeFactory factory)
        {
            ServiceScopeFactory = factory;
        }

        protected void Using<T>(Action<T> func) where T : IDisposable
        {
            using (var scope = ServiceScopeFactory.CreateScope())
            {
                using (var obj = scope.ServiceProvider.GetService<T>())
                {
                    func(obj);
                }
            }
        }
    }
}
