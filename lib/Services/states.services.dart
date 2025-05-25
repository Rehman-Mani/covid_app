import 'dart:convert';

import 'package:covid_app/Model/world_staes_model.dart';
import 'package:covid_app/Utilites/app_url_api.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStaesModel> fetchworldStatesRecords() async {
    final response = await http.get(Uri.parse(ApiUrl.worldStateApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return WorldStaesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  // for countiry
  Future<List<dynamic>> countiresApiFetch() async {
    final response = await http.get(Uri.parse(ApiUrl.countryList));
    var data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception('Error');
    }
  }
}
