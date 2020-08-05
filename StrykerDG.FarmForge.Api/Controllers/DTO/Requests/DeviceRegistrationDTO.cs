using StrykerDG.FarmForge.Actors.Devices.Messages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace StrykerDG.FarmForge.LocalApi.Controllers.DTO.Requests
{
    public class DeviceRegistrationDTO
    {
        public string DeviceName { get; set; }
        public string IpAddress { get; set; }
        public string SerialNumber { get; set; }
        public string SecurityToken { get; set; }
        public string InterfaceEndpoint { get; set; }
    }
}
