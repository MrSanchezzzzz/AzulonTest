import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'routes.dart';

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      initialRoute: Routes.catalog,
      routes: AppRouter.routes,
    );
  }
}
