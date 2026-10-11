import 'package:flutter/material.dart';

@immutable
class NestPalette extends ThemeExtension<NestPalette> {
  const NestPalette(
      {required this.accents, required this.tints, required this.quote});
  final List<Color> accents;
  final List<Color> tints;
  final Color quote;
  static const light = NestPalette(accents: [
    Color(0xFF226BFA),
    Color(0xFF6853D9),
    Color(0xFF00836D),
    Color(0xFFF07832)
  ], tints: [
    Color(0xFFF0F7FF),
    Color(0xFFF5EFFF),
    Color(0xFFEDF8F1),
    Color(0xFFFFF2E9)
  ], quote: Color(0xFFF5F4FA));
  static const dark = NestPalette(accents: [
    Color(0xFF8FB8FF),
    Color(0xFFB5A6FF),
    Color(0xFF7DDAC0),
    Color(0xFFFFB98C)
  ], tints: [
    Color(0xFF172840),
    Color(0xFF29223F),
    Color(0xFF17362F),
    Color(0xFF3C2A21)
  ], quote: Color(0xFF20243A));
  static NestPalette of(BuildContext context) =>
      Theme.of(context).extension<NestPalette>() ??
      (Theme.of(context).brightness == Brightness.dark ? dark : light);
  @override
  NestPalette copyWith(
          {List<Color>? accents, List<Color>? tints, Color? quote}) =>
      NestPalette(
          accents: accents ?? this.accents,
          tints: tints ?? this.tints,
          quote: quote ?? this.quote);
  @override
  NestPalette lerp(covariant NestPalette? other, double t) => other == null
      ? this
      : NestPalette(
          accents: List.generate(
              4, (i) => Color.lerp(accents[i], other.accents[i], t)!),
          tints:
              List.generate(4, (i) => Color.lerp(tints[i], other.tints[i], t)!),
          quote: Color.lerp(quote, other.quote, t)!);
}

ThemeData buildAngelTheme(Brightness brightness) {
  final light = brightness == Brightness.light;
  final colors = ColorScheme.fromSeed(
          seedColor: const Color(0xFF2146A7), brightness: brightness)
      .copyWith(
          primary: light ? const Color(0xFF10357C) : const Color(0xFFA9C5FF),
          onPrimary: light ? const Color(0xFFFFFFFF) : const Color(0xFF102752),
          primaryContainer:
              light ? const Color(0xFFEAF2FF) : const Color(0xFF203457),
          onPrimaryContainer:
              light ? const Color(0xFF143B87) : const Color(0xFFDCE7FF),
          secondary: light ? const Color(0xFF00836D) : const Color(0xFF7DDAC0),
          secondaryContainer:
              light ? const Color(0xFFE8F6EE) : const Color(0xFF193A31),
          onSecondaryContainer:
              light ? const Color(0xFF135A49) : const Color(0xFFC9F2E5),
          tertiary: light ? const Color(0xFF6853D9) : const Color(0xFFB5A6FF),
          tertiaryContainer:
              light ? const Color(0xFFF0EAFF) : const Color(0xFF32264E),
          onTertiaryContainer:
              light ? const Color(0xFF493399) : const Color(0xFFECE3FF),
          surface: light ? const Color(0xFFFFFFFF) : const Color(0xFF171D2E),
          onSurface: light ? const Color(0xFF101A54) : const Color(0xFFE7ECFF),
          onSurfaceVariant:
              light ? const Color(0xFF64749A) : const Color(0xFFB0BEDC),
          outlineVariant:
              light ? const Color(0xFFE3E8F2) : const Color(0xFF36415A));
  final base =
      ThemeData(useMaterial3: true, colorScheme: colors, fontFamily: 'Roboto');
  TextStyle? serif(TextStyle? style) => style?.copyWith(
      fontFamily: 'Lora',
      fontFamilyFallback: const ['Times New Roman', 'serif'],
      fontWeight: FontWeight.w600,
      height: 1.2);
  return base.copyWith(
      extensions: [light ? NestPalette.light : NestPalette.dark],
      scaffoldBackgroundColor:
          light ? const Color(0xFFFCFCFF) : const Color(0xFF101525),
      textTheme: base.textTheme.copyWith(
          displayLarge: serif(base.textTheme.displayLarge),
          displayMedium: serif(base.textTheme.displayMedium),
          displaySmall: serif(base.textTheme.displaySmall),
          headlineLarge: serif(base.textTheme.headlineLarge),
          headlineMedium: serif(base.textTheme.headlineMedium),
          headlineSmall: serif(base.textTheme.headlineSmall),
          titleLarge: serif(base.textTheme.titleLarge)),
      appBarTheme: AppBarTheme(
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: serif(base.textTheme.titleLarge)
              ?.copyWith(color: colors.onSurface)),
      cardTheme: CardThemeData(
          color: colors.surface,
          elevation: 0,
          surfaceTintColor: colors.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.outlineVariant))),
      dividerTheme:
          DividerThemeData(color: colors.outlineVariant, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: const StadiumBorder())),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              side: BorderSide(color: colors.primary),
              shape: const StadiumBorder())),
      chipTheme: base.chipTheme.copyWith(
          backgroundColor: colors.primaryContainer,
          selectedColor: colors.primaryContainer,
          side: BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          labelStyle: base.textTheme.labelMedium
              ?.copyWith(color: colors.onPrimaryContainer)),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colors.surface,
          hintStyle: base.textTheme.bodyMedium
              ?.copyWith(color: colors.onSurfaceVariant),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colors.outlineVariant)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colors.outlineVariant)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colors.primary))));
}
