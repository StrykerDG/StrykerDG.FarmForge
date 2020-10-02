using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Authentication.Messages
{
    public class AskToCreateUser
    {
        public string Username { get; private set; }
        public string Password { get; private set; }

        public AskToCreateUser(string username, string password)
        {
            Username = username;
            Password = password;
        }
    }
}
