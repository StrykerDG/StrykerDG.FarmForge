---
id: 'client'
title: 'Client'
sidebar_label: 'Client'
---

## Description

The FarmForge Client is written in [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) and provides the Farm Management aspect of FarmForge. It also 
provides a central area to view and manage all of your devices. The project 
structure is as follows:

- [models](#models): Provides a definition for FarmForge data models and DTOs that are used
by the client
- [provider](#providers): All provider / state management related files and definitions. CoreProvider are the core items used throughout the app, where as DataProvider is
where all of the data retrieved from the API is stored.
- [screens](#screens): All screens for the app. Each screen should have a main file that
utilizes a LayoutBuilder to display a small, medium, or large version of the 
content.
- [services](#services): Any services used by the client. Services will typically be utilized 
through CoreProvider
- [utilities](#utilities): Any utilities that store re-used logic throughout the app. Examples 
include settings, themes, and validation.
- [widgets](#widgets): Custom widgets that are utilized by the screens

## Dependencies

- [provider](https://pub.dev/packages/provider) for State Management
- [http](https://pub.dev/packages/http) for web requests
- [intl](https://pub.dev/packages/intl) for date formatting

## Models

Most of the models within the client are adaptations from the DataModel or API 
DTOs to make working with the data easier, and since dart is strongly typed. That 
being said, there are several client-specific models as well.

### FarmForgeResponse

FarmForgeResponse is represents responses from the FarmForge API, and all valid 
API responses should return as a FarmForgeResponse. If a request is successful,
the data field will be populated, and if there was a handled error, the error
field will be populated.

#### Properties

- data (dynamic): The data returned from an api query
- error (string): The error returned from an api query

#### Example

```
FarmForgeResponse result = await Provider.of<CoreProvider>(context, listen: false)
    .farmForgeService.getLocations();
```

### FarmForgeModel

FarmForgeModel is an interface that other FarmForge models (Crop, CropType, etc)
should extend if they are to be used in a generic or templated Widget. If a model
extends FarmForgeModel, that model's type should be added to _constructors map.

#### Properties 

- _constructors(Map<Type, Function>): Contains a map of constructors for each
type of FarmForgeModel

#### Methods

- Map<String, dynamic> toMap(): abstract method that is implemented in classes
that extend FarmForgeModel. Turns the Type T into a Map<String, dynamic>
- static FarmForgeModel create(Type T, Map<String, dynamic> data): Method that 
uses the _constructors map to create an object of type T from a given Map<String, dynamic>

#### Example

```
static final _constructors = {
    <TYPE>:(Map<String, dynamic> data) => <TYPE>.fromMap(data)
}

--- 

Crop c = FarmForgeModel.create(T, dataMaps.elementAt(index));
```

### FarmForgeDataTableColumn

FarmForgeDataTableColumns are a model that define columns for a given 
FarmForgeDataTable

#### Properties
- label (String): The label of the column
- property (String): The property displayed in the column, in dot notation
- propertyFunc (Function): A function that displays a widget in the column. Takes
precedence over property
- canSort (bool): specifies whether you can sort a column. Defaults to true
- canFilter (bool): specifies whether you can filter a column. Defaults to true
- canEdit (bool): specifies whether you can edit a property in line. Defaults to 
false

#### Example

```
List<FarmForgeDataTableColumn> generateColumns() {
    return [
        FarmForgeDataTableColumn(
            label: 'Type',
            property: 'CropType.Label'
        ),
        FarmForgeDataTableColumn(
            label: 'Variety',
            property: 'CropVariety.Label'
        ),
        FarmForgeDataTableColumn(
            label: 'Location',
            property: 'Location.Label'
        ),
    ];
}
```

### KpiModel

KpiModel is a generic model that is used for displaying data in charts.

#### Properties

- measure (String): The label of the KPI
- value (int): The value of the KPI

### Enums

Enums is a generic file that houses enumerations used within the FarmForge client.

#### InventoryAction
- A list of actions that can be performed on inventory

### MultiSelectOption

MultiSelectOption is provided to MultiSelectDialog do display an option that can
be selected by the user

#### Properties

- value (int): The value of the option, typically an items primary key
- label (string): The label that is shown to the user

## Providers

Providers are the state management for FarmForge.

### CoreProvider

CoreProvider contains the state of core components within the FarmForge client.
Services are initialized here as singletons.

#### Properties

- farmForgeService (FarmForgeApiService): The service that houses all api calls
- currentTheme (ThemeData): The currently selected theme for the app. Options are 
primaryTheme, lightTheme, and darkTheme
- appContent (Widget): The currently active Widget / content
- appTitle (String): The current area's title
- fabIcon (IconData): The icon of the area's FloatingActionButton
- fabAction (Function): The function that triggers when clicking the FloatingActionButton

#### Methods

- void toggleTheme(ThemeType type): Toggles the current theme of the app
- void setAppContent(Widget content, String title, IconData icon, Function action):
updates the currently active Widget / content


### DataProvider

DataProvider stores the data utilized in various areas of the FarmForge app.

#### Properties

- defaultDate (DateTime): Default "begin" date used for searching
- crops (List): List of Crops that have been planted 
- cropTypes (List): List of available CropTypes that you can plant
- cropClassifications (List): List of classifications that a crop can be
- inventory (List): List of products that are currently in inventory
- locations (List): List of available locations
- logTypes (List): List of available log types
- productTypes (List): List of available product types
- ProductCategories (List): List of available product categories
- statuses (List): List of available statuses
- suppliers (List): List of available suppliers
- unitTypes (List): List of available unit types
- unitTypeConversions (List): List of available unit type conversions
- users (List): List of available users

#### Methods

There are a variety of methods for clearing, setting, and updating the various
properties. Typically they're in the form setCrops(), updateCrop(), etc.

### UserProvider

The UserProvider stores information related to the currently logged in user

#### Properties

- username (String): The username of the currently logged in user

#### Methods

- void setUsername(String user): Sets the name of the currently logged in user

## Screens

Screens are the various areas that you can be in the app.

### Login

The login screen is the first screen you come to. The initial user on a fresh install is Admin / FarmForgeAdmin

### Dashboard

The dashboard is the home screen after logging in. This is where you will see a 
summary of your farm and statistics.

### Crops

From the crops page, you can plant new crops, update their status, create logs, and
view crop detils.

### Inventory
The inventory page allows you to view current inventory as well as add 
inventory, move inventory to different locations, consume inventory, and convert
inventory from one unit to another

### Settings

The settings page allows you to create and delete users, crops, crop types, and 
locations. You can also manage products, product types, units, unit conversions,
and suppliers

## Services

Services are utilized to interact with external providers

### FarmForgeApiService

The FarmForgeApiService is used to interact with the API.

#### Properties
- token (String): The jwt received from the API during login
- apiURL (String): the url of the FarmForge API

#### Methods
- Future request(String uri, dynamic body, String method): The common method used 
when making an api request. 

## Utilities

Utilities are a central place to store logic that is used throughout the app.

### Constants

Constants contains all of the constants used throughout the app. It has values 
for the following

- Device widths
- AppBar
- Colors
- Padding
- Width
- Radius
- Dialog
- Login Sizes
- Desktop Sizes
- Dividers
- ListView / Tables
- DatePickers

### Settings

Settings contains app-specific settings

#### Properties
- version (String): The version of the app
- developmentUrl (String): The API url for the development environment
- testUrl (String): The API url for the test environment
- productionUrl (String): The API url for the production environment

### Themes

Themes contains the various themes definitions for the app. There are currently 
3 themes

- primaryTheme
- lightTheme
- darkTheme

### Validation

Validation provides a number of validation methods that can be used for forms.

#### Methods

- static String isNotEmpty(dynamic value): checks whether the provided value is 
empty
- static String isNumeric(String value): checks whether the provided string is 
a numeric value
- static String isEmptyOrNumeric(dynamic value): checks whetehr the provided 
value is empty or numeric
- static String isValidDate(String value): checks whether the provided string is
a valid DateTime
- static String isValidDateRange(String value): checks whether the provided string contains valid DateTimes

### Utility

Utility is used to store common logic that doesn't nescessarily fit in a 
utility class of it's own.

#### Methods

- static Map<String, dynamic> parseJWT(String token): Parses the jwt and returns
the decoded string
- static String decodeBase64(String str): Decodes a base 64 string

### DateTimeUtility

DateTimeUtility houses all DateTime-related methods

#### Methods

- static String formateDateTimeRange(DateTimeRange dateRange): Formats a given 
DateTimeRange as "YYYY-MM-DD - YYYY-MM-DD"
- static String formatDateTime(DateTime date): Formats a given DateTime as 
"YYYY-MM-DD"
- static String formatShortDateTime(DateTime date): Formats a given DateTime as 
"MM/DD"

### UiUtility

UiUtility contains helper methods for displaying different UI components

#### Methods

- static handleError(BuildContext context, String title, String error): Uses 
the given title and error to display an error dialog

## Widgets

Widgets are the individual components that are used in various areas throughout 
the app. Within the widgits directory, there are subdirectories that contain 
the widgets used for that specific section. For example, you can find the 
widgets used in the Crop workarea by looking at widgets/crops/...

Common widgets are in the base widit directory

```
- lib
    - widgets
        - crops
            - crops widget a
            - crops widget b
        - settings
            - setting widget a
        - common widget a
        - common widget b
```

### FarmForgeDialog

FarmForgeDialog is a common dialog widget that can be utilized everywhere

#### Properties
- title (String): The title of the dialog
- content (Widget): The content that will be displayed in the dialog
- width (double): How wide the dialog should be

#### Example

```
  void handleAddVariety(int cropTypeId) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Variety',
        content: AddCropVarieity(cropTypeId: cropTypeId),
        width: kSmallDesktopModalWidth,
      )
    );
  }
```

### FarmForgeDataTable

FarmForgeDataTable is a generalized DataTable that has built in sorting and 
filtering. Clicking the column header once will sort based on that column, while
double clicking a column header will present a TextField which adds a filter to
that column

#### Properties

- data (List): A list of data to display. The list must be of a type that extends [FarmForgeModel](#FarmForgeModel)
- columns (List): A list of column definitions. The list must be of type 
[FarmForgeDataTableColumn](#FarmForgeDataTableColumn)
- onRowClick (Function): The callback method that should fire when selecting 
a row. The method should take two paramters: a boolean value, followed by a Map of type String, dynamic
- showCheckBoxes (bool): Specifies whether checkboxes should be shown on the 
data table. Defaults to false

#### Example

```
@override
Widget build(BuildContext context) {

    double dataTableHeight = 
        MediaQuery.of(context).size.height - kAppBarHeight - kSerachBarHeight;

    return Container(
        height: dataTableHeight,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FarmForgeDataTable<Crop>(
                columns: _columns,
                data: _crops,
                onRowClick: handleRowClick,
                showCheckBoxes: false,
            ),
        ),
    );
}
```

### DateRangePicker

DateRangePicker is a widget that displays a date range that you can change, in 
addition to a "search" button that will execute a callback function.

#### Properties

- initialDateRange (DateTimeRange): The initial date range to display
- onSearch (Function): The callback method that is executed when the search 
button is pressed. onSearch will receive a DateTimeRange as a parameter

#### Example

```
@override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.symmetric(vertical: kSmallPadding),
        child: DateRangePicker(
            initialDateRange: _dateSearchRange,
            onSearch: handleSearch,
        ),
    );
}
```

### KpiCard

KpiCards are components that display key performance indicators on the dashboard

#### Properties

- width (double): how wide the card is
- height (double): how high the card is
- title (String): The title of the KPI
- kpi (String): The value of the KPI to display

#### Example

```
@override
  Widget build(BuildContext context) {

    return KpiCard(
        width: kMediumCardWidth,
        height: kMediumCardHeight,
        title: 'Crops Planted',
        kpi: crops?.length?.toString() ?? "",
    );
}
```

### KpiChart

KpiCharts are similar to KpiCards, but show charted values instead of a text
value.

#### Properties

- width (double): the width of the card
- height (double): the height of the card
- title (String): the title of the KPI
- Data (List): the data that should be charted / displayed. The data should be 
a list of TYPE that extends KpiModel

#### Example

```
@override
  Widget build(BuildContext context) {

    return KpiChart(
        width: kLargeCardHeight,
        height: kLargeCardHeight,
        title: 'Crops By Location',
        data: cropsByLocation,
    );
}
```

### MultiSelectDialog

MultiSelectDialog is a widget that functions similar to a dropdown, but allows 
you to select multiple options.

#### Properties

- options (List): a list of MultiSelectOptions that specify what options will 
show up in the dialog
- defaultValues (List): a list of items that will be selected by default

#### Example

```
List<MultiSelectOption> _productTypeOptions = [
    _productTypes.map((t) =>
        MultiSelectOption(value: t.productTypeId, label: t.label)
    ).toList()
];

List<int> _selectedSupplierProducts = [];

void handleMultiSelectTap() async {
    List<int> results = await showDialog(
        context: context,
        builder: (context) => MultiSelectDialog(
            options: _productTypeOptions,
            defaultValues: _selectedSupplierProducts
        )
    );
}
```

### SettingsExpansionTile

SettingsExpansionTiles are used within the settings area to display an 
expandable tile containing related settings.

#### Properties

- title (String): The title displayed by the expansion tile
- content (Widget): The content that will be displayed once the tile has been
expanded

#### Example

```
@override
  Widget build(BuildContext context) {

    return SettingsExpansionTile(
        title: 'Crops',
        content: CropContent()
    );
}
```