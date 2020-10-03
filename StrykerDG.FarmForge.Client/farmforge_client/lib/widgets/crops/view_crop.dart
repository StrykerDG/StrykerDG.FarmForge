import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/general/status.dart';
import 'package:farmforge_client/models/general/crop_log.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/validation.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';

enum DatePickerType {
  Planted,
  Germinated,
  Harvested
}

class ViewCrop extends StatefulWidget {

  final Crop crop;

  ViewCrop({@required this.crop});
  
  @override
  _ViewCropState createState() => _ViewCropState();
}

class _ViewCropState extends State<ViewCrop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Location> _locations = [];
  List<Status> _statuses = [];
  int _location, _status;
  String _yield, _plantedAt, _germinatedAt, _harvestedAt;

  void loadData() async {
    try {
      Future<FarmForgeResponse> statusFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getStatusesByType('Crop.Status');
      Future<FarmForgeResponse> locationFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getLocations();

      Future.wait([statusFuture, locationFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setStatuses(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLocations(responses[1].data);
        });
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  void handleStatusSelect(int newValue) {
    setState(() {
      _status = newValue;
    });
  }

  void handleLocationSelect(int newValue) {
    setState(() {
      _location = newValue;
    });
  }

  void handleSave() async {
    if(_formKey.currentState.validate()) {
      try {
        Crop updateCrop = Crop.clone(widget.crop);
        updateCrop.statusId = _status;
        updateCrop.locationId = _location;

        FarmForgeResponse updateResponse = await Provider
          .of<CoreProvider>(context, listen: false)
          .farmForgeService
          .updateCrop(
            fields: 'StatusId,LocationId', 
            crop: updateCrop
          );

        if(updateResponse.data != null) {
          Provider.of<DataProvider>(context, listen: false)
            .updateCrop(updateResponse.data);

          Navigator.pop(context);
        }
        else
          throw updateResponse.error;
      }
      catch(e) {
        UiUtility.handleError(
          context: context, 
          title: 'Update Error', 
          error: e.toString()
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    loadData();

    _status = widget.crop.statusId;
    _location = widget.crop.locationId;
    _yield = widget.crop.yieldPercent != null
      ? '${widget.crop.yieldPercent}%'
      : 'N/A';

    _plantedAt = DateTimeUtility
      .formatDateTime(widget.crop.plantedAt);

    if(widget.crop.germinatedAt != null)
      _germinatedAt = DateTimeUtility.formatDateTime(widget.crop.germinatedAt);

    if(widget.crop.harvestedAt != null)
      _harvestedAt = DateTimeUtility.formatDateTime(widget.crop.harvestedAt);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _statuses = Provider.of<DataProvider>(context).statuses
        .where((s) => s.entityType == 'Crop.Status').toList(); 
      _locations = Provider.of<DataProvider>(context).locations;
    });
  }
    
  DropdownButtonFormField<int> getStatusDropdown() {
    List<DropdownMenuItem<int>> statusOptions = _statuses.map((s) => 
      DropdownMenuItem<int>(
        value: s.statusId,
        child: Text(s.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _status,
      onChanged: handleStatusSelect,
      items: statusOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Crop Status'
      ),
    );
  }
  
  DropdownButtonFormField<int> getLocationDropdown() {
    List<DropdownMenuItem<int>> statusOptions = _locations.map((l) => 
      DropdownMenuItem<int>(
        value: l.locationId,
        child: Text(l.label),
      )
    ).toList();

    return DropdownButtonFormField<int>(
      value: _location,
      onChanged: handleLocationSelect,
      items: statusOptions,
      validator: Validation.isNotEmpty,
      decoration: InputDecoration(
        labelText: 'Crop Location'
      ),
    );
  }

  bool isSaveEnabled() {
    return !(
      _status == widget.crop.statusId &&
      _location == widget.crop.locationId
    );
  }

  @override
  Widget build(BuildContext context) {

    DropdownButtonFormField<int> statusDropdown = getStatusDropdown();
    DropdownButtonFormField<int> locationDropdown = getLocationDropdown();

    double listViewHeight = widget.crop.logs.length * kRowHeight;
    if(listViewHeight > kSmallListHeight)
      listViewHeight = kSmallListHeight;

    Function saveAction = isSaveEnabled()
      ? handleSave
      : null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status and Variety
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: kStandardInput,
                child: statusDropdown
              ),
              Container(
                width: kStandardInput,
                child: locationDropdown
              )
            ]
          ),

          // Dates
          Padding(
            padding: EdgeInsets.all(kSmallPadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: kNarrowInput,
                  child: TextFormField(
                    enabled: false,
                    initialValue: _plantedAt,
                    decoration: InputDecoration(
                      labelText: "Planted At",
                    ),
                  ),
                ),
                Container(
                  width: kNarrowInput,
                  child: TextFormField(
                    enabled: false,
                    initialValue: _germinatedAt,
                    decoration: InputDecoration(
                      labelText: "Germinated At",
                    ),
                  ),
                ),
                Container(
                  width: kNarrowInput,
                  child: TextFormField(
                    enabled: false,
                    initialValue: _harvestedAt,
                    decoration: InputDecoration(
                      labelText: "Harvested At",
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Quantity and Yield
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: kNarrowInput,
                child: TextFormField(
                  enabled: false,
                  initialValue: widget.crop.quantity.toString(),
                  decoration: InputDecoration(
                    labelText: 'Quantity'
                  ),
                )
              ),
              Container(
                width: kNarrowInput,
                child: TextFormField(
                  enabled: false,
                  initialValue: _yield,
                  decoration: InputDecoration(
                    labelText: 'Yield'
                  ),
                )
              ),
            ],
          ),

          // Logs
          Container(
            padding: EdgeInsets.all(kMediumPadding),
            height: listViewHeight,
            child: Center(
              child: ListView.builder(
                itemCount: widget.crop.logs.length,
                itemBuilder: (context, index) {
                  CropLog currentLog = widget.crop.logs.elementAt(index);

                  return ListTile(
                    leading: Text(
                      DateTimeUtility.formatShortDateTime(currentLog.created)
                    ),
                    title: Text(currentLog.logType.label),
                    subtitle: Text(currentLog.notes),
                  );
                }
              )
            ),
          ),

          // Save
          Center(
            child: RaisedButton(
              child: Text('Save'),
              onPressed: saveAction,
            ),
          )
        ],
      ),
    );
  }
}