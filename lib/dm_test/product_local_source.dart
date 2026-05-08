import '../data/delegates/local.dart' show LocalDataDelegate;
import '../dm/src/sources/local.dart' show LocalDataSource;
import 'product.dart' show Product;

class ProductLocalSource extends LocalDataSource<Product> {
  ProductLocalSource()
    : super(path: 'products', delegate: LocalDataDelegate.instance);

  @override
  Product build(dynamic source) => Product.from(source);
}
