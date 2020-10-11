---
id: 'migrations'
title: 'Migrations'
sidebar_label: 'Migrations'
---

## Introduction

Migrations in FarmForge are created using [FluentMigrator](https://fluentmigrator.github.io/index.html) and take place when the FarmForge API 
starts.

The code that runs the migration is in Program.cs of the Api project, and within
the CreateServices Method

```
public static IServiceProvider CreateServices(ApiSettings settings)
{
    return new ServiceCollection()
        .AddFluentMigratorCore()
        .ConfigureRunner(rb =>
        {
            if (settings.DatabaseType == DatabaseType.SQLITE)
                rb.AddSQLite()
                .WithGlobalConnectionString(settings.ConnectionStrin["Database"])
                .ScanIn(typeof(Release_0001).Assembly).For
                .Migrations();

            else if (settings.DatabaseType == DatabaseType.SQLSERVER)
                rb.AddSqlServer()
                .WithGlobalConnectionString(settings.ConnectionStrin["Database"])
                .ScanIn(typeof(Release_0001).Assembly).For
                .Migrations();
        })
        .AddLogging(lb => lb.AddFluentMigratorConsole())
        .BuildServiceProvider(false);
}
```

This checks to see if the Lastest migration has been applied and, if not, apply it.

Each migration will be within the Migrations project, and has the name "Release_XXXX.cs" Where XXXX is the release number

## Migration Structure

Each migration has two methods. First is the Up() method, and the second is the Down() method.

### Up()

Up occurs when migrating forward from one version to another. The general order of operations is:

1. Create any new tables
2. Insert any new data
3. Perform any nescessary scripts

#### Example
```
public override void Up() 
{
    Create.Table("Demo")
        .WithId("DemoId")
        .WithColumn("DemoData").AsString(255).NotNullable()
        .WithBaseModel();

    Insert.IntoTable("Demo")
        .Row(new 
        {
            DemoData = "Demo"
        });
}
```

### Down()

Down occurs when migrating back, to one version from another. The Down method must undo everything that was done in the Up method.

1. Revert any script changes
2. Remove any new data
3. Delete any new tables

#### Example
```
public override void Down() 
{
    Delete.Table("Demo");
}
```