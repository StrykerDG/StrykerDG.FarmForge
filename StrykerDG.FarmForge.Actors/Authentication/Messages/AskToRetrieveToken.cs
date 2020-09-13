using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Authentication.Messages
{
    public class AskToRetrieveToken
    {
        public string Token { get; private set; }

        public AskToRetrieveToken(string token)
        {
            Token = token;
        }
    }
}
