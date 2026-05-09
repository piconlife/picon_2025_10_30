// part of 'database.dart';
//
// class InAppCounterReference extends InAppReference {
//   final InAppCollectionReference _p;
//
//   const InAppCounterReference({
//     required super.db,
//     required super.reference,
//     required InAppCollectionReference parent,
//   }) : _p = parent;
//
//   InAppCollectionReference get parent => _p;
//
//   Future<InAppCounterSnapshot> get() async {
//     final query = await _p.get();
//     return InAppCounterSnapshot(_p.id, query, query.docs.length);
//   }
//
//   Stream<InAppCounterSnapshot> snapshots() {
//     final n = _db._addNotifier(_p.path);
//     return Stream<InAppCounterSnapshot>.multi((controller) {
//       void update() {
//         if (controller.isClosed) return;
//         final snap = n.value ?? InAppQuerySnapshot(_p.id);
//         controller.add(InAppCounterSnapshot(_p.id, snap, snap.docs.length));
//       }
//
//       n.addListener(update);
//       controller.onCancel = () => n.removeListener(update);
//       _p._notify();
//     });
//   }
// }
