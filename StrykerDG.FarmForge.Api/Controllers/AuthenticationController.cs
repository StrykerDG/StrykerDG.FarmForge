using Akka.Actor;
using Akka.Util;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors;
using StrykerDG.FarmForge.Actors.Authentication.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Responses;
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

            var resultType = result.GetType();
            if(resultType == typeof(Exception) || resultType == typeof(UnauthorizedAccessException))
            {
                var ex = (Exception)result;
                return Ok(FarmForgeApiResponse.Failure(ex.Message));
            }
            else
                return Ok(FarmForgeApiResponse.Success(result));
        }
    }
}
