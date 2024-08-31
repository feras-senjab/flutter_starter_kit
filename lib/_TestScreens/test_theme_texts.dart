import 'package:flutter/material.dart';

class TestThemeTexts extends StatelessWidget {
  const TestThemeTexts({super.key});

  @override
  Widget build(BuildContext context) {
    Widget space = const SizedBox(height: 10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Title'),
      ),
      body: ListView(
        children: [
          //---------------- display -----------------------//
          Text(
            'displaySmall',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Text(
            'displayMedium',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            'displayLarge',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          space,
          //---------------- headline -----------------------//
          Text(
            'headlineSmall',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'headlineMedium',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'headlineLarge',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          space,
          //---------------- title -----------------------//
          Text(
            'titleSmall',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            'titleMedium',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'titleLarge',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          space,
          //---------------- body -----------------------//
          Text(
            'bodySmall',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Text(
            'bodyMedium',
          ),
          Text(
            'bodyLarge',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          space,
          //---------------- label -----------------------//
          Text(
            'labelSmall',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            'labelMedium',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            'labelLarge',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
