import 'package:auth_repository/auth_repository.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_starter_kit/Features/AppGate/UI/app_gate.dart';
import 'package:flutter_starter_kit/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:firebase_repository/config.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:flutter_starter_kit/Config/simple_bloc_observer.dart';
import 'package:flutter_starter_kit/Features/Auth/Login/UI/login_screen.dart';
import 'package:flutter_starter_kit/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/app_theme.dart';
import 'package:flutter_starter_kit/Global/Style/Theme/cubit/theme_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'Features/Auth/bloc/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  //! IMPORTANT: DEFINE DEPLOYMENT ENVIRONMENT BEFORE BUILD OR DEPLOY.
  const DeploymentEnv deploymentEnv = DeploymentEnv.testing;
  const bool enableDevicePreview = false;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = SimpleBlocObserver();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(
        create: (context) => AuthRepository(),
      ),
      RepositoryProvider<FirebaseUsersRepository>(
        create: (context) =>
            FirebaseUsersRepository(deploymentEnv: deploymentEnv),
      ),
    ],
    child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(themePreferenceKey: 'theme'),
          ),
          BlocProvider(
            create: (BuildContext context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AppStarted()),
          ),
          BlocProvider(
            create: (BuildContext context) => UserModelCubit(
              authBloc: context.read<AuthBloc>(),
              usersRepository: context.read<FirebaseUsersRepository>(),
            ),
          ),
          BlocProvider(
            create: (BuildContext context) => LogoutCubit(
              authRepository: context.read<AuthRepository>(),
              authBloc: context.read<AuthBloc>(),
              userModelCubit: context.read<UserModelCubit>(),
              //userDataRepository: context.read<UserDataRepository>(),
            ),
          ),
        ],
        // Wrapped with device preview to test responsiveness
        child: DevicePreview(
          enabled:
              deploymentEnv == DeploymentEnv.testing && enableDevicePreview,
          builder: (context) => const MyApp(),
        )),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Starter Code',
              theme: state.appTheme.themeData,
              home: BlocBuilder<AuthBloc, AuthState>(
                // Rebuild the UI only when the auth state transitions from 'unknown' to a known state.
                // This ensures that the main screen is initially displayed based on the authentication status.
                // Subsequent UI updates or navigations (e.g., login, signup, logout) are handled manually
                // and do not trigger unnecessary rebuilds of the main screen.
                buildWhen: (previous, current) =>
                    previous.status == AuthStatus.unknown &&
                    previous != current,
                builder: (context, state) {
                  switch (state.status) {
                    case AuthStatus.authenticated:
                      return const AppGate();

                    case AuthStatus.unauthenticated:
                      return const LoginScreen();

                    default:
                      // ! can be replaced with splash or another appropriate Ui.
                      return const LoginScreen();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
