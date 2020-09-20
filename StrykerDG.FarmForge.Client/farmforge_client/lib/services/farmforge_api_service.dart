import 'package:farmforge_client/models/general/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:farmforge_client/models/farmforge_response.dart';

class FarmForgeApiService {
  static String token;
  static String apiUrl = 'https://localhost:44310';

  Future<FarmForgeResponse> request(String uri, dynamic body, String method) async {
    
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    print('$apiUrl/$uri');
    print('body: $body');

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

        var data = jsonResponse['data'];
        var error =jsonResponse['error'];

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

    if(response.data != null)
      token = response.data;

    return response;
  }

  // Crops
  Future<FarmForgeResponse> getCrops({DateTime begin, DateTime end}) async {
    FarmForgeResponse response = await request(
      'Crops?begin=${begin.toString()}&end=${end.toString()}',
      null, 
      'GET'
    );

    print(response.data.toString());
    return response;
  }

  Future<FarmForgeResponse> getCropTypes({String includes}) async {
    String uri = includes == null
      ? 'CropTypes'
      : 'CropTypes?includes=$includes';

    FarmForgeResponse response = await request(
      uri,
      null,
      'GET'
    );

    return response;
  }

  // Locations
  Future<FarmForgeResponse> getLocations() async {
    FarmForgeResponse response = await request(
      'Locations',
      null,
      'GET'
    );

    return response;
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
}