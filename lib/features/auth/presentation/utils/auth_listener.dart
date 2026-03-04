import 'package:flutter/material.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';

void authStateListener(BuildContext context, AuthState state) {
  if (state is AuthNotAuthenticated) {
    if (state.errorMessage.isEmpty) return;

    // Ocultar cualquier snackbar anterior
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Mostrar el nuevo error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
    );
  }
}
