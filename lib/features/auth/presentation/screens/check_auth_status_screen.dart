import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';
import 'package:teslo_shop/features/auth/presentation/utils/utils.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: authStateListener,
      child: Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}
