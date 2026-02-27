import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:teslo_shop/features/products/products.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    //* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) {
        // Cuando se crea un provider de esta manera, cuando salen de la pantalla muere automaticamente
        return BlocProvider(
          create: (context) => LoginBloc(authBloc: context.read<AuthBloc>()),
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(path: '/', builder: (context, state) => const ProductsScreen()),
  ],

  ///! TODO: Bloquear si no se está autenticado de alguna manera
);
