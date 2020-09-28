using EntityFrameworkCore.Triggers;
using StrykerDG.FarmForge.DataModel.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace StrykerDG.FarmForge.DataModel.Triggers
{
    public static class BaseTriggers<T> where T : BaseModel
    {
        public static void OnInserting(IInsertingEntry entry)
        {
            var entity = (BaseModel)entry.Entity;
            var now = DateTime.Now;

            SetCreated(entity, now);
            SetModified(entity, now);
            SetIsDeleted(entity);
        }

        public static void OnUpdating(IUpdatingEntry entry)
        {
            var entity = (BaseModel)entry.Entity;
            var now = DateTime.Now;

            SetModified(entity, now);
        }

        public static void SetCreated(BaseModel entity, DateTime now)
        {
            entity.Created = now;
        }

        public static void SetModified(BaseModel entity, DateTime now)
        {
            entity.Modified = now;
        }

        public static void SetIsDeleted(BaseModel entity)
        {
            entity.IsDeleted = false;
        }
    }
}
