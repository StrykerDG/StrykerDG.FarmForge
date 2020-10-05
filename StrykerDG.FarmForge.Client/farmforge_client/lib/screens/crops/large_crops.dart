import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/crops/add_crop_log.dart';
import 'package:farmforge_client/widgets/crops/view_crop.dart';
import 'package:farmforge_client/widgets/date_range_picker.dart';
import 'package:farmforge_client/widgets/farm_forge_data_table.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class LargeCrops extends StatefulWidget {
  final DateTime searchBegin;
  final DateTime searchEnd;

  LargeCrops({@required this.searchBegin, this.searchEnd});

  @override
  _LargeCropsState createState() => _LargeCropsState();
}

class _LargeCropsState extends State<LargeCrops> {
  DateTimeRange _dateSearchRange;
  List<Crop> _crops = [];
  List<FarmForgeDataTableColumn> _columns;
  TextEditingController _searchController = TextEditingController();

  void handleSearch(DateTimeRange range) async {
    try {
      FarmForgeResponse searchResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getCrops(
          begin: range.start,
          end: range.end,
          includes: 'CropType,CropVariety,Location,Status,Logs.LogType'
        );

      if(searchResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .setCrops(searchResponse.data);
      }
      else
        throw searchResponse.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Search Error', 
        error: e.toString()
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _dateSearchRange = DateTimeRange(
      start: widget.searchBegin,
      end: widget.searchEnd
    );
    _columns = generateColumns();
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

  void handleAddLog(Crop crop) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add ${crop.cropType.label} Log',
        content: AddCropLog(crop: crop),
        width: kSmallDesktopModalWidth,
      ),
    );
  }

  void handleRowClick(bool value, Crop crop) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: '${crop.cropType.label} - ${crop.cropVariety.label}',
        content: ViewCrop(crop: crop),
        width: kSmallDesktopModalWidth,
      ),
    );
  }

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
      FarmForgeDataTableColumn(
        label: 'Status',
        property: 'Status.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Quantity',
        property: 'Quantity'
      ),
      FarmForgeDataTableColumn(
        label: 'PlantedAt',
        propertyFunc: (Crop c) =>
          Text(
            DateFormat.yMd().format(c?.plantedAt) ?? ""
          )
      ),
      FarmForgeDataTableColumn(
        label: '',
        propertyFunc: (Crop c) => 
          IconButton(
            icon: Icon(Icons.note),
              onPressed: () { handleAddLog(c); },
          )
      ),
    ];
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
            onSearch: handleSearch,
          ),
        ),

        Container(
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
        )
      ],
    );
  }
}