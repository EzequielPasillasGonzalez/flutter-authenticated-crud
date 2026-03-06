part of 'form_product_bloc.dart';

sealed class FormProductEvent extends Equatable {
  const FormProductEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends FormProductEvent {
  const SubmitForm();
}

class OnTitleChange extends FormProductEvent {
  final String title;

  const OnTitleChange({required this.title});
}

class OnSlugChange extends FormProductEvent {
  final String slug;

  const OnSlugChange({required this.slug});
}

class OnPriceChange extends FormProductEvent {
  final double price;

  const OnPriceChange({required this.price});
}

class OnSizeChange extends FormProductEvent {
  final List<String> size;

  const OnSizeChange({required this.size});
}

class OnGenderChange extends FormProductEvent {
  final String gender;

  const OnGenderChange({required this.gender});
}

class OnStockChange extends FormProductEvent {
  final int stock;

  const OnStockChange({required this.stock});
}

class OnDescriptionChange extends FormProductEvent {
  final String descrpition;

  const OnDescriptionChange({required this.descrpition});
}

class OnTagsChange extends FormProductEvent {
  final String tags;

  const OnTagsChange({required this.tags});
}

class OnImagesChange extends FormProductEvent {
  final List<String> images;

  const OnImagesChange({required this.images});
}
