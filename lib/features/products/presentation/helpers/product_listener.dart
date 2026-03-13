import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/presentation/blocs/products_bloc/products_bloc.dart';
import 'package:teslo_shop/features/shared/helpers/helpers.dart';

void productStateListener(BuildContext context, ProductsState state) {
  if (state.errorMessage.isNotEmpty) {
    customSnackBar(context, state.errorMessage);
  }
}
