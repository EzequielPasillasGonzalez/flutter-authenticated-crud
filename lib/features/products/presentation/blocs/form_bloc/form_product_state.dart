part of 'form_product_bloc.dart';

class FormProductState extends Equatable {
  const FormProductState({
    this.isFormValid = false,
    this.id,
    this.title = const TitleProduct.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.size = const [],
    this.gender = 'men',
    this.stock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
    this.isLoading = false,
    this.isPosting = false,
  });

  final bool isFormValid;
  final bool isLoading;
  final bool isPosting;
  final String? id;
  final TitleProduct title;
  final Slug slug;
  final Price price;
  final List<String> size;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  FormProductState copyWith({
    bool? isFormValid,
    bool? isLoading,
    bool? isPosting,
    String? id,
    TitleProduct? title,
    Slug? slug,
    Price? price,
    List<String>? size,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images,
  }) => FormProductState(
    isFormValid: isFormValid ?? this.isFormValid,
    isLoading: isLoading ?? this.isLoading,
    isPosting: isPosting ?? this.isPosting,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    size: size ?? this.size,
    gender: gender ?? this.gender,
    stock: stock ?? this.stock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );

  @override
  List<Object?> get props => [
    isFormValid,
    id,
    title,
    slug,
    price,
    size,
    gender,
    stock,
    description,
    tags,
    isPosting,
    isLoading,
    images,
  ];

  Map<String, dynamic> get productLike {
    return {
      'id': (id == 'new') ? null : id,
      'title': title.value,
      'slug': slug.value,
      'price': price.value,
      'stock': stock.value,
      'sizes': size,
      'gender': gender,
      'description': description,
      'tags': tags.split(','),
      'images': images
          .map(
            (image) =>
                image.replaceAll('${Enviroment.apiUrl}/files/product/', ''),
          )
          .toList(),
    };
  }
}
