part of 'form_product_bloc.dart';

sealed class FormProductEvent extends Equatable {
  const FormProductEvent();

  @override
  List<Object> get props => [];
}

class SubmitForm extends FormProductEvent {
  const SubmitForm();
}

class TitleChange extends FormProductEvent {
  final String title;

  const TitleChange({required this.title});
}

class SlugChange extends FormProductEvent {
  final String slug;

  const SlugChange({required this.slug});
}

class PriceChange extends FormProductEvent {
  final double price;

  const PriceChange({required this.price});
}

class SizeChange extends FormProductEvent {
  final List<String> size;

  const SizeChange({required this.size});
}

class GenderChange extends FormProductEvent {
  final String gender;

  const GenderChange({required this.gender});
}

class StockChange extends FormProductEvent {
  final int stock;

  const StockChange({required this.stock});
}

class DescriptionChange extends FormProductEvent {
  final String descrpition;

  const DescriptionChange({required this.descrpition});
}

class TagsChange extends FormProductEvent {
  final String tags;

  const TagsChange({required this.tags});
}

class ImagesChange extends FormProductEvent {
  final List<String> images;

  const ImagesChange({required this.images});
}
