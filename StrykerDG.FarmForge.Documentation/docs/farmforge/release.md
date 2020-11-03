---
id: 'release'
title: 'Release Notes'
sidebar_label: 'Release Notes'
---

## v0.1.0 (MVP) - 10/12/2020
The MVP became available on October 12, 2020 and was the first pre-release.

### Features
- Ability to create and delete Users
- Ability to create and delete Locations
- Ability to create and delete Crop Types and Crop Varieties
- Ability to create Crops, and log information related to them
    - Tracks status (planted, growing, flowering, harvested, etc)
    - Tracks observations, inputs, and harvests
    - Tracks average time to germination, time to harvest, and yield
- Suport for SQLite and SQL

### Bug Fixes
- N/A

### Known Issues
- Cannot sort / filter Crops by date

## v0.2.0 (Inventory Management) - 11/4/2020
Inventory Management became available on November 4, 2020 and was the second 
pre-release

### Features
- Ability to create, modify, and delete suppliers
- Ability to create and delete units
- Ability to create, modify, and delete unit conversions
- Ability to manage inventory
    - Harvesting a crop adds inventory to the same location as the crop
    - Tracks inventory status (inventory, consumed, sold)
    - Ability to create inventory, transfer from one location to another, and
    convert from one unit to another
- Refreshing the screen after logging in does not require you to log in again

### Bug Fixes
- Crops can now be sorted / filtered by date

### Known Issues
- N/A