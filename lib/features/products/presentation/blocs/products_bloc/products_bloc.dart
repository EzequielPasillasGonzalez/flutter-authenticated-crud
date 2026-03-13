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
    on<GetProductByID>(_onGetProductById);
    // TODO: SearchProductByTerm
    on<CreateUpdateProduct>(_onCreateUpdateProduct);
  }

  //* --- Acceso por fuera  --- *//
  void loadNextPage() {
    add(ProductLoadNextPage());
  }

  void getProductByID(String id) {
    add(GetProductByID(id));
  }

  void createUpdateProduct(Map<String, dynamic> productLike) {
    add(CreateUpdateProduct(productLike));
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
                true, // Como ya no hay productos, entonces bloqueamos la peiticones
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
      emit(_limpiarError());
      emit(state.copyWith(errorMessage: 'Error al cargar más productos $e'));
    } finally {
      emit(_limpiarLoading());
    }
  }

  Future<void> _onCreateUpdateProduct(
    CreateUpdateProduct event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    try {
      final product = await productRepository.createUpadteProduct(
        event.productLike,
      );

      final isProductInList = state.products.any(
        (element) => element.id == product.id,
      );

      if (!isProductInList) {
        emit(
          state.copyWith(
            products: [...state.products, product],
            selectedProduct: product,
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          selectedProduct: product,
          products: state.products
              .map((element) => (element.id == product.id) ? product : element)
              .toList(),
        ),
      );

      return;
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Error al crear/actualizar el producto $e',
        ),
      );
    } finally {
      emit(_limpiarLoading());
    }
  }

  Future<void> _onGetProductById(
    GetProductByID event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final product = await productRepository.getProductById(event.id);

      emit(state.copyWith(selectedProduct: product));
    } catch (e) {
      _limpiarError();
      emit(state.copyWith(errorMessage: 'Error al obtener el producto $e'));
    } finally {
      emit(_limpiarLoading());
    }
  }

  ProductsState _limpiarLoading() {
    return state.copyWith(isLoading: false);
  }

  ProductsState _limpiarError() {
    return state.copyWith(errorMessage: '');
  }
}
