using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Authentication
{
    public class AuthenticationSettings
    {
        public string SecretKey { get; set; }
        public string Issuer { get; set; }
        public string Audience { get; set; }
    }
}
