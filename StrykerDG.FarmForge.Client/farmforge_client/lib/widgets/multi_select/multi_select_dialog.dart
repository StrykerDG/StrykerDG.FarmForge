import 'package:flutter/material.dart';

import 'package:farmforge_client/widgets/multi_select/multi_select_options.dart';

import 'package:farmforge_client/utilities/constants.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<MultiSelectOption> options;
  final List<int> defaultValues;

  MultiSelectDialog({
    @required this.options,
    this.defaultValues = const []
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<bool> _selectedOptions = [];

  void handleCheckboxChange(bool value, int index) {
    setState(() {
      _selectedOptions[index] = value;
    });
  }

  void handleCancel() {
    Navigator.of(context).pop();
  }

  void handleOk() {
    List<int> selectedOptions = [];
    _selectedOptions.asMap().forEach((index, value) { 
      if(value)
        selectedOptions.add(
          widget.options.elementAt(index).value
        );
    });

    Navigator.pop(context, selectedOptions);
  }

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<bool>.generate(
      widget.options.length, 
      (index) { 
        MultiSelectOption currentOption = widget.options.elementAt(index);
        return widget.defaultValues.contains(currentOption.value)
          ? true
          : false;
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    double maxHeight = MediaQuery.of(context).size.height;
    maxHeight = maxHeight - kLargePadding - kRowHeight;

    double listHeight = widget.options.length * kRowHeight;
    if(listHeight > maxHeight)
      listHeight = maxHeight;

    double modalHeight = listHeight + kRowHeight;

    return Dialog(
      child: Container(
        width: kNarrowModalWidth,
        height: modalHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: listHeight,
              child: ListView.builder(
                itemCount: widget.options.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Checkbox(
                      value: _selectedOptions[index],
                      onChanged: (bool value) { 
                        handleCheckboxChange(value, index);
                      },
                    ),
                    title: Text(widget.options.elementAt(index).label),
                    onTap: () {
                      handleCheckboxChange(!_selectedOptions[index], index);
                    },
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  onPressed: handleCancel, 
                  child: Text('Cancel')
                ),
                FlatButton(
                  onPressed: handleOk, 
                  child: Text('OK')
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}