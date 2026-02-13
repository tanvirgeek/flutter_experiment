import 'package:flutter/material.dart';

extension ThemeText on BuildContext {
  /// headlineLarge uses dynamic primary color
  TextStyle headlinePrimary() => Theme.of(this).textTheme.headlineLarge!
      .copyWith(color: Theme.of(this).colorScheme.primary);

  /// headlineMedium uses dynamic onSurface color
  TextStyle headlineMediumOnSurface() => Theme.of(this)
      .textTheme
      .headlineMedium!
      .copyWith(color: Theme.of(this).colorScheme.onSurface);

  /// bodyLarge uses dynamic onSurface color
  TextStyle bodyLargeOnSurface() => Theme.of(
    this,
  ).textTheme.bodyLarge!.copyWith(color: Theme.of(this).colorScheme.onSurface);

  /// bodyMedium uses dynamic onSurfaceVariant color
  TextStyle bodyMediumOnSurfaceVariant() => Theme.of(this).textTheme.bodyMedium!
      .copyWith(color: Theme.of(this).colorScheme.onSurfaceVariant);
}
