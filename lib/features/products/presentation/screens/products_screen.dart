import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:teslo_shop/features/products/presentation/blocs/products_bloc/products_bloc.dart';
import 'package:teslo_shop/features/products/presentation/widgets/product_card.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _ProductsView extends StatefulWidget {
  const _ProductsView();

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<ProductsBloc>().loadNextPage();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        context.read<ProductsBloc>().loadNextPage();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = context.watch<ProductsBloc>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: productsState.products[index]);
        },
      ),
    );
  }
}
