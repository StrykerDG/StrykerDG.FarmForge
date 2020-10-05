import 'package:flutter/material.dart';

import 'package:farmforge_client/models/farm_forge_data_table_column.dart';
import 'package:farmforge_client/models/farm_forge_model.dart';

import 'package:farmforge_client/utilities/constants.dart';

enum SortType {
  None,
  Asc,
  Desc
}

class FarmForgeDataTable<T extends FarmForgeModel> extends StatefulWidget {

  final List<dynamic> data;
  final List<FarmForgeDataTableColumn> columns;
  final Function onRowClick;
  final bool showCheckBoxes;

  FarmForgeDataTable({
    @required this.data, 
    @required this.columns, 
    this.onRowClick,
    this.showCheckBoxes = false
  });

  @override
  _FarmForgeDataTableState<T> createState() => _FarmForgeDataTableState<T>();
}

class _FarmForgeDataTableState<T extends FarmForgeModel> extends State<FarmForgeDataTable<T>> {
  TextEditingController _filterController = TextEditingController();
  FocusNode _filterNode = FocusNode();
  int _filteringColumn;
  List<String> _filters;

  int _sortedColumn;
  SortType _sortType = SortType.None;

  List<T> _data;

  void sortColumn(int columnIndex) {
    SortType sortType;
    int sortedColumn = columnIndex;

    if(_sortedColumn == null || _sortedColumn != columnIndex)
      sortType = SortType.Asc;
    else if(_sortType == SortType.None)
      sortType = SortType.Asc;
    else if(_sortType == SortType.Asc)
      sortType = SortType.Desc;
    else {
      sortType = SortType.None;
      sortedColumn = null;
    }

    FarmForgeDataTableColumn columnDef = widget.columns[columnIndex];
    List<String> propertyPath = columnDef.property.split('.');

    // Generate a List of maps so we can sort based on the column's property
    List<Map<String, dynamic>> dataMaps = List<Map<String, dynamic>>();
    _data.forEach((element) {
      dataMaps.add(element.toMap());
    });

    // Iterate through the maps and actually sort
    dataMaps.sort(
      (a, b) {
        dynamic aProperty = a;
        dynamic bProperty = b;
        propertyPath.forEach((element) { 
          if(aProperty != null && aProperty[element] != null)
            aProperty = aProperty[element];
          if(bProperty != null && bProperty[element] != null)
            bProperty = bProperty[element];
        });

        // print('comparing ${aProperty.toString()} to ${bProperty.toString()}');
        return aProperty.toString().compareTo(bProperty.toString());
      }
    );

    // Now rebuild the objects
    List<T> newData = List<T>.generate(
      dataMaps.length, 
      (index) => FarmForgeModel.create(T, dataMaps.elementAt(index))
    );

    if(sortType == SortType.Desc)
      newData = newData.reversed.toList();

    setState(() {
      _sortedColumn = sortedColumn;
      _sortType = sortType;
      _data = newData;
    });
  }

  void filterColumns(int columnIndex) {
    FarmForgeDataTableColumn columnDef = widget.columns[columnIndex];
    List<String> propertyPath = columnDef.property.split('.');
    
    String filter = _filters.elementAt(columnIndex);

    if(filter.isEmpty)
      setState(() {
        _data = widget.data;
      });

    else {
      // Generate a List of maps so we can filter based on the column's property
      List<Map<String, dynamic>> dataMaps = List<Map<String, dynamic>>();
      _data.forEach((element) {
        dataMaps.add(element.toMap());
      });

      // Iterate through the maps and actually filter
      List<T> newData = List<T>();

      dataMaps.forEach((dataMap) { 
        dynamic property = dataMap;
        propertyPath.forEach((element) { 
          if(property != null && property[element] != null)
            property = property[element];
        });

        if(property.toString().toLowerCase().contains(filter.toLowerCase()))
          newData.add(FarmForgeModel.create(T, dataMap));
      });

      setState(() {
        _data = newData;
      });
    }
  }

  void enableFilter(int columnIndex) {
    setState(() {
      _filteringColumn = columnIndex;
      _filterController.text = _filters.elementAt(columnIndex);
    });

    _filterNode.requestFocus();
  }

  void onFocusChange() {
    if(!_filterNode.hasFocus) {
      int tempIndex = _filteringColumn;

      setState(() {
        _filters[_filteringColumn] = _filterController.text;
        _filteringColumn = null;
        _filterController.text = "";
      });

      filterColumns(tempIndex);
    }
  }

  List<DataColumn> buildColumns() {
    List<DataColumn> columns = List.generate(
      widget.columns.length, 
      (index) {
        FarmForgeDataTableColumn columnDef = widget.columns[index];
        Widget sortIcon = Container();
        Widget filterIcon = Container();

        if(_sortedColumn == index && _sortType == SortType.Asc)
          sortIcon = Icon(Icons.arrow_upward);
        if(_sortedColumn == index && _sortType == SortType.Desc)
          sortIcon = Icon(Icons.arrow_downward);

        if(_filters.elementAt(index).isNotEmpty)
          filterIcon = Icon(Icons.filter_list);

        // Display a textfield if filtering, or the tappable column label
        // if not
        Widget columnHeader = GestureDetector(
          child: Row(
            children: [
              Text(columnDef.label),
              sortIcon,
              filterIcon
            ]
          ),
          onTap: () {
            sortColumn(index);
          },
          onDoubleTap: () {
            enableFilter(index);
          }
        );

        // If filtering, display a TextField instead of the columnHeader
        if(_filteringColumn == index) {
          columnHeader = Container(
            width: kNarrowInput,
            child: TextField(
              controller: _filterController,
              focusNode: _filterNode,
              autofocus: true,
            ),
          );
        }

        return DataColumn(
          label: columnHeader
        );
      }
    );

    return columns;
  }

  List<DataRow> buildRows() {
    List<DataRow> rows = List<DataRow>();

    _data.forEach((dataObject) { 
      // Build the data for the row
      List<DataCell> rowCells = List.generate(
        widget.columns.length, 
        (index) {
          FarmForgeDataTableColumn columnDef = widget.columns[index];
          Widget cellContent;
          
          // Display using the user-defined property function if it exists
          if(columnDef.propertyFunc != null)
            cellContent = columnDef.propertyFunc(dataObject);
          
          // Otherwise display the string version of whatever property is
          // being specified
          else {
            List<String> propertyPath = columnDef.property.split('.');
            Map<String, dynamic> dataObjectMap = dataObject?.toMap();
            dynamic currentProperty = dataObjectMap;
            propertyPath.forEach((element) {
              if(currentProperty != null && currentProperty[element] != null)
                currentProperty = currentProperty[element];
            });
            String property = currentProperty.toString();

            cellContent = Text(property);
          }

          return DataCell(cellContent);
        }
      );

      // Add the actual row
      rows.add(
        DataRow(
          cells: rowCells,
          onSelectChanged: (bool value) {
            if(widget.onRowClick != null)
              widget.onRowClick(value, dataObject);
          }
        )
      );
    });

    return rows;
  }

  @override
  void initState() {
    super.initState();

    _data = widget.data;

    // Populate the list of empty filters
    _filters = new List<String>();
    widget.columns.forEach((columnDef) { 
      _filters.add("");
    });

    _filterNode.addListener(onFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _data = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return DataTable(
      columns: buildColumns(),
      rows: buildRows(),
      showCheckboxColumn: widget.showCheckBoxes,
      sortAscending: _sortType == SortType.Asc
        ? true
        : false,
      sortColumnIndex: _sortedColumn,
    );
  }
}