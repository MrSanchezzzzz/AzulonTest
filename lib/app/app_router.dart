import 'package:flutter/material.dart';

import '../features/catalog/presentation/screens/catalog_screen.dart';
import '../features/catalog/presentation/screens/item_detail_screen.dart';
import 'routes.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    Routes.catalog: (_) => const CatalogScreen(),
    Routes.details: (_) => const ItemDetailScreen(),
  };
}
