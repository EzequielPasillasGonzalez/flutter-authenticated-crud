import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return UserMapper.userJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Expiro la sesión',
        );
      }
      if (e.type == DioExceptionType.receiveTimeout) throw ConnectionTimeout();
      throw CustomError(
        message: 'Un error inesperado',
        // errorCode: 1
      );
    } catch (e) {
      throw CustomError(
        message: 'Un error inesperado',
        // errorCode: 1
      );
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return UserMapper.userJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Credenciales incorrectas',
        );
      }
      if (e.type == DioExceptionType.receiveTimeout) throw ConnectionTimeout();
      throw CustomError(
        message: 'Un error inesperado',
        // errorCode: 1
      );
    } catch (e) {
      throw CustomError(
        message: 'Un error inesperado',
        // errorCode: 1
      );
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {'email': email, 'password': password, 'fullName': fullName},
      );

      return UserMapper.userJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Registro no válido',
        );
      }
      if (e.type == DioExceptionType.receiveTimeout) throw ConnectionTimeout();
      throw CustomError(
        message: 'Un error inesperado',
        // errorCode: 1
      );
    } catch (e) {
      throw CustomError(
        message: 'Un error inesperado',
        // errorCode: 1
      );
    }
  }
}
