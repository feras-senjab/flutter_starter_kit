import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    developer.log(
      'Event in ${bloc.runtimeType}: $event',
      name: 'BlocObserver',
    );
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log(
      'Error in ${bloc.runtimeType}: $error',
      name: 'BlocObserver',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    developer.log(
      'Change in ${bloc.runtimeType}: $change',
      name: 'BlocObserver',
    );
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    developer.log(
      'Transition in ${bloc.runtimeType}: $transition',
      name: 'BlocObserver',
    );
    super.onTransition(bloc, transition);
  }
}
