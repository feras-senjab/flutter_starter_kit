part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final AppTheme appTheme;
  final bool isUsingSystemTheme;

  const ThemeState({
    required this.appTheme,
    required this.isUsingSystemTheme,
  });

  @override
  List<Object> get props => [appTheme, isUsingSystemTheme];

  ThemeState copyWith({
    AppTheme? appTheme,
    bool? isUsingSystemTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
      isUsingSystemTheme: isUsingSystemTheme ?? this.isUsingSystemTheme,
    );
  }
}
