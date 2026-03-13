import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/blocs/form_bloc/form_product_bloc.dart';
import 'package:teslo_shop/features/products/presentation/blocs/products_bloc/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/features/products/presentation/helpers/product_listener.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProductsBloc>().getProductByID(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductsBloc>().state;
    final productBloc = context.read<ProductsBloc>();
    final product = productState.selectedProduct;

    // Comparar si el ID en memoria es el mismo que busca la ruta
    final isMatchingId = product?.id == widget.productId;

    // Si está cargando o si el producto en memoria es viejo
    // y no coincide con la ruta, forzamos el loader
    if (productState.isLoading || (!isMatchingId && product != null)) {
      return const Scaffold(body: FullScreenLoader());
    }

    // Validacion si el producto es nulo
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Producto no encontrado')),
      );
    }

    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        productStateListener(context, state);
        if (widget.productId == 'new' && state.selectedProduct?.id != 'new') {
          context.canPop();
        }
      },
      child: BlocProvider(
        create: (context) => FormProductBloc(
          product: product,
          onSubmitCallback: (productLike) {
            FocusScope.of(context).unfocus();
            productBloc.createUpdateProduct(productLike);
          },
        ),
        child: _ProductFormScaffold(product: product),
      ),
    );
  }
}

class _ProductFormScaffold extends StatelessWidget {
  const _ProductFormScaffold({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final formProductBloc = context.read<FormProductBloc>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Producto'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        body: _ProductView(product: product),
        floatingActionButton: FloatingActionButton(
          onPressed: () => formProductBloc.onSubmitForm(),
          child: const Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final productoForm = context.watch<FormProductBloc>().state;
    // Mostrar una propiedad de texto
    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productoForm.images),
        ),

        const SizedBox(height: 10),
        Center(
          child: Text(productoForm.title.value, style: textStyles.titleSmall),
        ),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends StatelessWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context) {
    final productoForm = context.watch<FormProductBloc>().state;
    final productoFormBloc = context.read<FormProductBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productoForm.title.value,
            onChanged: (value) => productoFormBloc.onTitleChange(value),
            errorMessage: productoForm.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productoForm.slug.value,
            onChanged: productoFormBloc.onSlugChange,
            errorMessage: productoForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productoForm.price.value.toString(),
            onChanged: (value) =>
                productoFormBloc.onPriceChange(double.tryParse(value) ?? -1),
            errorMessage: productoForm.price.errorMessage,
          ),

          const SizedBox(height: 15),
          const Text('Extras'),

          _SizeSelector(
            selectedSizes: productoForm.size,
            onSizesChanged: productoFormBloc.onSizeChange,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productoForm.gender,
            onSelectedGender: productoFormBloc.onGenderChange,
          ),

          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productoForm.stock.value.toString(),
            onChanged: (value) =>
                productoFormBloc.onStockChange(int.tryParse(value) ?? -1),
            errorMessage: productoForm.stock.errorMessage,
          ),

          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productoForm.description,
            onChanged: productoFormBloc.onDescriptionChange,
          ),

          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productoForm.tags,
            onChanged: productoFormBloc.onTagsChange,
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final void Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
          value: size,
          label: Text(size, style: const TextStyle(fontSize: 10)),
        );
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChanged(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [Icons.man, Icons.woman, Icons.boy];

  final void Function(String selectedGender) onSelectedGender;

  const _GenderSelector({
    required this.selectedGender,
    required this.onSelectedGender,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: false,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
            icon: Icon(genderIcons[genders.indexOf(size)]),
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();

          onSelectedGender(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  'assets/images/no-image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(e, fit: BoxFit.cover),
              );
            }).toList(),
    );
  }
}
