import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';

import 'package:farmforge_client/widgets/date_range_picker.dart';
import 'package:farmforge_client/widgets/farm_forge_data_table.dart';

import 'package:farmforge_client/utilities/constants.dart';

class LargeCrops extends StatefulWidget {
  final DateTime searchBegin;
  final DateTime searchEnd;
  final List<FarmForgeDataTableColumn> columns;
  final Function handleSearch;
  final Function onTap;

  LargeCrops({
    @required this.searchBegin, 
    this.searchEnd, 
    @required this.columns,
    @required this.handleSearch,
    @required this.onTap
  });

  @override
  _LargeCropsState createState() => _LargeCropsState();
}

class _LargeCropsState extends State<LargeCrops> {
  DateTimeRange _dateSearchRange;
  List<Crop> _crops = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dateSearchRange = DateTimeRange(
      start: widget.searchBegin,
      end: widget.searchEnd
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _crops = Provider.of<DataProvider>(context).crops;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double dataTableHeight = 
      MediaQuery.of(context).size.height - kAppBarHeight - kSerachBarHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.symmetric(vertical: kSmallPadding),
          child: DateRangePicker(
            initialDateRange: _dateSearchRange,
            onSearch: widget.handleSearch,
          ),
        ),

        Container(
          height: dataTableHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FarmForgeDataTable<Crop>(
              columns: widget.columns,
              data: _crops,
              onRowClick: widget.onTap,
              showCheckBoxes: false,
            ),
          ),
        )
      ],
    );
  }
}