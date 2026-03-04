import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/bloc.dart';
import 'package:teslo_shop/features/auth/presentation/utils/utils.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.06),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!context.canPop()) return;
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 1),
                    Text(
                      'Crear cuenta',
                      style: textStyles.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                Container(
                  height: size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    final height = MediaQuery.of(context).size.height;

    final registerState = context.watch<RegisterBloc>().state;
    final registerBloc = context.read<RegisterBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: authStateListener,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 30,
          children: [
            Text('Nueva cuenta', style: textStyles.titleMedium),

            CustomTextFormField(
              label: 'Nombre completo',
              keyboardType: TextInputType.emailAddress,
              onChanged: registerBloc.nameChange,
              errorMessage: registerState.name.errorMessage,
            ),

            CustomTextFormField(
              label: 'Correo',
              keyboardType: TextInputType.emailAddress,
              onChanged: registerBloc.emailChange,
              errorMessage: registerState.email.errorMessage,
            ),

            CustomTextFormField(
              label: 'Contraseña',
              obscureText: true,
              onChanged: registerBloc.passwordChange,
              errorMessage: registerState.password.errorMessage,
            ),

            CustomTextFormField(
              label: 'Repita la contraseña',
              obscureText: true,
              onChanged: registerBloc.confirmPasswordChange,
              errorMessage: registerState.confirmPassword.errorMessage,
            ),
            !registerState.isPosting
                ? SizedBox(
                    width: double.infinity,
                    height: height * 0.06,
                    child: CustomFilledButton(
                      text: 'Crear',
                      buttonColor: Colors.black,
                      onPressed: () => registerBloc.formSubmit(),
                    ),
                  )
                : const CircularProgressIndicator(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                  },
                  child: const Text('Ingresa aquí'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
