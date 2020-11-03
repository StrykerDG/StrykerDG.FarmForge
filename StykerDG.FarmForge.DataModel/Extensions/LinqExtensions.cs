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
            var includeList = includes?.Split(",");

            if(includeList != null)
                foreach (var include in includeList)
                    table = table.Include(include);

            return table;
        }

        public static IEnumerable<T> DistinctBy<T, K>(
            this IEnumerable<T> source,
            Func<T, K> func
        ) where T : BaseModel
        {
            List<K> distinctKeys = new List<K>();
            List<T> distinctResults = new List<T>();

            foreach(T element in source)
            {
                var funcResult = func(element);
                if(typeof(K)  == typeof(int))
                {
                    if (!distinctKeys.Contains(funcResult))
                    {
                        distinctKeys.Add(funcResult);
                        distinctResults.Add(element);
                    }
                }

                else if(typeof(K) == typeof(bool))
                {
                    var stringBool = funcResult.ToString();
                    if (stringBool == "True")
                        distinctResults.Add(element);
                }
            }

            IEnumerable<T> results = distinctResults;
            return results;
        }
    }
}
