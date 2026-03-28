import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/ingredient.dart';
import '../models/recipe.dart';

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
      : baseUrl = _normalizeBaseUrl(
          baseUrl ??
              const String.fromEnvironment(
                'API_BASE_URL',
                defaultValue: 'http://localhost:8000',
              ),
        );

  static String _normalizeBaseUrl(String rawBaseUrl) {
    final uri = Uri.tryParse(rawBaseUrl);
    if (uri == null) {
      return rawBaseUrl;
    }

    // Android emulator maps the host machine to 10.0.2.2, not localhost.
    if (Platform.isAndroid &&
        (uri.host == 'localhost' || uri.host == '127.0.0.1')) {
      return uri.replace(host: '10.0.2.2').toString();
    }

    return rawBaseUrl;
  }

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
    } else if (response.statusCode == 429) {
      throw ApiException(
        statusCode: 429,
        message: 'Przekroczono limit zapytań do AI (quota). Sprawdź plan i limity klucza API.',
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

  Future<List<Recipe>> suggestRecipes(List<Ingredient> ingredients) async {
    final uri = Uri.parse('$baseUrl/api/suggest-recipes');
    final body = json.encode({
      'ingredients': ingredients.map((e) => e.name).toList(),
    });

    http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));
    } on SocketException {
      throw const ApiException(
        message: 'Brak połączenia z serwerem.',
      );
    } on HttpException {
      throw const ApiException(
        message: 'Błąd połączenia HTTP.',
      );
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final recipes = data['recipes'] as List<dynamic>? ?? [];
      return recipes
          .asMap()
          .entries
          .map((e) => Recipe.fromApiJson(
                e.value as Map<String, dynamic>,
                id: '${e.key}',
              ))
          .toList();
    } else if (response.statusCode == 429) {
      throw const ApiException(
        statusCode: 429,
        message: 'Przekroczono limit AI. Spróbuj ponownie później.',
      );
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Błąd serwera: ${response.statusCode}.',
      );
    }
  }
}
