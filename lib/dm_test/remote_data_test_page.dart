import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        BuildContext,
        Widget,
        Text,
        EdgeInsets,
        TextStyle,
        SizedBox,
        VoidCallback,
        AppBar,
        CrossAxisAlignment,
        Colors,
        SingleChildScrollView,
        Container,
        Wrap,
        Expanded,
        Column,
        Padding,
        Scaffold,
        ElevatedButton;
import 'package:flutter_entity/entity.dart' show Response, EntityHelper;

import 'product.dart' show Product, ProductKey;
import 'product_use_cases.dart'
    show
        createProductUseCase,
        getAllProductsUseCase,
        getProductByIdUseCase,
        updateProductUseCase,
        deleteProductUseCase,
        getProductsByQueryUseCase,
        searchProductsUseCase,
        countProductsUseCase,
        listenAllProductsUseCase,
        listenProductByIdUseCase,
        listenProductsByQueryUseCase;

class RemoteDataTestPage extends StatefulWidget {
  const RemoteDataTestPage({super.key});

  @override
  State<RemoteDataTestPage> createState() => _RemoteDataTestPageState();
}

class _RemoteDataTestPageState extends State<RemoteDataTestPage> {
  String _log = 'Press a button to test';
  StreamSubscription? _sub;

  void _setLog(String msg) => setState(() => _log = msg);

  String _format(Response r) {
    if (r.isValid) return 'OK: ${r.result}';
    return 'FAIL [${r.status}]: ${r.error}';
  }

  Future<void> _create() async {
    final p = Product(
      id: EntityHelper.generateID,
      name: 'Test Item',
      price: 99.9,
      category: 'electronics',
      tags: ['new', 'sale'],
      stock: 50,
    );
    final res = await createProductUseCase(p);
    _setLog('CREATE => ${_format(res)}');
  }

  Future<void> _getAll() async {
    final res = await getAllProductsUseCase();
    _setLog('GET ALL => ${_format(res)}');
  }

  Future<void> _getById() async {
    final all = await getAllProductsUseCase();
    final id = all.result.firstOrNull?.id ?? '';
    if (id.isEmpty) return _setLog('GET BY ID => no data');
    final res = await getProductByIdUseCase(id);
    _setLog('GET BY ID [$id] => ${_format(res)}');
  }

  Future<void> _update() async {
    final all = await getAllProductsUseCase();
    final id = all.result.firstOrNull?.id ?? '';
    if (id.isEmpty) return _setLog('UPDATE => no data');
    final res = await updateProductUseCase(id, {
      ProductKey.price: 199.9,
      ProductKey.stock: 10,
    });
    _setLog('UPDATE [$id] => ${_format(res)}');
  }

  Future<void> _delete() async {
    final all = await getAllProductsUseCase();
    final id = all.result.lastOrNull?.id ?? '';
    if (id.isEmpty) return _setLog('DELETE => no data');
    final res = await deleteProductUseCase(id);
    _setLog('DELETE [$id] => ${_format(res)}');
  }

  Future<void> _query() async {
    final res = await getProductsByQueryUseCase('electronics');
    _setLog('QUERY [category=electronics] => ${_format(res)}');
  }

  Future<void> _search() async {
    final res = await searchProductsUseCase('Test');
    _setLog('SEARCH [name contains Test] => ${_format(res)}');
  }

  Future<void> _count() async {
    final res = await countProductsUseCase();
    _setLog('COUNT => ${_format(res)}');
  }

  void _listenAll() {
    _sub?.cancel();
    _setLog('LISTEN ALL => waiting...');
    _sub = listenAllProductsUseCase().listen((res) {
      _setLog('LISTEN ALL => ${_format(res)}');
    });
  }

  void _listenById() async {
    final all = await getAllProductsUseCase();
    final id = all.result.firstOrNull?.id ?? '';
    if (id.isEmpty) return _setLog('LISTEN BY ID => no data');
    _sub?.cancel();
    _setLog('LISTEN BY ID [$id] => waiting...');
    _sub = listenProductByIdUseCase(id).listen((res) {
      _setLog('LISTEN BY ID => ${_format(res)}');
    });
  }

  void _listenByQuery() {
    _sub?.cancel();
    _setLog('LISTEN QUERY => waiting...');
    _sub = listenProductsByQueryUseCase('electronics').listen((res) {
      _setLog('LISTEN QUERY => ${_format(res)}');
    });
  }

  void _cancelListen() {
    _sub?.cancel();
    _sub = null;
    _setLog('Listener cancelled');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DM Test')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black12,
              height: 80,
              child: SingleChildScrollView(
                child: Text(_log, style: const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _btn('Create', _create),
                    _btn('Get All', _getAll),
                    _btn('Get By Id', _getById),
                    _btn('Update', _update),
                    _btn('Delete', _delete),
                    _btn('Query', _query),
                    _btn('Search', _search),
                    _btn('Count', _count),
                    _btn('Listen All', _listenAll),
                    _btn('Listen By Id', _listenById),
                    _btn('Listen By Query', _listenByQuery),
                    _btn('Cancel Listen', _cancelListen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap) {
    return ElevatedButton(onPressed: onTap, child: Text(label));
  }
}
