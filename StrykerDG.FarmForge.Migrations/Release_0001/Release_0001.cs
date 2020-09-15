using FluentMigrator;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using StrykerDG.FarmForge.Migrations.Extensions;
using System;
using System.Security.Cryptography;

namespace StrykerDG.FarmForge.Migrations.Release_0001
{
    [Migration(0001)]
    public class Release_0001 : Migration
    {
        public override void Up()
        {
            // Generic Tables
            Create.Table("Status")
                .WithId("StatusId")
                .WithColumn("EntityType").AsString(255).NotNullable()
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithBaseModel();

            Create.Table("Log")
                .WithId("LogId")
                .WithColumn("TimeStamp").AsDateTime().NotNullable()
                .WithColumn("Message").AsString(int.MaxValue).Nullable()
                .WithColumn("Data").AsString(int.MaxValue).Nullable()
                .WithColumn("LogTypeId").AsInt32().NotNullable();

            Create.Table("LogType")
                .WithId("LogTypeId")
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithColumn("Description").AsString(255).NotNullable()
                .WithBaseModel();

            Create.Table("Location")
                .WithId("LocationId")
                .WithColumn("LocationParentId").AsInt32().Nullable()
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithBaseModel();

            // User Tables
            Create.Table("User")
                .WithId("UserId")
                .WithColumn("Username").AsString(255).NotNullable()
                .WithColumn("Password").AsString(int.MaxValue).NotNullable()
                .WithBaseModel();

            // Device Tables
            Create.Table("Device")
                .WithId("DeviceId")
                .WithColumn("Name").AsString(255).NotNullable()
                // 45 Characters to support IPv4-mapped IPv6 addresses
                // 0000:0000:0000:0000:0000:ffff:192.168.100.228
                .WithColumn("IpAddress").AsString(45).NotNullable()
                .WithColumn("SerialNumber").AsString(255).NotNullable()
                .WithColumn("SecurityToken").AsString(255).NotNullable()
                .WithColumn("StatusId").AsInt32().NotNullable()
                .WithBaseModel();

            Create.Table("Interface")
                .WithId("InterfaceId")
                .WithColumn("DeviceId").AsInt32().NotNullable()
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("SerialNumber").AsString(255).NotNullable()
                .WithColumn("InterfaceTypeId").AsInt32().NotNullable()
                .WithBaseModel();

            Create.Table("InterfaceType")
                .WithId("InterfaceTypeId")
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithColumn("ModelNumber").AsString(255).NotNullable()
                .WithColumn("ParentInterfaceTypeId").AsInt32().Nullable()
                .WithBaseModel();

            Create.Table("Telemetry")
                .WithId("TelemetryId")
                .WithColumn("InterfaceId").AsInt32().NotNullable()
                .WithColumn("TimeStamp").AsDateTime().NotNullable()
                .WithColumn("Value").AsDouble().Nullable()
                .WithColumn("StringValue").AsString(255).Nullable()
                .WithColumn("BoolValue").AsBoolean().Nullable()
                .WithBaseModel();

            // Crop Tables
            Create.Table("Crop")
                .WithId("CropId")
                .WithColumn("CropTypeId").AsInt32().NotNullable()
                .WithColumn("CropVarietyId").AsInt32().NotNullable()
                .WithColumn("LocationId").AsInt32().NotNullable()
                .WithColumn("StatusId").AsInt32().NotNullable()
                .WithColumn("PlantedAt").AsDateTime().NotNullable()
                .WithColumn("GerminatedAt").AsDateTime().Nullable()
                .WithColumn("HarvestedAt").AsDateTime().Nullable()
                .WithColumn("TimeToGerminate").AsInt64().Nullable()
                .WithColumn("TimeToHarvest").AsInt64().Nullable()
                .WithColumn("Quantity").AsInt32().NotNullable()
                .WithColumn("QuantityHarvested").AsInt32().Nullable()
                .WithColumn("Yield").AsDouble().Nullable()
                .WithBaseModel();

            Create.Table("CropType")
                .WithId("CropTypeId")
                .WithColumn("CropClassificationId").AsInt32().NotNullable()
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithColumn("AverageGermination").AsInt64().Nullable()
                .WithColumn("AverageTimeToHarvest").AsInt64().Nullable()
                .WithColumn("AverageYield").AsDouble().Nullable()
                .WithBaseModel();

            Create.Table("CropVariety")
                .WithId("CropVarietyId")
                .WithColumn("CropTypeId").AsInt32().NotNullable()
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithBaseModel();

            Create.Table("CropClassification")
                .WithId("CropClassificationId")
                .WithColumn("Name").AsString(255).NotNullable()
                .WithColumn("Label").AsString(255).NotNullable()
                .WithColumn("Description").AsString(255).NotNullable()
                .WithBaseModel();

            Create.Table("CropLog")
                .WithId("CropLogId")
                .WithColumn("CropId").AsInt32().NotNullable()
                .WithColumn("LogTypeId").AsInt32().NotNullable()
                .WithColumn("Notes").AsString(int.MaxValue).Nullable()
                .WithBaseModel();

            var now = DateTime.Now;

            // Generic Inserts
            Insert.IntoTable("Status")
                .Row(new
                {
                    EntityType = "Device.Status",
                    Name = "offline",
                    Label = "Offline",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Device.Status",
                    Name = "connected",
                    Label = "Connected",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "planted",
                    Label = "Planted",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "germinated",
                    Label = "Germinated",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "growing",
                    Label = "Growing",
                    Created = now,
                    Modified = now,
                    IsDeleted = false,
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "flowering",
                    Label = "Flowering",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "ripening",
                    Label = "Ripening",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "harvested",
                    Label = "Harvested",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    EntityType = "Crop.Status",
                    Name = "transplanted",
                    Label = "Transplanted",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                });

            // User Inserts
            var adminPassword = GenerateAdminPassword();
            Insert.IntoTable("User")
                .Row(new
                {
                    Username = "Admin",
                    Password = adminPassword,
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                });

            // Crop Inserts
            Insert.IntoTable("CropClassification")
                .Row(new
                {
                    Name = "fruit",
                    Label = "Fruit",
                    Description = "A Fruit",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    Name = "vegetable",
                    Label = "Vegetable",
                    Description = "A Vegetable",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    Name = "herb",
                    Label = "Herb",
                    Description = "An Herb",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    Name = "tree",
                    Label = "Tree",
                    Description = "A Tree",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                });
        }

        public override void Down()
        {
            // Generic Tables
            Delete.Table("Status");
            Delete.Table("Log");
            Delete.Table("LogType");
            Delete.Table("Location");

            // User Tables
            Delete.Table("User");

            // Device Tables
            Delete.Table("Device");
            Delete.Table("Interface");
            Delete.Table("InterfaceType");
            Delete.Table("Telemetry");

            // Crop Tables
            Delete.Table("Crop");
            Delete.Table("CropType");
            Delete.Table("CropVariety");
            Delete.Table("CropClassification");
            Delete.Table("CropLog");
        }

        private string GenerateAdminPassword()
        {
            // Generate salt
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);
            var pbkdf2 = KeyDerivation.Pbkdf2("FarmForgeAdmin", salt, KeyDerivationPrf.HMACSHA256, 10000, 20);

            // Combine the two 
            byte[] hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(pbkdf2, 0, hashBytes, 16, 20);

            var savedHash = Convert.ToBase64String(hashBytes);
            return savedHash;
        }
    }
}
