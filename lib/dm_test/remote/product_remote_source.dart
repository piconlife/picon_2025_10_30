import '../../data/delegates/firestore.dart' show FirestoreDataDelegate;
import '../../dm/src/sources/remote.dart' show RemoteDataSource;
import 'product.dart' show Product;

class ProductRemoteSource extends RemoteDataSource<Product> {
  ProductRemoteSource()
    : super(
        path: 'products',
        documentId: 'id',
        delegate: FirestoreDataDelegate.instance,
      );

  @override
  Product build(dynamic source) => Product.from(source);
}
