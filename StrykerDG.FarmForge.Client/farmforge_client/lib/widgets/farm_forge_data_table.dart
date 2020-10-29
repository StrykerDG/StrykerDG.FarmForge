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
  final Function onSelectChange;

  FarmForgeDataTable({
    @required this.data, 
    @required this.columns, 
    this.onRowClick,
    this.showCheckBoxes = false,
    this.onSelectChange
  });

  @override
  _FarmForgeDataTableState<T> createState() => _FarmForgeDataTableState<T>();
}

class _FarmForgeDataTableState<T extends FarmForgeModel> extends State<FarmForgeDataTable<T>> {
  TextEditingController _filterController = TextEditingController();
  FocusNode _filterNode = FocusNode();
  int _filteringColumn;
  List<String> _filters;
  List<bool> _selected = [];

  int _sortedColumn;
  SortType _sortType = SortType.None;

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

    setState(() {
      _sortedColumn = sortedColumn;
      _sortType = sortType;
    });
  }

  List<T> filterAndSortData() {
    // Generate a list of maps so we can filter and sort based on column properties
    List<Map<String, dynamic>> dataMaps = List<Map<String, dynamic>>();
    widget.data.forEach((element) {
      dataMaps.add(element.toMap());
    });

    // Iterate through all columns and apply filters / sorting
    widget.columns.asMap().forEach((index, columnDef) {
      // We only filter and sort if a property is defined
      if(columnDef.property != null && columnDef.propertyFunc == null) {
        String filter = _filters.elementAt(index);
        List<String> propertyPath = columnDef.property.split('.');

        List<Map<String, dynamic>> filteredDataMaps = List<Map<String, dynamic>>();
        // Filter the data based on this column's filter
        if(filter.isNotEmpty) {
          print('not empty! $filter!');
          dataMaps.forEach((dataMap) { 
            dynamic property = dataMap;
            propertyPath.forEach((element) { 
              if(property != null && property[element] != null)
                property = property[element];
            });

            if(property.toString().toLowerCase().contains(filter.toLowerCase()))
              filteredDataMaps.add(dataMap);
          });

          dataMaps = filteredDataMaps;
        }

        // See if we need to sort, since we can only sort one column at a time
        if(_sortedColumn == index) {
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

              return aProperty.toString().compareTo(bProperty.toString());
            }
          );

          if(_sortType == SortType.Desc)
            dataMaps = dataMaps.reversed.toList();
        }
      }
    });

    // Now that we've filtered and sorted, re-create the actual list of objects
    List<T> filteredAndSortedData = List<T>.generate(
      dataMaps.length, 
      (index) => FarmForgeModel.create(T, dataMaps.elementAt(index))
    );

    return filteredAndSortedData;
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
      setState(() {
        _filters[_filteringColumn] = _filterController.text;
        _filteringColumn = null;
        _filterController.text = "";
      });
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

  List<DataRow> buildRows(List<T> filteredAndSortedData) {
    List<DataRow> rows = List<DataRow>();

    filteredAndSortedData.asMap().forEach((index, dataObject) { 
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

            cellContent = Text(
              property,
              overflow: TextOverflow.ellipsis,
            );
          }

          return DataCell(cellContent);
        }
      );

      // Add the actual row
      rows.add(
        DataRow(
          cells: rowCells,
          selected: _selected.length > 0
            ? _selected[index]
            : false,
          onSelectChanged: (bool value) {
            if(widget.showCheckBoxes) {
              setState(() {
                _selected[index] = value;
              });
              if(widget.onSelectChange != null)
                widget.onSelectChange(value, index);
            }

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

    _selected = List<bool>.generate(
      widget.data?.length, 
      (index) => false
    );

    // Populate the list of empty filters
    _filters = new List<String>();
    widget.columns.forEach((columnDef) { 
      _filters.add("");
    });

    _filterNode.addListener(onFocusChange);
  }

  @override
  void didUpdateWidget(covariant FarmForgeDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.data.length != _selected.length) {
      setState(() {
        _selected = List<bool>.generate(
          widget.data?.length, 
          (index) => false
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    List<T> filteredAndSortedData = filterAndSortData();

    return DataTable(
      columns: buildColumns(),
      rows: buildRows(filteredAndSortedData),
      showCheckboxColumn: widget.showCheckBoxes,
      sortAscending: _sortType == SortType.Asc
        ? true
        : false,
      sortColumnIndex: _sortedColumn,
    );
  }
}