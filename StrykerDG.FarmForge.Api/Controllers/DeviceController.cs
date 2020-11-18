using Akka.Actor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StrykerDG.FarmForge.Actors.Devices.Messages;
using StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers
{
    [ApiController]
    [Route("Device")]
    public class DeviceController : FarmForgeController
    {
        private IActorRef DeviceActor { get; set; }

        public DeviceController(List<IActorRef> actorRefs)
        {
            DeviceActor = actorRefs
                .Where(ar => ar.Path.ToString().Contains("DeviceActor"))
                .FirstOrDefault();
        }

        [HttpGet]
        public IActionResult TestOne()
        {
            return Ok(true);
        }

        [HttpGet("Test")]
        [Authorize(Policy = "AuthenticatedWebClient")]
        public IActionResult TestTwo()
        {
            return Ok(true);
        }

        // TODO: Add Authorization
        [HttpPost]
        [Route("Register")]
        public async Task<IActionResult> RegisterDevice([FromBody]DeviceRegistrationDTO registrationRequest)
        {
            await DeviceActor.Ask(
                new AskToRegisterDevice(
                    registrationRequest.DeviceName,
                    registrationRequest.IpAddress,
                    registrationRequest.SerialNumber,
                    registrationRequest.SecurityToken,
                    registrationRequest.InterfaceEndpoint
                ),
                TimeSpan.FromSeconds(15)
            );

            // TODO: Create standard api response object
            return Ok();
        }
    }
}
