part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<Product> products;
  final Product? selectedProduct;
  final bool isLoading;
  final String errorMessage;
  final int offset;
  final int limit;
  final bool isLastPage;

  const ProductsState({
    this.products = const [],
    this.selectedProduct,
    this.isLoading = false,
    this.errorMessage = '',
    this.limit = 10,
    this.offset = 0,
    this.isLastPage = false,
  });

  @override
  List<Object?> get props => [
    products,
    selectedProduct,
    isLoading,
    errorMessage,
    limit,
    offset,
    isLastPage,
  ];

  ProductsState copyWith({
    List<Product>? products,
    Product? selectedProduct,
    bool? isLoading,
    String? errorMessage,
    int? offset,
    int? limit,
    bool? isLastPage,
  }) => ProductsState(
    products: products ?? this.products,
    selectedProduct: selectedProduct ?? this.selectedProduct,
    errorMessage: errorMessage ?? this.errorMessage,
    isLastPage: isLastPage ?? this.isLastPage,
    isLoading: isLoading ?? this.isLoading,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
  );
}
