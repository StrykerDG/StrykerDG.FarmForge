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
                .WithColumn("Data").AsString(int.MaxValue).Nullable();

            Create.Table("User")
                .WithId("UserId")
                .WithColumn("Username").AsString(255).NotNullable()
                .WithColumn("Password").AsString(int.MaxValue).NotNullable()
                .WithBaseModel();

            var now = DateTime.Now;

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
                });

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
        }

        public override void Down()
        {
            Delete.Table("Device");
            Delete.Table("Interface");
            Delete.Table("InterfaceType");
            Delete.Table("Telemetry");
            Delete.Table("Status");
            Delete.Table("Log");
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
