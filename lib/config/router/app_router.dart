import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/go_router_refresh_stream.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';
import 'package:teslo_shop/features/products/presentation/blocs/products_bloc/products_bloc.dart';
import 'package:teslo_shop/features/products/products.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/check-auth',
    //  Conectar GoRouter con los cambios de estado de AuthBloc
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isGoingTo =
          state.matchedLocation; // A qué URL intenta ir el usuario

      final isChecking = authState is AuthChecking;
      final isAuthenticated = authState is AuthAuthenticated;
      final isNotAuthenticated = authState is AuthNotAuthenticated;

      // Rutas publicas
      final isGoingToLogin = isGoingTo == '/login';
      final isGoingToRegister = isGoingTo == '/register';

      //  El BLoC está revisando el token
      if (isChecking) {
        return '/check-auth';
      }

      // El token caduco no existe
      if (isNotAuthenticated) {
        // Si ya va en camino al login o registro, dejarlo pasar (retornar null = pase libre)
        if (isGoingToRegister || isGoingToLogin) return null;

        return '/login';
      }

      if (isAuthenticated) {
        if (isGoingToRegister || isGoingToLogin || isGoingTo == '/check-auth') {
          return '/';
        }

        return null;
      }

      return null;
    },
    routes: [
      // * Primera pantalla
      GoRoute(
        path: '/check-auth',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

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
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                RegisterBloc(authBloc: context.read<AuthBloc>()),
            child: const RegisterScreen(),
          );
        },
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => ProductsBloc(),
            child: const ProductsScreen(),
          );
        },
      ),
    ],
  );
}
