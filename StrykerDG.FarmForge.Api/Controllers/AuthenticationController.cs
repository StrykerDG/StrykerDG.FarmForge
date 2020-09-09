using Akka.Actor;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Authentication.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Auth")]
    public class AuthenticationController : ControllerBase
    {
        private IActorRef AuthActor { get; set; }

        public AuthenticationController(List<IActorRef> actorRefs)
        {
            AuthActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("AuthenticationActor"))
                .FirstOrDefault();
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login([FromBody]LoginDTO login)
        {
            if (login == null)
                return BadRequest("No login credentials present");

            var result = await AuthActor.Ask(new AskToLogin(login.Username, login.Password));
            return Ok(result);
        }
    }
}
