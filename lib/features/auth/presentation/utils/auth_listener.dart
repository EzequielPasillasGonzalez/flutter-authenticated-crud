import 'package:flutter/material.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';
import 'package:teslo_shop/features/shared/helpers/helpers.dart';

void authStateListener(BuildContext context, AuthState state) {
  if (state is AuthNotAuthenticated) {
    if (state.errorMessage.isEmpty) return;
    customSnackBar(context, state.errorMessage);
  }
}
