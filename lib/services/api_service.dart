import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<CharacterResponse> getCharacters({int page = 1, String? nameFilter}) async {
    try {
      String url = '$_baseUrl/character?page=$page';
      if (nameFilter != null && nameFilter.isNotEmpty) {
        url += '&name=$nameFilter';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CharacterResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        return CharacterResponse(
          info: Info(count: 0, pages: 0, next: null, prev: null),
          results: [],
        );
      } else {
        throw Exception('Error al cargar personajes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Character>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    try {
      final idsParam = ids.join(',');
      final response = await http.get(Uri.parse('$_baseUrl/character/$idsParam'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar favoritos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}