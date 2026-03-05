import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teslo_shop/features/products/domain/entities/products.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final productRepository = ProductsRepositoryImpl(
    datasource: ProductsDatasourceImpl(),
  );

  ProductsBloc() : super(ProductsState()) {
    on<ProductLoadNextPage>(_onProductLoadNextPage);
    // TODO: GetProductByID
    // TODO: SearchProductByTerm
    // TODO: CreateUpdateProduct
  }

  //* --- Acceso por fuera  --- *// 
  void loadNextPage() {
    add(ProductLoadNextPage());
  }

  //* --- Logica de los eventos --- *//
  void _onProductLoadNextPage(
    ProductLoadNextPage event,
    Emitter<ProductsState> emit,
  ) async {
    // Si ya estamos haciendo una peticio o es la ultima pagina evita hacer otra peticion
    if (state.isLastPage || state.isLoading) return;

    // Notificar que ya esta haciendo una peticion
    emit(state.copyWith(isLoading: true));

    try {
      final products = await productRepository.getProductsByPage(
        limit: state.limit,
        offset: state.offset,
      );

      // Si ya no hay productos llegamos a la ultima pagina
      if (products.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            isLastPage:
                false, // Como ya no hay productos, entonces bloqueamos la peiticones
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isLastPage: false,
          isLoading: false,
          offset: state.offset + state.limit,
          products: [...state.products, ...products],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error al cargar más productos $e',
        ),
      );
    }
  }
}
