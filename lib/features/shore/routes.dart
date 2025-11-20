import 'package:flutter/material.dart';
import 'package:in_app_navigator/generate.dart';

import '../../routes/paths.dart';
import 'view/pages/add_a_grocery.dart';
import 'view/pages/search_grocery.dart';

Map<String, RouteBuilder> get mStoreRoutes {
  return {
    Routes.addAGrocery: _addAGrocery,
    Routes.searchGroceries: _searchGroceries,
  };
}

Widget _addAGrocery(BuildContext context, Object? args) {
  return const AddAGroceryPage();
}

Widget _searchGroceries(BuildContext context, Object? args) {
  return const SearchGroceriesPage();
}
