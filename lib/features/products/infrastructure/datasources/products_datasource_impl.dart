import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final KeyValueStorageService keyValueStorageService;

  ProductsDatasourceImpl({KeyValueStorageService? keyValueStorageService})
    : keyValueStorageService =
          keyValueStorageService ?? KeyValueStorageServiceImpl() {
    dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await this.keyValueStorageService.getValue<String>(
            'token',
          );

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }

  @override
  Future<Product> createUpadteProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/post' : '/products/$productId';
      productLike.remove('id');

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method),
      );

      return ProductMapper.jsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Expiro la sesión',
        );
      }
      if (e.type == DioExceptionType.receiveTimeout) throw ConnectionTimeout();
      throw CustomError(
        message: 'Error al obtener productos: ${e.message}',
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
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');

      return ProductMapper.jsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Expiro la sesión',
        );
      }
      if (e.type == DioExceptionType.receiveTimeout) throw ConnectionTimeout();
      throw CustomError(
        message: 'Error al obtener productos: ${e.message}',
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
  Future<List<Product>> getProductsByPage({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await dio.get(
        '/products',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      final List<Product> products = [];

      for (var product in response.data ?? []) {
        products.add(ProductMapper.jsonToEntity(product));
      }

      return products;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Expiro la sesión',
        );
      }
      if (e.type == DioExceptionType.receiveTimeout) throw ConnectionTimeout();
      throw CustomError(
        message: 'Error al obtener productos: ${e.message}',
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
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
