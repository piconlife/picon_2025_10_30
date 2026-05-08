import 'package:flutter_entity/entity.dart' show Response;

import '../dm/src/utils/checker.dart' show Checker;
import '../dm/src/utils/fetch_options.dart' show DataFetchOptions;
import '../dm/src/utils/query.dart' show DataQuery;
import '../dm/src/utils/sorting.dart' show DataSorting;
import 'product.dart' show Product, ProductKey;
import 'product_repository.dart' show ProductRepository;

final _repo = ProductRepository();

Future<Response<Product>> createProductUseCase(Product product) {
  return _repo.create(product);
}

Future<Response<Product>> updateProductUseCase(
  String id,
  Map<String, dynamic> data,
) {
  return _repo.updateById(id, data);
}

Future<Response<Product>> deleteProductUseCase(String id) {
  return _repo.deleteById(id);
}

Future<Response<Product>> getProductByIdUseCase(String id) {
  return _repo.getById(id);
}

Future<Response<Product>> getAllProductsUseCase() {
  return _repo.get();
}

Future<Response<Product>> getProductsByQueryUseCase(String category) {
  return _repo.getByQuery(
    queries: [DataQuery(ProductKey.category, isEqualTo: category)],
    sorts: [DataSorting(ProductKey.price)],
    options: const DataFetchOptions.limit(10),
  );
}

Future<Response<Product>> searchProductsUseCase(String term) {
  return _repo.search(Checker.contains(ProductKey.name, term));
}

Stream<Response<Product>> listenAllProductsUseCase() {
  return _repo.listen();
}

Stream<Response<Product>> listenProductByIdUseCase(String id) {
  return _repo.listenById(id);
}

Stream<Response<Product>> listenProductsByQueryUseCase(String category) {
  return _repo.listenByQuery(
    queries: [DataQuery(ProductKey.category, isEqualTo: category)],
    sorts: [DataSorting(ProductKey.price)],
  );
}

Future<Response<int>> countProductsUseCase() {
  return _repo.count();
}
