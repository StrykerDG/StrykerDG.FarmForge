using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Authentication.Messages
{
    public class AskToLogin
    {
        public string Username { get; private set; }
        public string Password { get; private set; }

        public AskToLogin(string user, string password) 
        {
            Username = user;
            Password = password;
        }
    }
}
