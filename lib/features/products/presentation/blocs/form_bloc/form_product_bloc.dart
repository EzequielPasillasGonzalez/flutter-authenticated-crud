import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'form_product_event.dart';
part 'form_product_state.dart';

class FormProductBloc extends Bloc<FormProductEvent, FormProductState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  FormProductBloc({this.onSubmitCallback, Product? product})
    : super(
        FormProductState(
          // Si el producto existe, se llenam el estado inicial como "dirty"
          id: product?.id,
          title: TitleProduct.dirty(product?.title ?? ''),
          slug: Slug.dirty(product?.slug ?? ''),
          price: Price.dirty(product?.price ?? 0),
          size: product?.sizes ?? [],
          gender: product?.gender ?? 'men',
          stock: Stock.dirty(product?.stock ?? 0),
          description: product?.description ?? '',
          tags: product?.tags.join(', ') ?? '',
          images: product?.images ?? [],
        ),
      ) {
    on<TitleChange>(_onTitleChange);
    on<SlugChange>(_onSlugChange);
    on<PriceChange>(_onPriceChange);
    on<SizeChange>(_onSizeChange);
    on<GenderChange>(_onGenderChange);
    on<StockChange>(_onStockChange);
    on<DescriptionChange>(_onDescriptionChange);
    on<TagsChange>(_onTagsChange);
    on<ImagesChange>(_onImagesChange);
    on<SubmitForm>(_onSubmitForm);
  }

  void onTitleChange(String title) {
    add(TitleChange(title: title));
  }

  void onSlugChange(String slug) {
    add(SlugChange(slug: slug));
  }

  void onPriceChange(double price) {
    add(PriceChange(price: price));
  }

  void onSizeChange(List<String> size) {
    add(SizeChange(size: size));
  }

  void onGenderChange(String gender) {
    add(GenderChange(gender: gender));
  }

  void onStockChange(int stock) {
    add(StockChange(stock: stock));
  }

  void onDescriptionChange(String descripcion) {
    add(DescriptionChange(description: descripcion));
  }

  void onTagsChange(String tags) {
    add(TagsChange(tags: tags));
  }

  void onImagesChange(List<String> images) {
    add(ImagesChange(images: images));
  }

  void _onTitleChange(TitleChange event, Emitter<FormProductState> emit) {
    final newTitle = TitleProduct.dirty(event.title);
    emit(
      state.copyWith(
        title: newTitle,
        isFormValid: Formz.validate([
          newTitle,
          state.slug,
          state.price,
          state.stock,
        ]),
      ),
    );
  }

  void _onSlugChange(SlugChange event, Emitter<FormProductState> emit) {
    final newSlug = Slug.dirty(event.slug);
    emit(
      state.copyWith(
        slug: newSlug,
        isFormValid: Formz.validate([
          newSlug,
          state.title,
          state.price,
          state.stock,
        ]),
      ),
    );
  }

  void _onPriceChange(PriceChange event, Emitter<FormProductState> emit) {
    final newPrice = Price.dirty(event.price);
    emit(
      state.copyWith(
        price: newPrice,
        isFormValid: Formz.validate([
          newPrice,
          state.title,
          state.slug,
          state.stock,
        ]),
      ),
    );
  }

  void _onStockChange(StockChange event, Emitter<FormProductState> emit) {
    emit(
      state.copyWith(
        stock: Stock.dirty(event.stock),
        isFormValid: Formz.validate([
          Stock.dirty(event.stock),
          state.title,
          state.slug,
          state.price,
        ]),
      ),
    );
  }

  void _onSizeChange(SizeChange event, Emitter<FormProductState> emit) {
    emit(state.copyWith(size: event.size));
  }

  void _onGenderChange(GenderChange event, Emitter<FormProductState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onDescriptionChange(
    DescriptionChange event,
    Emitter<FormProductState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onTagsChange(TagsChange event, Emitter<FormProductState> emit) {
    emit(state.copyWith(tags: event.tags));
  }

  void _onImagesChange(ImagesChange event, Emitter<FormProductState> emit) {
    emit(state.copyWith(images: event.images));
  }

  Future<void> _onSubmitForm(
    SubmitForm event,
    Emitter<FormProductState> emit,
  ) async {
    // Emitit el estado con todos los campos tocados (dirty)
    // Esto es vital para que la pantalla muestre los errores en rojo
    final stateWithDirtyFields = _touchedEveryFields();

    emit(stateWithDirtyFields);

    if (!stateWithDirtyFields.isFormValid) return;

    if (onSubmitCallback == null) return;

    emit(state.copyWith(isLoading: true));

    try {
      onSubmitCallback!(state.productLike);
    } catch (e) {
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  FormProductState _touchedEveryFields() {
    return state.copyWith(
      isFormValid: Formz.validate([
        Price.dirty(state.price.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.stock.value),
        TitleProduct.dirty(state.title.value),
      ]),
    );
  }
}
