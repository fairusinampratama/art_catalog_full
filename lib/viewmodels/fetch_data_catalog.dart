// art_viewmodel.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/catalog_data.dart';

// ignore: camel_case_types
class catalogViewModel {
  final String apiUrl =
      'https://api.artic.edu/api/v1/artworks?fields=id,title,artist_title,date_display,description,image_id,place_of_origin&limit=100';

  Future<List<ArtModel>> fetchArtModel() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Check if the 'data' field exists in the response
      if (jsonData.containsKey('data')) {
        List<dynamic> artworksData = jsonData['data'];

        List<ArtModel> dataArtModel = artworksData.map((value) {
          return ArtModel.fromJson(value);
        }).toList();

        return dataArtModel;
      } else {
        throw Exception('Missing "data" field in API response');
      }
    } else {
      throw Exception('Failed to load data collection');
    }
  }
}
