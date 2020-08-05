using System;
using System.Collections.Generic;
using System.Net;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Devices.Messages
{
    public class AskToRegisterDevice
    {
        public string DeviceName { get; private set; }
        public string IpAddress { get; private set; }
        public string SerialNumber { get; private set; }
        public string SecurityToken { get; private set; }
        public string InterfaceEndpoint { get; private set; }

        public AskToRegisterDevice(
            string deviceName,
            string ipAddress,
            string serialNumber,
            string securityToken,
            string interfaceEndpoint
        )
        {
            DeviceName = deviceName;
            IpAddress = ipAddress;
            SerialNumber = serialNumber;
            SecurityToken = securityToken;
            InterfaceEndpoint = interfaceEndpoint;
        }
    }
}
