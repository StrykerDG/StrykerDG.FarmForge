import 'package:flutter/material.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class DateRangePicker extends StatefulWidget {
  final DateTimeRange initialDateRange;
  final Function onSearch;

  DateRangePicker({
    @required this.initialDateRange,
    this.onSearch
  });

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
    if(_formKey.currentState.validate() && widget.onSearch != null)
      widget.onSearch(_searchRange);
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
    return Padding(
      padding: EdgeInsets.all(kSmallPadding),
      child: Row(
        children: [
          Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: kWideInput,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.date_range)
                  ),
                  controller: _rangeController,
                  onTap: handleDateRangePicker,
                  validator: Validation.isValidDateRange,
                ),
              ),
            ),
          ),
          SizedBox(width: kSmallPadding),
          RaisedButton(
            child: Text('Search'),
            onPressed: handleSearch,
          )
        ],
      ),
    );
  }
}