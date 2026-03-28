import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/ingredient.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException({this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ?? const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8000',
        );

  Future<List<Ingredient>> analyzeFridge(File imageFile) async {
    final uri = Uri.parse('$baseUrl/api/analyze-fridge');
    final request = http.MultipartRequest('POST', uri);

    final mimeType = _mimeTypeFor(imageFile.path);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: http.MediaType.parse(mimeType),
      ),
    );

    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 30));
    } on SocketException {
      throw const ApiException(
        message: 'Brak połączenia z serwerem. Sprawdź swoje połączenie sieciowe.',
      );
    } on HttpException {
      throw const ApiException(
        message: 'Błąd połączenia HTTP.',
      );
    }

    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(body) as Map<String, dynamic>;
      final ingredientsList = data['ingredients'] as List<dynamic>? ?? [];
      return ingredientsList
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 400) {
      throw ApiException(
        statusCode: 400,
        message: 'Nieprawidłowy format pliku. Wymagany JPEG lub PNG.',
      );
    } else if (response.statusCode == 413) {
      throw ApiException(
        statusCode: 413,
        message: 'Plik jest za duży.',
      );
    } else if (response.statusCode == 503) {
      throw ApiException(
        statusCode: 503,
        message: 'Usługa AI jest chwilowo niedostępna. Spróbuj ponownie.',
      );
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Błąd serwera: ${response.statusCode}.',
      );
    }
  }

  String _mimeTypeFor(String path) {
    final ext = path.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
