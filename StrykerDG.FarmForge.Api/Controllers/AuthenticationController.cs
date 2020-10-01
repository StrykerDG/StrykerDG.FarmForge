using Akka.Actor;
using Akka.Util;
using Microsoft.AspNetCore.Authorization;
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
    public class AuthenticationController : FarmForgeController
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

            return ValidateActorResult(result);
        }

        [HttpGet("Users")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> GetUsers()
        {
            var result = await AuthActor.Ask(new AskForUsers());
            return Ok(FarmForgeApiResponse.Success(result));
        }

        [HttpPost("Users")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> CreateUser([FromBody]LoginDTO user)
        {
            var result = await AuthActor.Ask(new AskToCreateUser(user.Username, user.Password));
            return ValidateActorResult(result);
        }

        [HttpDelete("Users/{userId}")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public async Task<IActionResult> DeleteUser(int userId)
        {
            var requestor = HttpContext.User.Claims
                .Where(c => c.Type == "User")
                .FirstOrDefault()
                ?.Value;

            var result = await AuthActor.Ask(new AskToDeleteUser(userId, requestor));
            return ValidateActorResult(result);
        }
    }
}
