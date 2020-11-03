---
id: 'setup'
title: 'Setup'
sidebar_label: 'Setup'
---

## Login

Once you have FarmForge installed and running, you should be able to reach the 
login screen. 

- Default User: Admin
- Default Password: FarmForgeAdmin

## Setting up users

We recommend changing the default Admin password after logging in for security reasons. 
You can do this by navigating to the Account section, and entering a new password. 
Make sure you remember what was entered as there is currently no "reset" or "forgot 
your password" option.

If you have multiple users that will be using the system, you can create accounts 
for them by navigating to the Settings area, and clicking the Users pannel. From 
there, click the "+" icon.

![Demo](/gif/AddUser.gif)

## Create Locations

After logging in, you will need to create Locations in order to start tracking 
your crops and inventory. You can structure them however you want, and Locations 
have the ability to be parented to other locations. For example, you can have 
something that looks like the following:

```
- Greenhouse 1
    - Row 1
        - Pot 1
        - Pot 2
        - Pot 3
    - Row 2
        - Pot 1
        - Pot 2
- Raised Bed 1
- Raised Bed 2
- Storage Room 1
```

To create a location, navigate to the Settings area, click on locations, and click 
the "+" icon

![Demo](/gif/AddLocation.gif)

To add a parent location, make sure the parent is created, then select the child 
location. You can then select which location is the parent.

![Demo](/gif/AddLocationParent.gif)

## Setting up Suppliers

In order to add inventory via the inventory screen, you must first create 
suppliers, and specify which products those suppliers provide. 

To create a new product type, navigate to the Settings area and click on 
Inventory. Then next to the Product Type, click the "+" icon.

![Demo](/gif/AddProductType.gif)

Now, click the "+" icon next to Supplier, and enter the required information

![Demo](/gif/AddSupplier.gif)

## Setting up Conversions

Before you can convert inventory from one unit to another, you must first 
create the individual units. Once the units have been created, you can create
a new conversion between the two

To create a unit, navigate to the Settings area and click on inventory. Next,
click on the "+" icon next to Unit Type

![Demo](/gif/AddUnitType.gif)

Next, click the "+" icon next to Unit Conversion and specify the required 
information

![Demo](/gif/AddUnitTypeConversion.gif)