using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.Actors.Extensions
{
    public static class StackExtensions
    {
        public static List<T> PopRange<T>(this Stack<T> stack, int quantity) 
        {
            var results = new List<T>();
            for(var i = 0; i < quantity; i++)
            {
                if (stack.TryPop(out var current))
                    results.Add(current);
                else
                    break;
            }

            return results;
        }
    }
}
