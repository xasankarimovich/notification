import 'dart:convert';
import 'package:http/http.dart'as http;
import '../models/motivation_modell.dart';

class MotivationHttpServices {
  // static const String apiKey = 'AIzaSyCDR0Uur0WhNZhbP8aagd9kGDaYqVLwVjk';
  static const String baseUrl =
      'https://api.api-ninjas.com/v1/quotes?category=';

  Future<List<MotivationModel>> fetchQuoteData(String category) async {
    final String apiUrl = '$baseUrl$category';
    final response =
    await http.get(Uri.parse(apiUrl), headers: {'X-Api-Key':' AIzaSyCDR0Uur0WhNZhbP8aagd9kGDaYqVLwVjk'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      List<MotivationModel> loadedQuotes = jsonData
          .map((item) => MotivationModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return loadedQuotes;
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      return [];
    }
  }
}

