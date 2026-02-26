import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static Future<void> initEnviroment() async {
    await dotenv.load(fileName: '.env');
  }

  static final String production =
      dotenv.env['PRODUCTION'] ??
      (throw AssertionError('PRODUCTION not found in .env file'));

  static final String api =
      dotenv.env['API_URL'] ??
      (throw AssertionError('API_URL not found in .env file'));

  static final String apiTest =
      dotenv.env['API_URL_TEST'] ??
      (throw AssertionError('API_URL_TEST not found in .env file'));

  static final String apiUrl = production == 'true' ? api : apiTest;
}
