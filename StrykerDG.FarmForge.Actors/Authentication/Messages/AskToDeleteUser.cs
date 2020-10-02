using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Authentication.Messages
{
    public class AskToDeleteUser
    {
        public string Requestor { get; private set; }
        public int UserId { get; private set; }

        public AskToDeleteUser(int userId, string requestor)
        {
            UserId = userId;
            Requestor = requestor;
        }
    }
}
