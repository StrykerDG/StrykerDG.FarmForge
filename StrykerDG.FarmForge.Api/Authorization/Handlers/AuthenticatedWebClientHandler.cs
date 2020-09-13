using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using StrykerDG.FarmForge.Actors.Authentication.Messages;
using StrykerDG.FarmForge.LocalApi.Authorization.Policies;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Authorization.Handlers
{
    public class AuthenticatedWebClientHandler : AuthorizationHandler<AuthenticatedWebClient>
    {
        private IHttpContextAccessor HttpContextAccessor { get; set; }
        private IActorRef AuthActor { get; set; }

        public AuthenticatedWebClientHandler(
            IHttpContextAccessor httpContextAccessor, 
            List<IActorRef> actorRefs
        )
        {
            HttpContextAccessor = httpContextAccessor;
            AuthActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("AuthenticationActor"))
                .FirstOrDefault();
        }

        protected override Task HandleRequirementAsync(
            AuthorizationHandlerContext context, 
            AuthenticatedWebClient requirement
        )
        {
            var httpContext = HttpContextAccessor.HttpContext;
            var token = httpContext.Request.Headers
                .Where(h => h.Key == "Authorization")
                .Select(h => h.Value.ToString())
                .FirstOrDefault();

            if (token == null)
                context.Fail();
            else
            {
                token = token.Replace("Bearer ", "");
                var tokenResult = AuthActor.Ask(new AskToRetrieveToken(token)).Result;
                var tokenResultType = tokenResult.GetType();
                if (tokenResultType == typeof(JwtSecurityToken))
                {
                    var typedToken = tokenResult as JwtSecurityToken;
                    var expirationClaim = typedToken.Claims
                        .Where(c => c.Type == "exp")
                        .Select(c => c.Value)
                        .FirstOrDefault();

                    if (expirationClaim == null)
                        context.Fail();
                    else
                    {
                        long.TryParse(expirationClaim, out var expiration);
                        var now = DateTimeOffset.Now.ToUnixTimeSeconds();

                        if (expiration > now)
                            context.Succeed(requirement);
                        else
                            context.Fail();
                    }
                }
                else
                    context.Fail();
            }

            return Task.CompletedTask;
        }
    }
}
