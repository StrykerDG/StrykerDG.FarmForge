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
    }
}
