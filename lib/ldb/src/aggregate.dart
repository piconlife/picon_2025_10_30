part of 'database.dart';

class InAppAggregateQuery extends InAppReference {
  final InAppCollectionReference _p;

  const InAppAggregateQuery({
    required super.db,
    required super.reference,
    required InAppCollectionReference parent,
  }) : _p = parent;

  InAppCollectionReference get parent => _p;

  Future<InAppAggregateQuerySnapshot> get([
    InAppSource source = InAppSource.cache,
  ]) async {
    final query = await _p.get(source);
    return InAppAggregateQuerySnapshot(count: query.docs.length, query: query);
  }

  Stream<InAppAggregateQuerySnapshot> snapshots() {
    final n = _db._addNotifier(_p.path);
    return Stream<InAppAggregateQuerySnapshot>.multi((controller) {
      void update() {
        if (controller.isClosed) return;
        final snap = n.value ?? InAppQuerySnapshot(_p.id);
        controller.add(
          InAppAggregateQuerySnapshot(count: snap.docs.length, query: snap),
        );
      }

      n.addListener(update);
      controller.onCancel = () => n.removeListener(update);
      _p._notify();
    });
  }
}

@Deprecated('Use InAppAggregateQuery instead.')
typedef InAppCounterReference = InAppAggregateQuery;
