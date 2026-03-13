import 'package:flutter/material.dart';

void customSnackBar(
  BuildContext context,
  String message, {
  Color color = Colors.red,
}) {
  // Ocultar cualquier snackbar anterior
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // Mostrar el nuevo error
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
