using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Suppliers.Messages
{
    public class AskForSuppliers
    {
        public string Includes { get; private set; }

        public AskForSuppliers(string includes)
        {
            Includes = includes;
        }
    }
}
