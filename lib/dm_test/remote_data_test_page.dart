import 'dart:async';

import 'package:flutter/material.dart';

import '../dm/src/utils/checker.dart' show Checker;
import '../dm/src/utils/fetch_options.dart' show DataFetchOptions;
import '../dm/src/utils/query.dart' show DataQuery;
import '../dm/src/utils/sorting.dart' show DataSorting;
import 'product.dart';
import 'product_repository.dart';

class RemoteDataTestPage extends StatefulWidget {
  const RemoteDataTestPage({super.key});

  @override
  State<RemoteDataTestPage> createState() => _RemoteDataTestPageState();
}

class _RemoteDataTestPageState extends State<RemoteDataTestPage> {
  final _repo = ProductRepository();
  String _log = '';
  final String _id = '1778309191067';

  void _log_(String msg) => setState(() => _log = msg);

  Future<void> _create() async {
    final names = [
      'Laptop',
      'Phone',
      'Tablet',
      'Watch',
      'Speaker',
      'Camera',
      'Headphone',
      'Monitor',
    ];
    final categories = [
      'electronics',
      'gadgets',
      'accessories',
      'audio',
      'display',
    ];
    final tagPool = [
      'new',
      'sale',
      'hot',
      'trending',
      'limited',
      'popular',
      'featured',
    ];

    final rnd = DateTime.now().millisecondsSinceEpoch;
    final name = names[rnd % names.length];
    final category = categories[rnd % categories.length];
    final price = double.parse((10 + (rnd % 990)).toStringAsFixed(2));
    final stock = 1 + (rnd % 100);
    final tags = (tagPool..shuffle()).take(2).toList();

    final p = Product(
      id: rnd.toString(),
      name: '$name ${rnd % 1000}',
      price: price,
      category: category,
      tags: tags,
      stock: stock,
    );
    final res = await _repo.create(p);
    _log_(
      res.isValid
          ? 'Created: ${p.name} | ${p.category} | ৳${p.price}'
          : 'Error: ${res.error}',
    );
  }

  Future<void> _update() async {
    final r = await _repo.updateById(_id, {ProductKey.price: 199.9});
    _log_(r.isValid ? 'Updated: $_id' : 'Error: ${r.error}');
  }

  Future<void> _delete(String id) async {
    final r = await _repo.deleteById(id);
    _log_(r.isValid ? 'Deleted: $id' : 'Error: ${r.error}');
  }

  Future<void> _get() async {
    final res = await _repo.get();
    _log_(
      res.isValid ? 'Got ${res.result.length} items' : 'Error: ${res.error}',
    );
  }

  Future<void> _getById() async {
    final r = await _repo.getById(_id);
    _log_(
      r.isValid ? 'Got: ${r.result.firstOrNull?.name}' : 'Error: ${r.error}',
    );
  }

  Future<void> _query() async {
    final res = await _repo.getByQuery(
      queries: [DataQuery(ProductKey.category, isEqualTo: 'electronics')],
      sorts: [DataSorting(ProductKey.price)],
      options: const DataFetchOptions.limit(10),
    );
    _log_(
      res.isValid ? 'Query: ${res.result.length} items' : 'Error: ${res.error}',
    );
  }

  Future<void> _search() async {
    final res = await _repo.search(Checker.contains(ProductKey.name, 'Item'));
    _log_(
      res.isValid
          ? 'Search: ${res.result.length} items'
          : 'Error: ${res.error}',
    );
  }

  Future<void> _count() async {
    final res = await _repo.count();
    _log_('Count: ${res.result.firstOrNull}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remote Data Test')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Operations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _btn('Create', _create),
                  _btn('Update (first)', _update),
                  _btn('Get All', _get),
                  _btn('Get By Id', _getById),
                  _btn('Query', _query),
                  _btn('Search', _search),
                  _btn('Count', _count),
                ],
              ),
              const Divider(),

              if (_log.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.black12,
                  child: Text(_log, style: const TextStyle(fontSize: 12)),
                ),
              const SizedBox(height: 12),

              // const Text(
              //   'Count (stream)',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // StreamBuilder<Response<int>>(
              //   stream: _repo.listenCount(interval: Duration(minutes: 5)),
              //   builder: (context, s) {
              //     final count = s.data?.result.firstOrNull ?? 0;
              //     return Text('Total products: $count');
              //   },
              // ),
              // const Divider(),
              //
              // const Text(
              //   'First Item (stream by id)',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // StreamBuilder<Response<Product>>(
              //   stream: _repo.listenById(_id),
              //   builder: (context, s) {
              //     final item = s.data?.result.firstOrNull;
              //     if (item == null) return const Text('Loading...');
              //     return ListTile(
              //       contentPadding: EdgeInsets.zero,
              //       title: Text(item.name),
              //       subtitle: Text(
              //         'Price: ${item.price} | Stock: ${item.stock}',
              //       ),
              //       trailing: Text(item.category),
              //     );
              //   },
              // ),
              // const Divider(),
              //
              // const Text(
              //   'All Products (stream)',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // StreamBuilder<Response<Product>>(
              //   stream: _repo.listen(),
              //   builder: (context, s) {
              //     final items = s.data?.result ?? [];
              //     if (items.isEmpty) return const Text('No data');
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemCount: items.length,
              //       itemBuilder: (_, i) {
              //         final item = items[i];
              //         return ListTile(
              //           onLongPress: () => _delete(item.id),
              //           contentPadding: EdgeInsets.zero,
              //           title: Text(item.name),
              //           subtitle: Text('₹${item.price} | ${item.category}'),
              //           trailing: Text('Stock: ${item.id}'),
              //         );
              //       },
              //     );
              //   },
              // ),
              // const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap) {
    return ElevatedButton(onPressed: onTap, child: Text(label));
  }
}
