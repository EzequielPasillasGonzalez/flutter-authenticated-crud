import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

part 'form_product_event.dart';
part 'form_product_state.dart';

class FormProductBloc extends Bloc<FormProductEvent, FormProductState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  FormProductBloc({this.onSubmitCallback}) : super(FormProductState()) {
    on<TitleChange>(_onTitleChange);
    on<SlugChange>(_onSlugChange);
    on<PriceChange>(_onPriceChange);
    on<SizeChange>(_onSizeChange);
    on<GenderChange>(_onGenderChange);
    on<StockChange>(_onStockChange);
    on<DescriptionChange>(_onDescriptionChange);
    on<TagsChange>(_onTagsChange);
    on<ImagesChange>(_onImagesChange);
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
    add(DescriptionChange(descrpition: descripcion));
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
    final newStock = Stock.dirty(event.stock);
    emit(
      state.copyWith(
        stock: newStock,
        isFormValid: Formz.validate([
          newStock,
          state.title,
          state.slug,
          state.price,
        ]),
      ),
    );
  }

  void _onSizeChange(SizeChange event, Emitter<FormProductState> emit) {
    final newSize = event.size;
    emit(state.copyWith(size: [...state.size, ...newSize]));
  }

  void _onGenderChange(GenderChange event, Emitter<FormProductState> emit) {
    final newGender = event.gender;
    emit(state.copyWith(gender: newGender));
  }

  void _onDescriptionChange(
    DescriptionChange event,
    Emitter<FormProductState> emit,
  ) {
    final newDescription = event.descrpition;
    emit(state.copyWith(descrpition: newDescription));
  }

  void _onTagsChange(TagsChange event, Emitter<FormProductState> emit) {
    final newTags = event.tags;
    emit(state.copyWith(tags: newTags));
  }

  void _onImagesChange(ImagesChange event, Emitter<FormProductState> emit) {
    final newImages = event.images;
    emit(state.copyWith(images: [...state.images, ...newImages]));
  }

  Future<bool> onFormsubmit(
    SubmitForm event,
    Emitter<FormProductState> emit,
  ) async {
    _touchedEveryFields();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    // TODO: validar si esta creando un nuevo producto o editando
    // TODO: construir el producto para poder enviar al api

    return true;
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
