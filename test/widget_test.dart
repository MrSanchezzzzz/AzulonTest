import 'package:azulon_test/app/app.dart';
import 'package:azulon_test/app/app_theme.dart';
import 'package:azulon_test/features/catalog/presentation/widgets/catalog_states_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dark theme migration', () {
    test('AppTheme.dark exposes required palette tokens', () {
      final theme = AppTheme.dark();

      expect(theme.scaffoldBackgroundColor, const Color(0xFF111111));
      expect(theme.colorScheme.primary, const Color(0xFFFFC700));
      expect(theme.colorScheme.onSurface, const Color(0xFFFFFFFF));
      expect(theme.colorScheme.surface, const Color(0xFF2B2B2B));
      expect(theme.appBarTheme.backgroundColor, const Color(0xFF2B2B2B));
    });

    testWidgets('CatalogApp is forced to dark mode', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      await tester.pumpWidget(const ProviderScope(child: CatalogApp()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
      expect(app.theme, isNotNull);
      expect(app.darkTheme, isNotNull);
      expect(app.theme!.scaffoldBackgroundColor, const Color(0xFF111111));
      expect(app.theme!.appBarTheme.backgroundColor, const Color(0xFF2B2B2B));
    });

    testWidgets('CatalogLoadingView uses themed dark surfaces', (tester) async {
      final theme = AppTheme.dark();

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: CatalogLoadingView()),
        ),
      );

      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .toList(growable: false);

      expect(
        decorations.any(
          (decoration) => decoration.color == theme.colorScheme.surface,
        ),
        isTrue,
      );
      expect(
        decorations.any(
          (decoration) =>
              decoration.color == theme.colorScheme.surfaceContainerHighest,
        ),
        isTrue,
      );
    });
  });
}
