import 'package:dio/dio.dart';
import 'package:rick_morty_app/data/models/character.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://rickandmortyapi.com/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/character',
        queryParameters: {'page': page},
      );
      
      final results = response.data['results'] as List;
      return results.map((json) => Character.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }
}