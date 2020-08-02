using FluentMigrator;
using StrykerDG.FarmForge.Migrations.Extensions;

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
        }

        public override void Down()
        {
            Delete.Table("Device");
            Delete.Table("Interface");
            Delete.Table("InterfaceType");
            Delete.Table("Telemetry");
        }
    }
}
