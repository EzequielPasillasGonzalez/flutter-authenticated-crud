import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _ImageViewer(images: product.images),
        Text(product.title),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: images.isEmpty
          ? Image.asset(
              'assets/images/no-image.jpg',
              fit: BoxFit.cover,
              height: 250,
            )
          : FadeInImage(
              image: NetworkImage(images.first),
              fadeOutDuration: const Duration(milliseconds: 100),
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              fit: BoxFit.cover,
              height: 250,
            ),
    );
  }
}
