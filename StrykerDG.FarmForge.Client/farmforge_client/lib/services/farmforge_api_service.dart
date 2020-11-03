import 'dart:html';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/dto/new_crop_dto.dart';
import 'package:farmforge_client/models/dto/new_crop_log_dto.dart';
import 'package:farmforge_client/models/dto/add_inventory_dto.dart';
import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/inventory/product_category.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';
import 'package:farmforge_client/models/inventory/unit_type_conversion.dart';
import 'package:farmforge_client/models/dto/new_supplier_dto.dart';
import 'package:farmforge_client/models/dto/split_inventory_dto.dart';

class FarmForgeApiService {
  static String token;
  static String apiUrl = 'https://localhost:44310';

  Future<FarmForgeResponse> request(String uri, dynamic body, String method) async {
    
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    http.Response response;
    try {
      switch(method) {
        case 'GET':
          response = await http.get('$apiUrl/$uri', headers: headers);
          break;
        case 'POST':
          response = await http.post('$apiUrl/$uri', headers: headers, body: body);
          break;
        case 'PATCH':
          response = await http.patch('$apiUrl/$uri', headers: headers, body: body);
          break;
        case 'DELETE':
          response = await http.delete('$apiUrl/$uri', headers: headers);
          break;
      }

      if(response != null) {
        dynamic jsonResponse = convert.jsonDecode(response.body);

        var data = jsonResponse['Data'];
        var error =jsonResponse['Error'];

        return FarmForgeResponse(data: data, error: error);
      }
      else
        return FarmForgeResponse(error: 'Unable to make request');
    }
    catch(e) {
      return FarmForgeResponse(error: e.toString());
    }
  }

  // Authentication
  Future<FarmForgeResponse> login(String user, String password) async {
    Map<String, String> loginObject = {
      'Username': user,
      'Password': password
    };

    String jsonBody = convert.jsonEncode(loginObject);
    FarmForgeResponse response = await request('Auth/Login', jsonBody, 'POST');

    if(response.data != null) {
      token = response.data;
      Storage sessionStorage = window.sessionStorage;
      sessionStorage['token'] = token;
    }

    return response;
  }

  void setToken(String newToken) {
    token = newToken;
  }

  // User
  Future<FarmForgeResponse> getUsers() async {
    return await request('Auth/Users', null, 'GET');
  }

  Future<FarmForgeResponse> createUser(String username, String password) async {
    Map<String, String> userObject = {
      'Username': username,
      'Password': password
    };

    String jsonBody = convert.jsonEncode(userObject);
    return await request('Auth/Users', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> deleteUser(int userId) async {
    return await request('Auth/Users/$userId', null, 'DELETE');
  }

  // Crops
  Future<FarmForgeResponse> getCrops({
    DateTime begin, 
    DateTime end, 
    String includes = "",
    String status = "",
    String location = ""
  }) async {
    String beginString = begin != null
      ? begin.toString()
      : '1900-01-01';

    String endString = end != null
      ? end.toString()
      : DateTime.now().toString();

    String uri = 'Crops?begin=$beginString&end=$endString';

    if(includes.isNotEmpty)
      uri += '&includes=$includes';
    if(status.isNotEmpty)
      uri += '&status=$status';
    if(location.isNotEmpty)
      uri += '&location=$location';

    return await request(uri, null, 'GET');
  }

  Future<FarmForgeResponse> createCrop(NewCropDTO newCrop) async {
    Map<String, dynamic> requestObject = {
      'CropTypeId': newCrop.cropTypeId,
      'VarietyId': newCrop.varietyId,
      'LocationId': newCrop.locationId,
      'Quantity': newCrop.quantity,
      'Date': newCrop.date.toIso8601String()
    };

    String jsonBody = convert.jsonEncode(requestObject);
    return await request(
      'Crops',
      jsonBody,
      'POST'
    );
  }

  Future<FarmForgeResponse> updateCrop({
    String fields,
    Crop crop}) async {
    
    Map<String, dynamic> requestBody = {
      'Fields': fields,
      'Crop': crop?.toMap()
    };

    String jsonBody = convert.jsonEncode(requestBody);
    return await request('Crops', jsonBody, 'PATCH');
  }

  Future<FarmForgeResponse> getCropTypes({String includes}) async {
    String uri = includes == null
      ? 'CropTypes'
      : 'CropTypes?includes=$includes';

    return await request(
      uri,
      null,
      'GET'
    );
  }

  Future<FarmForgeResponse> createCropType(String name, int id) async {
    Map<String, dynamic> requestBody = {
      'Name': name,
      'ClassificationId': id
    };

    String jsonBody = convert.jsonEncode(requestBody);
    return await request('CropTypes', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> deleteCropType(int id) async {
    return await request('CropTypes/$id', null, 'DELETE');
  }

  Future<FarmForgeResponse> createCropVariety(String name, int cropTypeId) async {
    return await request('CropTypes/$cropTypeId/Variety/$name', null, 'POST');
  }

  Future<FarmForgeResponse> deleteCropVariety(int cropTypeId, int varietyId) async {
    return await request('CropTypes/$cropTypeId/Variety/$varietyId', null, 'DELETE');
  }

  Future<FarmForgeResponse> getCropClassifications() async {
    return await request('CropClassifications', null, 'GET');
  }

  Future<FarmForgeResponse> getCropLogs(String type) async {
    String uri = type.isNotEmpty
      ? 'CropLogs?type=$type'
      : 'CropLogs';

    return await request(uri, null, 'GET');
  }
  
  Future<FarmForgeResponse> createCropLog(NewCropLogDTO log) async {
    String jsonBody = convert.jsonEncode(log.toMap());
    return await request(
      'Crops/${log.cropId}/Logs',
      jsonBody,
      'POST'
    );
  }

  // Locations
  Future<FarmForgeResponse> getLocations() async {
    return await request(
      'Locations',
      null,
      'GET'
    );
  }

  Future<FarmForgeResponse> addLocation(String name, int parentId) async {
    Map<String, dynamic> locationObject = {
      'Label': name
    };

    if(parentId != null)
      locationObject['ParentId'] = parentId;

    String jsonBody = convert.jsonEncode(locationObject);
    return await request('Locations', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> updateLocation(
    String fields, 
    Location location) async {
    
    Map<String, dynamic> requestBody = {
      'Fields': fields,
      'Location': location.toMap()
    };

    String jsonBody = convert.jsonEncode(requestBody);
    return await request('Locations', jsonBody, 'PATCH');
  }

  Future<FarmForgeResponse> deleteLocation(int id) async {
    return await request('Locations/$id', null, 'DELETE');
  }

  // Logs
  Future<FarmForgeResponse> getLogsByType(String type) async {
    return await request('LogTypes/$type', null, 'GET');
  }

  // Statuses
  Future<FarmForgeResponse> getStatusesByType(String type) async {
    return await request('Statuses/$type', null, 'GET');
  }

  // Inventory 
  Future<FarmForgeResponse> getUnitTypes() async {
    return await request('Units', null, 'GET');
  }

  Future<FarmForgeResponse> addUnitType(UnitType unit) async {
    Map<String, dynamic> requestBody = unit.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Units', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> deleteUnitType(int id) async {
    return await request('Units/$id', null, 'DELETE');
  }

  Future<FarmForgeResponse> getUnitConversions() async {
    return await request('Units/Conversions', null, 'GET');
  }

  Future<FarmForgeResponse> getConversionsByUnit(int unitTypeId) async {
    return await request('Units/Conversions/$unitTypeId', null, 'GET');
  }

  Future<FarmForgeResponse> createOrUpdateUnitConversion(
    UnitTypeConversion conversion,
    String method) async {

    Map<String, dynamic> requestBody = conversion.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Units/Conversions', jsonBody, method);
  }

  Future<FarmForgeResponse> deleteUnitTypeConversion(int id) async {
    return await request('Units/Convers/$id', null, 'DELETE');
  }

  Future<FarmForgeResponse> getProductTypes() async {
    return await request('Products', null, 'GET');
  }

  Future<FarmForgeResponse> addProductType(ProductType type) async {
    if(type.productTypeId == null)
      type.productTypeId = 0;

    Map<String, dynamic> requestBody = type.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Products', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> updateProductType(ProductType type) async {
    Map<String, dynamic> requestBody = type.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Products', jsonBody, 'PATCH');
  }

  Future<FarmForgeResponse> deleteProductType(int typeId) async {
    return await request('Products/$typeId', null, 'DELETE');
  }

  Future<FarmForgeResponse> getProductCategories() async {
    return await request('Products/Categories', null, 'GET');
  }

  Future<FarmForgeResponse> addProductCategory(ProductCategory category) async {
    if(category.productCategoryId == null)
      category.productCategoryId = 0;

    Map<String, dynamic> requestBody = category.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Products/Categories', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> deleteProductCategory(int categoryId) async {
    return await request('Products/Categories/$categoryId', null, 'DELETE');
  }

  Future<FarmForgeResponse> getInventory() async {
    return await request('Products/Inventory', null, 'GET');
  }

  Future<FarmForgeResponse> moveInventoryToLocation(
    List<int> productIds, 
    int newLocationId) async {

    Map<String, dynamic> requestBody = {
      'ProductIds': productIds,
      'LocationId': newLocationId
    };

    String jsonBody = convert.jsonEncode(requestBody);
    return await request('Products/Inventory/Transfer', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> addInventory(AddInventoryDTO newInventory) async {
    Map<String, dynamic> requestBody = newInventory.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Products/Inventory', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> consumeInventory(List<int> productIds) async {
    Map<String, dynamic> requestBody = {
      'ProductIds': productIds
    };
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Products/Inventory/Consume', jsonBody, 'POST');
  }

  Future<FarmForgeResponse> splitInventory(SplitInventoryDTO inventory) async {
    Map<String, dynamic> requestBody = inventory.toMap();
    String jsonBody = convert.jsonEncode(requestBody);

    return await request('Products/Inventory/Split', jsonBody, 'POST');
  }

  // Suppliers
  Future<FarmForgeResponse> getSuppliers({String includes}) async {
    String uri = includes != null
      ? 'Suppliers?includes=$includes'
      : 'Suppliers';

    return await request(uri, null, 'GET');
  }

  Future<FarmForgeResponse> getSupplierProducts(int supplierId) async {
    return await request('Suppliers/$supplierId/Products', null, 'GET');
  }

  Future<FarmForgeResponse> createOrUpdateSupplier(
    NewSupplierDTO requestObject, 
    String method) async {

    Map<String, dynamic> requestBody = requestObject.toMap();
    String jsonBody = convert.jsonEncode(requestBody);
    
    return await request('Suppliers', jsonBody, method);
  }

  Future<FarmForgeResponse> deleteSupplier(int supplierId) async {
    return await request('Suppliers/$supplierId', null, 'DELETE');
  }
}