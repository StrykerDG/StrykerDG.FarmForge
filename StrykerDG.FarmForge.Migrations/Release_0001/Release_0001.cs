using FluentMigrator;
using FluentMigrator.SqlServer;
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

            var cropClassificationIncrementer = new AutoIncrementer();
            var fruitId = cropClassificationIncrementer.Get();
            var vegetableId = cropClassificationIncrementer.Get();
            var herbId = cropClassificationIncrementer.Get();
            var grainId = cropClassificationIncrementer.Get();
            var treeId = cropClassificationIncrementer.Get();

            // Crop Inserts
            Insert.IntoTable("CropClassification")
                .WithIdentityInsert()
                .Row(new
                {
                    CropClassificationId = fruitId,
                    Name = "fruit",
                    Label = "Fruit",
                    Description = "A Fruit",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    CropClassificationId = vegetableId,
                    Name = "vegetable",
                    Label = "Vegetable",
                    Description = "A Vegetable",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    CropClassificationId = herbId,
                    Name = "herb",
                    Label = "Herb",
                    Description = "An Herb",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                })
                .Row(new
                {
                    CropClassificationid = grainId,
                    Name = "grain",
                    Label = "Grain",
                    Description = "A Grain",
                    Created = now,
                    Modified = now, 
                    IsDeleted = false
                })
                .Row(new
                {
                    CropClassificationId = treeId,
                    Name = "tree",
                    Label = "Tree",
                    Description = "A Tree",
                    Created = now,
                    Modified = now,
                    IsDeleted = false
                });

            var cropTypeIncrementer = new AutoIncrementer();
            var appleId = cropTypeIncrementer.Get();
            var banannaId = cropTypeIncrementer.Get();
            var blackberryId = cropTypeIncrementer.Get();
            var blueberryId = cropTypeIncrementer.Get();
            var cherryId = cropTypeIncrementer.Get();
            var grapeId = cropTypeIncrementer.Get();
            var peachId = cropTypeIncrementer.Get();
            var raspberryId = cropTypeIncrementer.Get();
            var strawberryId = cropTypeIncrementer.Get();
            var watermelonId = cropTypeIncrementer.Get();
            var cantaloupeId = cropTypeIncrementer.Get();
            var tomatoeId = cropTypeIncrementer.Get();

            var beetId = cropTypeIncrementer.Get();
            var broccoliId = cropTypeIncrementer.Get();
            var cabbageId = cropTypeIncrementer.Get();
            var carrotId = cropTypeIncrementer.Get();
            var cauliflowerId = cropTypeIncrementer.Get();
            var celeryId = cropTypeIncrementer.Get();
            var collardId = cropTypeIncrementer.Get();
            var mustardId = cropTypeIncrementer.Get();
            var turnipId = cropTypeIncrementer.Get();
            var cornId = cropTypeIncrementer.Get();
            var yellowSquashId = cropTypeIncrementer.Get();
            var zuchinniId = cropTypeIncrementer.Get();
            var cucumberId = cropTypeIncrementer.Get();
            var eggplantId = cropTypeIncrementer.Get();
            var kaleId = cropTypeIncrementer.Get();
            var iceburgLettuceId = cropTypeIncrementer.Get();
            var romainLettuceId = cropTypeIncrementer.Get();
            var mushroomId = cropTypeIncrementer.Get();
            var okraId = cropTypeIncrementer.Get();
            var redOnionId = cropTypeIncrementer.Get();
            var yellowOnionId = cropTypeIncrementer.Get();
            var whiteOnionId = cropTypeIncrementer.Get();
            var redPepperId = cropTypeIncrementer.Get();
            var greenPepperId = cropTypeIncrementer.Get();
            var redPotatoId = cropTypeIncrementer.Get();
            var yellowPotatoId = cropTypeIncrementer.Get();
            var whitePotatoId = cropTypeIncrementer.Get();
            var pumpkinId = cropTypeIncrementer.Get();
            var radishId = cropTypeIncrementer.Get();
            var spaghettiSquashId = cropTypeIncrementer.Get();
            var acornSquashId = cropTypeIncrementer.Get();
            var butternutSquashId = cropTypeIncrementer.Get();
            var spinachId = cropTypeIncrementer.Get();
            var sweetPotatoId = cropTypeIncrementer.Get();

            var gingerId = cropTypeIncrementer.Get();
            var oreganoId = cropTypeIncrementer.Get();
            var thymeId = cropTypeIncrementer.Get();
            var basilId = cropTypeIncrementer.Get();
            var sageId = cropTypeIncrementer.Get();
            var arugulaId = cropTypeIncrementer.Get();
            var cilantroId = cropTypeIncrementer.Get();
            var lavenderId = cropTypeIncrementer.Get();
            var parsleyId = cropTypeIncrementer.Get();
            var rosemaryId = cropTypeIncrementer.Get();
            var mintId = cropTypeIncrementer.Get();
            var peppermintId = cropTypeIncrementer.Get();
            var lemonbalmId = cropTypeIncrementer.Get();
            var chivesId = cropTypeIncrementer.Get();
            var dillId = cropTypeIncrementer.Get();

            var wheatId = cropTypeIncrementer.Get();
            var oatsId = cropTypeIncrementer.Get();
            var barleyId = cropTypeIncrementer.Get();
            var ryeIdId = cropTypeIncrementer.Get();
            var amaranthId = cropTypeIncrementer.Get();
            var quinoaId = cropTypeIncrementer.Get();

            Insert.IntoTable("CropType")
                .WithIdentityInsert()
                .Row(new { CropTypeId = appleId, CropClassificationId = fruitId, Name = "apple", Label = "Apple", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = banannaId, CropClassificationId = fruitId, Name = "bananna", Label = "Bananna", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = blackberryId, CropClassificationId = fruitId, Name = "blackberry", Label = "Blackberry", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = blueberryId, CropClassificationId = fruitId, Name = "blueberry", Label = "Blueberry", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cherryId, CropClassificationId = fruitId, Name = "cherry", Label = "Cherry", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = grapeId, CropClassificationId = fruitId, Name = "grape", Label = "Grape", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = peachId, CropClassificationId = fruitId, Name = "peach", Label = "PeachId", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = raspberryId, CropClassificationId = fruitId, Name = "raspberry", Label = "Raspberry", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = strawberryId, CropClassificationId = fruitId, Name = "strawberry", Label = "Strawberry", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = watermelonId, CropClassificationId = fruitId, Name = "watermelon", Label = "Watermelon", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cantaloupeId, CropClassificationId = fruitId, Name = "cataloupe", Label = "Cantaloupe", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = tomatoeId, CropClassificationId = fruitId, Name = "tomatoe", Label = "Tomatoe", Created = now, Modified = now, IsDeleted = false })

                .Row(new { CropTypeId = beetId, CropClassificationId = vegetableId, Name = "beet", Label = "Beet", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = broccoliId, CropClassificationId = vegetableId, Name = "broccoli", Label = "Broccoli", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cabbageId, CropClassificationId = vegetableId, Name = "cabbage", Label = "Cabbage", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = carrotId, CropClassificationId = vegetableId, Name = "carrot", Label = "Carrot", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cauliflowerId, CropClassificationId = vegetableId, Name = "cauliflower", Label = "Cauliflower", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = celeryId, CropClassificationId = vegetableId, Name = "celery", Label = "Celery", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = collardId, CropClassificationId = vegetableId, Name = "collard", Label = "Collard", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = mustardId, CropClassificationId = vegetableId, Name = "mustard", Label = "Mustard", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = turnipId, CropClassificationId = vegetableId, Name = "turnip", Label = "Turnip", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cornId, CropClassificationId = vegetableId, Name = "corn", Label = "Corn", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = yellowSquashId, CropClassificationId = vegetableId, Name = "yellow_squash", Label = "Yellow Squash", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = zuchinniId, CropClassificationId = vegetableId, Name = "zuchinni", Label = "Zuchinni", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cucumberId, CropClassificationId = vegetableId, Name = "cucumber", Label = "Cucumber", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = eggplantId, CropClassificationId = vegetableId, Name = "eggplant", Label = "Eggplant", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = kaleId, CropClassificationId = vegetableId, Name = "kale", Label = "Kale", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = iceburgLettuceId, CropClassificationId = vegetableId, Name = "iceburg_lettuce", Label = "Iceburg Lettuce", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = romainLettuceId, CropClassificationId = vegetableId, Name = "romain_lettuce", Label = "Romain Lettuce", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = mushroomId, CropClassificationId = vegetableId, Name = "mushroom", Label = "Mushroom", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = okraId, CropClassificationId = vegetableId, Name = "okra", Label = "Okra", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = redOnionId, CropClassificationId = vegetableId, Name = "red_onion", Label = "Red Onion", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = yellowOnionId, CropClassificationId = vegetableId, Name = "yellow_onion", Label = "Yellow Onion", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = whiteOnionId, CropClassificationId = vegetableId, Name = "white_onion", Label = "White Onion", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = redPepperId, CropClassificationId = vegetableId, Name = "red_pepper", Label = "Red Pepper", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = greenPepperId, CropClassificationId = vegetableId, Name = "green_pepper", Label = "Green Pepper", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = redPotatoId, CropClassificationId = vegetableId, Name = "red_potato", Label = "Red Potato", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = yellowPotatoId, CropClassificationId = vegetableId, Name = "yellow_potato", Label = "Yello Potato", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = whitePotatoId, CropClassificationId = vegetableId, Name = "white_potato", Label = "White Potato", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = pumpkinId, CropClassificationId = vegetableId, Name = "pumpkin", Label = "Pumpkin", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = radishId, CropClassificationId = vegetableId, Name = "radish", Label = "Radish", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = spaghettiSquashId, CropClassificationId = vegetableId, Name = "spaghetti_squash", Label = "Spaghetti Squash", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = acornSquashId, CropClassificationId = vegetableId, Name = "acorn_squash", Label = "Acorn Squash", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = butternutSquashId, CropClassificationId = vegetableId, Name = "butternut_sqush", Label = "Butternut Squash", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = spinachId, CropClassificationId = vegetableId, Name = "spinach", Label = "Spinach", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = sweetPotatoId, CropClassificationId = vegetableId, Name = "sweet_potato", Label = "Sweet Potato", Created = now, Modified = now, IsDeleted = false })

                .Row(new { CropTypeId = gingerId, CropClassificationId = herbId, Name = "ginger", Label = "Ginger", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = oreganoId, CropClassificationId = herbId, Name = "oregano", Label = "Oregano", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = thymeId, CropClassificationId = herbId, Name = "thyme", Label = "Thyme", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = basilId, CropClassificationId = herbId, Name = "basil", Label = "Basil", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = sageId, CropClassificationId = herbId, Name = "sage", Label = "Sage", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = arugulaId, CropClassificationId = herbId, Name = "arugula", Label = "Arugula", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cilantroId, CropClassificationId = herbId, Name = "cilantro", Label = "Cilantro", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = lavenderId, CropClassificationId = herbId, Name = "lavender", Label = "Lavender", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = parsleyId, CropClassificationId = herbId, Name = "parsley", Label = "Parsley", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = rosemaryId, CropClassificationId = herbId, Name = "rosemary", Label = "Rosemary", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = mintId, CropClassificationId = herbId, Name = "mint", Label = "Mint", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = peppermintId, CropClassificationId = herbId, Name = "peppermint", Label = "Peppermint", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = lemonbalmId, CropClassificationId = herbId, Name = "lemonbalm", Label = "Lemonbalm", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = chivesId, CropClassificationId = herbId, Name = "chive", Label = "Chive", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = dillId, CropClassificationId = herbId, Name = "dill", Label = "Dill", Created = now, Modified = now, IsDeleted = false })

                .Row(new { CropTypeId = wheatId, CropClassificationId = grainId, Name = "wheat", Label = "Wheat", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = oatsId, CropClassificationId = grainId, Name = "oats", Label = "Oats", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = barleyId, CropClassificationId = grainId, Name = "barley", Label = "Barley", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = ryeIdId, CropClassificationId = grainId, Name = "rye", Label = "Rye", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = amaranthId, CropClassificationId = grainId, Name = "amaranth", Label = "Amaranth", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = quinoaId, CropClassificationId = grainId, Name = "quinoa", Label = "Quinoa", Created = now, Modified = now, IsDeleted = false });

            Insert.IntoTable("CropVariety")
                .Row(new { CropTypeId = appleId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = banannaId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = blackberryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = blueberryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cherryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = grapeId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = peachId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = raspberryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = strawberryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = watermelonId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cantaloupeId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = tomatoeId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })

                .Row(new { CropTypeId = beetId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = broccoliId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cabbageId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = carrotId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cauliflowerId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = celeryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = collardId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = mustardId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = turnipId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cornId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = yellowSquashId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = zuchinniId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cucumberId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = eggplantId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = kaleId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = iceburgLettuceId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = romainLettuceId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = mushroomId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = okraId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = redOnionId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = yellowOnionId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = whiteOnionId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = redPepperId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = greenPepperId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = redPotatoId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = yellowPotatoId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = whitePotatoId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = pumpkinId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = radishId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = spaghettiSquashId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = acornSquashId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = butternutSquashId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = spinachId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = sweetPotatoId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })

                .Row(new { CropTypeId = gingerId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = oreganoId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = thymeId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = basilId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = sageId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = arugulaId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = cilantroId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = lavenderId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = parsleyId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = rosemaryId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = mintId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = peppermintId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = lemonbalmId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = chivesId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = dillId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })

                .Row(new { CropTypeId = wheatId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = oatsId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = barleyId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = ryeIdId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = amaranthId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false })
                .Row(new { CropTypeId = quinoaId, Name = "generic", Label = "Generic", Created = now, Modified = now, IsDeleted = false });
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
