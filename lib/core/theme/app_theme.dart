import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pickles Direct design system.
///
/// Tokens are derived from Pickles brand guidelines and the Figma design file:
/// https://www.figma.com/design/0sAXPf39C6pUj6KuAp9ZP1/Pickles.my--New
/// Once the final design tokens are exported from Figma, update these values
/// and they will cascade through the entire app.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colours = isDark ? AppColours.dark : AppColours.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colours.scheme,
      scaffoldBackgroundColor: colours.background,
      // Use PicklesBody when font files are supplied; falls back to system default.
      fontFamily: 'PicklesBody',

      appBarTheme: AppBarTheme(
        backgroundColor: colours.surface,
        foregroundColor: colours.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.titleMedium.copyWith(
          color: colours.onSurface,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colours.scheme.primary,
          foregroundColor: colours.scheme.onPrimary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colours.scheme.primary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          side: BorderSide(color: colours.scheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colours.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
          vertical: AppDimensions.spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide(color: colours.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide(color: colours.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide(color: colours.scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide(color: colours.scheme.error),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: colours.onSurfaceVariant,
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(
          color: colours.scheme.error,
        ),
      ),

      cardTheme: CardThemeData(
        color: colours.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: BorderSide(color: colours.outline.withAlpha(128)),
        ),
        margin: EdgeInsets.zero,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colours.surfaceVariant,
        labelStyle: AppTextStyles.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colours.outline.withAlpha(77),
        thickness: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),
    );
  }
}

// ── Colour Palettes ───────────────────────────────────────────────────────────

abstract final class AppColours {
  static ColourTokens get light => const _LightColours();
  static ColourTokens get dark => const _DarkColours();
}

abstract interface class ColourTokens {
  ColorScheme get scheme;
  Color get background;
  Color get surface;
  Color get surfaceVariant;
  Color get onSurface;
  Color get onSurfaceVariant;
  Color get outline;
  Color get statusDraft;
  Color get statusQueued;
  Color get statusSyncing;
  Color get statusSubmitted;
  Color get statusValuationPending;
  Color get statusAccepted;
  Color get statusListed;
}

final class _LightColours implements ColourTokens {
  const _LightColours();

  @override
  ColorScheme get scheme => const ColorScheme.light(
    primary: Color(0xFFE8321A), // Pickles red
    primaryContainer: Color(0xFFFFDAD5),
    secondary: Color(0xFF1A1A1A), // Near-black
    onSecondary: Colors.white,
    onSurface: Color(0xFF1A1A1A),
    error: Color(0xFFBA1A1A),
  );

  @override
  Color get background => const Color(0xFFF6F6F6);
  @override
  Color get surface => Colors.white;
  @override
  Color get surfaceVariant => const Color(0xFFF2F2F2);
  @override
  Color get onSurface => const Color(0xFF1A1A1A);
  @override
  Color get onSurfaceVariant => const Color(0xFF737373);
  @override
  Color get outline => const Color(0xFFDDDDDD);

  @override
  Color get statusDraft => const Color(0xFF737373);
  @override
  Color get statusQueued => const Color(0xFF1565C0);
  @override
  Color get statusSyncing => const Color(0xFF0277BD);
  @override
  Color get statusSubmitted => const Color(0xFF2E7D32);
  @override
  Color get statusValuationPending => const Color(0xFFE65100);
  @override
  Color get statusAccepted => const Color(0xFF1B5E20);
  @override
  Color get statusListed => const Color(0xFFE8321A);
}

final class _DarkColours implements ColourTokens {
  const _DarkColours();

  @override
  ColorScheme get scheme => const ColorScheme.dark(
    primary: Color(0xFFFF8A78),
    onPrimary: Color(0xFF5F1409),
    primaryContainer: Color(0xFF8B1B0B),
    secondary: Color(0xFFE0E0E0),
    onSecondary: Color(0xFF1A1A1A),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
  );

  @override
  Color get background => const Color(0xFF121212);
  @override
  Color get surface => const Color(0xFF1E1E1E);
  @override
  Color get surfaceVariant => const Color(0xFF2C2C2C);
  @override
  Color get onSurface => const Color(0xFFE0E0E0);
  @override
  Color get onSurfaceVariant => const Color(0xFFAAAAAA);
  @override
  Color get outline => const Color(0xFF3D3D3D);

  @override
  Color get statusDraft => const Color(0xFFAAAAAA);
  @override
  Color get statusQueued => const Color(0xFF64B5F6);
  @override
  Color get statusSyncing => const Color(0xFF4FC3F7);
  @override
  Color get statusSubmitted => const Color(0xFF81C784);
  @override
  Color get statusValuationPending => const Color(0xFFFFB74D);
  @override
  Color get statusAccepted => const Color(0xFFA5D6A7);
  @override
  Color get statusListed => const Color(0xFFFF8A78);
}

// ── Typography ────────────────────────────────────────────────────────────────

abstract final class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'PicklesDisplay',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'PicklesDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'PicklesBody',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

// ── Dimensions ────────────────────────────────────────────────────────────────

abstract final class AppDimensions {
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const double buttonHeight = 52;
  static const double iconSizeSm = 16;
  static const double iconSizeMd = 24;
  static const double iconSizeLg = 32;

  static const double photoThumbnailSize = 80;
  static const double photoPreviewHeight = 240;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: spacingMd,
    vertical: spacingMd,
  );
}
