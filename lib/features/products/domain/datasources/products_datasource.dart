import 'package:teslo_shop/features/products/domain/entities/products.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductById(String id);
  Future<List<Product>> searchProductByTerm(String term);
  Future<Product> createUpadteProduct(Map<String, dynamic> productLike);
}
