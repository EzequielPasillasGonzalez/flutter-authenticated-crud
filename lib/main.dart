import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Enviroment.initEnviroment();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc()..checkAuth())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppRouter appRouter;

  @override
  void initState() {
    super.initState();
    appRouter = AppRouter(authBloc: context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.router,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
