import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';
import 'package:farmforge_client/models/inventory/unit_type_conversion.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/validation.dart';

class AddUnitConversion extends StatefulWidget {
  final UnitTypeConversion conversion;

  AddUnitConversion({this.conversion});

  @override
  _AddUnitConversionState createState() => _AddUnitConversionState();
}

class _AddUnitConversionState extends State<AddUnitConversion> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<UnitType> _unitTypes = [];
  List<DropdownMenuItem<int>> _unitOptions = [];
  int _selectedToUnit;
  int _selectedFromUnit;
  TextEditingController _toQuantityController = TextEditingController();
  TextEditingController _fromQuantityController = TextEditingController();

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        UnitTypeConversion newConversion = UnitTypeConversion(
          unitTypeConversionId: widget.conversion?.unitTypeConversionId ?? 0,
          fromUnitId: _selectedFromUnit,
          fromQuantity: int.parse(_fromQuantityController.text),
          toUnitId: _selectedToUnit,
          toQuantity: int.parse(_toQuantityController.text)
        );

        String method = widget.conversion == null
          ? 'POST'
          : 'PATCH';

        FarmForgeResponse addResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .createOrUpdateUnitConversion(newConversion, method);

        if(addResponse.data != null) {
          if(widget.conversion == null)
            Provider.of<DataProvider>(context, listen: false)
              .addUnitTypeConversion(addResponse.data);
          else
            Provider.of<DataProvider>(context, listen: false)
              .updateUnitTypeConversion(addResponse.data);

          Navigator.pop(context);
        }
        else
          throw addResponse.error;
      }
      catch(e) {
        UiUtility.handleError(
          context: context, 
          title: 'Save Error', 
          error: e.toString()
        );
      }
    }
  }

  void handleFromChange(int newValue) {
    setState(() {
      _selectedFromUnit = newValue;
    });
  }

  void handleToChange(int newValue) {
    setState(() {
      _selectedToUnit = newValue;
    });
  }
  
  @override
  void initState() {
    super.initState();

    if(widget.conversion != null) {
      setState(() {
        _selectedFromUnit = widget.conversion.fromUnitId;
        _fromQuantityController.text = widget.conversion.fromQuantity.toString();
        _selectedToUnit = widget.conversion.toUnitId;
        _toQuantityController.text = widget.conversion.toQuantity.toString();
      });
    }
  }

  @override
  void dispose() {
    _toQuantityController.dispose();
    _fromQuantityController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _unitTypes = Provider.of<DataProvider>(context).unitTypes;

      _unitOptions = _unitTypes.map((unit) => 
        DropdownMenuItem<int>(
          value: unit.unitTypeId,
          child: Text(unit.label),
        )
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _fromQuantityController,
                  decoration: InputDecoration(
                    labelText: 'From Quantity'
                  ),
                  validator: Validation.isNumeric,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: DropdownButtonFormField<int>(
                  value: _selectedFromUnit,
                  items: _unitOptions,
                  onChanged: handleFromChange,
                  decoration: InputDecoration(
                    labelText: 'From Unit'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: TextFormField(
                  controller: _toQuantityController,
                  decoration: InputDecoration(
                    labelText: 'To Quantity'
                  ),
                  validator: Validation.isNumeric,
                ),
              ),
              SizedBox(width: kLargePadding),
              Container(
                width: kStandardInput,
                child: DropdownButtonFormField<int>(
                  value: _selectedToUnit,
                  items: _unitOptions,
                  onChanged: handleToChange,
                  decoration: InputDecoration(
                    labelText: 'To Unit'
                  ),
                  validator: Validation.isNotEmpty,
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          child: Text('Save'),
          onPressed: handleSave
        )
      ],
      
    );
  }
}