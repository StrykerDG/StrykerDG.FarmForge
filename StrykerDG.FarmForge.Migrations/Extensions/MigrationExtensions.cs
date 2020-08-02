using FluentMigrator.Builders.Create.Table;

namespace StrykerDG.FarmForge.Migrations.Extensions
{
    public static class MigrationExtensions
    {
        public static ICreateTableColumnOptionOrWithColumnSyntax WithId(
            this ICreateTableWithColumnSyntax table,
            string columnName
        )
        {
            return table
                .WithColumn(columnName)
                .AsInt32()
                .NotNullable()
                .PrimaryKey()
                .Identity();
        }

        public static ICreateTableColumnOptionOrWithColumnSyntax WithBaseModel(
            this ICreateTableWithColumnSyntax table
        )
        {
            return table
                .WithColumn("Created").AsDateTime().NotNullable()
                .WithColumn("Modified").AsDateTime().Nullable()
                .WithColumn("IsDeleted").AsBoolean().NotNullable();
        }
    }
}
