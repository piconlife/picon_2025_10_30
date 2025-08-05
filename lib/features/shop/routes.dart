import 'package:flutter/material.dart';
import 'package:flutter_app_navigator/app_navigator.dart';

import '../../routes/paths.dart';
import 'view/pages/add_a_product.dart';
import 'view/pages/search_product.dart';

Map<String, RouteBuilder> get mShopRoutes {
  return {
    Routes.addAProduct: _addAProduct,
    Routes.searchProducts: _searchProducts,
  };
}

Widget _addAProduct(BuildContext context, Object? args) {
  return const AddAProductPage();
}

Widget _searchProducts(BuildContext context, Object? args) {
  return const SearchProductsPage();
}
