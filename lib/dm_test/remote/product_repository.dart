import '../../dm/src/repositories/remote.dart' show RemoteDataRepository;
import 'product.dart' show Product;
import 'product_local_source.dart' show ProductLocalSource;
import 'product_remote_source.dart' show ProductRemoteSource;

class ProductRepository extends RemoteDataRepository<Product> {
  ProductRepository()
    : super(source: ProductRemoteSource(), backup: ProductLocalSource());
}
