using Microsoft.EntityFrameworkCore;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Extensions
{
    public static class LinqExtensions
    {
        public static IQueryable<T> WithIncludes<T>(
            this IQueryable<T> table, 
            string includes
        ) where T : BaseModel
        {
            var includeList = includes.Split(",");

            foreach (var include in includeList)
                table.Include(include);

            return table;
        }
    }
}
