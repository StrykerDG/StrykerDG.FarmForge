import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';
import 'package:flutter/material.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';
import 'package:provider/provider.dart';

class DateRangePicker extends StatefulWidget {
  final DateTimeRange initialDateRange;

  DateRangePicker({@required this.initialDateRange});

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTimeRange _searchRange;
  TextEditingController _rangeController = TextEditingController();

  void handleDateRangePicker() async {
    final DateTimeRange chosenRange = await showDateRangePicker(
      context: context, 
      firstDate: DateTime(kFirstDateYear, kFirstDateMonth),
      lastDate: DateTime(kLastDateYear, kLastDateMonth)
    );

    try {
      final String formattedDateRange = DateTimeUtility
        .formatDateTimeRange(chosenRange);

      setState(() {
        _rangeController.text = formattedDateRange;
        _searchRange = chosenRange;
      });
    }
    catch(e) {}
  }

  void handleSearch() async {
    if(_formKey.currentState.validate()) {
      try {
        FarmForgeResponse searchResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .getCrops(
            begin: _searchRange.start,
            end: _searchRange.end,
            includes: 'CropType,CropVariety,Location,Status,Logs.LogType'
          );

        if(searchResponse.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .setCrops(searchResponse.data);

          Navigator.pop(context, _searchRange);
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
  }

  @override
  void initState() {
    super.initState();

    _searchRange = widget.initialDateRange;
    _rangeController.text = DateTimeUtility.formatDateTimeRange(
      widget.initialDateRange
    );
  }

  @override
  void dispose() {
    _rangeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: kStandardInput,
              child: TextFormField(
                controller: _rangeController,
                onTap: handleDateRangePicker,
                validator: Validation.isValidDateRange,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(),
            ),
            RaisedButton(
              child: Text('Search'),
              onPressed: handleSearch,
            ),
          ],
        )
      ],
    );
  }
}