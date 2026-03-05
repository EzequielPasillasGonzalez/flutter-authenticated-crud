part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductLoadNextPage extends ProductsEvent {}

class GetProductByID extends ProductsEvent {
  final String id;

  const GetProductByID(this.id);

  @override
  List<Object> get props => [id];
}

class SearchProductByTerm extends ProductsEvent {
  final String term;

  const SearchProductByTerm({required this.term});

  @override
  List<Object> get props => [term];
}

class CreateUpdateProduct extends ProductsEvent {
  final Map<String, dynamic> productLike;

  const CreateUpdateProduct(this.productLike);

  @override
  List<Object> get props => [productLike];
}
