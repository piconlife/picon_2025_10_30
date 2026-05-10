import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        BuildContext,
        Widget,
        Text,
        EdgeInsets,
        SizedBox,
        Divider,
        TextStyle,
        NeverScrollableScrollPhysics,
        VoidCallback,
        StatelessWidget,
        ThemeData,
        AppBar,
        CrossAxisAlignment,
        Wrap,
        Colors,
        Container,
        StreamBuilder,
        ListTile,
        ListView,
        Column,
        SingleChildScrollView,
        SafeArea,
        Scaffold,
        Theme,
        ElevatedButton,
        FontWeight,
        Padding;

import '../../ldb/core/field_value.dart' show InAppFieldValue;
import '../../ldb/src/database.dart'
    show
        InAppDatabase,
        InAppQueryReference,
        InAppDocumentReference,
        InAppSetOptions,
        InAppAggregateQuerySnapshot,
        InAppDocumentSnapshot,
        InAppQuerySnapshot;
import 'note.dart' show Note, NoteKey;

class LocalDataTestPage extends StatefulWidget {
  const LocalDataTestPage({super.key});

  @override
  State<LocalDataTestPage> createState() => _LocalDataTestPageState();
}

class _LocalDataTestPageState extends State<LocalDataTestPage> {
  final _db = InAppDatabase.instance;
  String _log = '';

  static const _id = '1778319785575';

  InAppQueryReference get _notes => _db.collection('notes');

  InAppDocumentReference _noteDoc(String id) => _notes.doc(id);

  void _log_(String msg) {
    if (!mounted) return;
    setState(() => _log = msg);
  }

  Future<void> _safe(String label, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      _log_('$label error: $e');
    }
  }

  Future<void> _create() => _safe('create', () async {
    final tagPool = ['work', 'personal', 'idea', 'todo', 'urgent'];
    final colors = ['yellow', 'blue', 'green', 'pink', 'white'];

    final rnd = DateTime.now().millisecondsSinceEpoch;
    final tags = (tagPool..shuffle()).take(2).toList();
    final color = colors[rnd % colors.length];

    final n = Note(
      id: _id,
      title: 'Note ${rnd % 1000}',
      body: 'This is a sample note body created at $rnd',
      tags: tags,
      pinned: rnd % 2 == 0,
      color: color,
    );

    await _noteDoc(_id).set({
      ...n.toMap(),
      NoteKey.createdAt: InAppFieldValue.serverTimestamp(true),
    });

    _log_('Created: ${n.title} | ${n.color} | pinned: ${n.pinned}');
  });

  Future<void> _createRandom() => _safe('createRandom', () async {
    final titles = ['Meeting', 'Idea', 'Shopping', 'Reminder', 'Quote', 'Task'];
    final colors = ['yellow', 'blue', 'green', 'pink', 'white'];
    final tagPool = ['work', 'personal', 'idea', 'todo', 'urgent'];

    final rnd = DateTime.now().millisecondsSinceEpoch;
    final n = Note(
      id: rnd.toString(),
      title: '${titles[rnd % titles.length]} ${rnd % 1000}',
      body: 'Body content at $rnd',
      tags: (tagPool..shuffle()).take(2).toList(),
      pinned: rnd % 2 == 0,
      color: colors[rnd % colors.length],
    );

    final ref = await _notes.add({
      ...n.toMap(),
      NoteKey.createdAt: InAppFieldValue.serverTimestamp(true),
    });

    _log_('Created: ${ref.id} | ${n.title} | ${n.color}');
  });

  Future<void> _update() => _safe('update', () async {
    await _noteDoc(_id).update({
      NoteKey.pinned: true,
      NoteKey.views: InAppFieldValue.increment(1),
      NoteKey.tags: InAppFieldValue.arrayUnion(['updated']),
      NoteKey.updatedAt: InAppFieldValue.serverTimestamp(true),
    });
    _log_('Updated: $_id (incremented views, added tag)');
  });

  Future<void> _setMerge() => _safe('setMerge', () async {
    await _noteDoc(_id).set({
      NoteKey.color: 'pink',
      NoteKey.title: 'Merged title',
    }, const InAppSetOptions(merge: true));
    _log_('Merged update on: $_id');
  });

  Future<void> _toggle() => _safe('toggle', () async {
    await _noteDoc(_id).update({NoteKey.pinned: InAppFieldValue.toggle()});
    _log_('Toggled pinned on: $_id');
  });

  Future<void> _removeTag() => _safe('removeTag', () async {
    await _noteDoc(_id).update({
      NoteKey.tags: InAppFieldValue.arrayRemove(['updated']),
    });
    _log_('Removed tag "updated"');
  });

  Future<void> _deleteField() => _safe('deleteField', () async {
    await _noteDoc(_id).update({NoteKey.color: InAppFieldValue.delete()});
    _log_('Deleted color field');
  });

  Future<void> _delete(String id) => _safe('delete', () async {
    await _noteDoc(id).delete();
    _log_('Deleted: $id');
  });

  Future<void> _checkById() => _safe('checkById', () async {
    final snap = await _noteDoc(_id).get();
    _log_(snap.exists ? 'Exists: $_id' : 'Not found: $_id');
  });

  Future<void> _deleteAll() => _safe('deleteAll', () async {
    await _notes.drop();
    _log_('Cleared all notes');
  });

  Future<void> _get() => _safe('get', () async {
    final snap = await _notes.get();
    _log_('Got ${snap.size} items');
  });

  Future<void> _getById() => _safe('getById', () async {
    final snap = await _noteDoc(_id).get();
    if (!snap.exists) return _log_('Not found');
    final n = Note.fromSnapshot(snap);
    _log_('Got: ${n.title}');
  });

  Future<void> _query() => _safe('query', () async {
    final snap =
        await _notes
            .where(NoteKey.color, isEqualTo: 'yellow')
            .orderBy(NoteKey.createdAt, descending: true)
            .limit(10)
            .get();
    _log_('Query: ${snap.size} yellow notes');
  });

  Future<void> _queryWhereIn() => _safe('queryWhereIn', () async {
    final snap =
        await _notes
            .where(NoteKey.color, whereIn: ['yellow', 'blue', 'green'])
            .get();
    _log_('whereIn: ${snap.size} items');
  });

  Future<void> _queryArrayContains() => _safe('queryArrayContains', () async {
    final snap = await _notes.where(NoteKey.tags, arrayContains: 'work').get();
    _log_('arrayContains "work": ${snap.size} items');
  });

  Future<void> _queryRange() => _safe('queryRange', () async {
    final snap =
        await _notes
            .where(NoteKey.views, isGreaterThanOrEqualTo: 1)
            .orderBy(NoteKey.views, descending: true)
            .get();
    _log_('views >= 1: ${snap.size} items');
  });

  Future<void> _search() => _safe('search', () async {
    final snap = await _notes.get();
    final filtered =
        snap.docs
            .where(
              (d) =>
                  (d.data()[NoteKey.title] as String? ?? '').contains('Note'),
            )
            .toList();
    _log_(
      'Search "Note": ${filtered.length} items: '
      '${filtered.map((d) => d.data()[NoteKey.title]).join(", ")}',
    );
  });

  Future<void> _count() => _safe('count', () async {
    final snap = await _notes.count().get();
    _log_('Count: ${snap.count}');
  });

  Future<void> _batch() => _safe('batch', () async {
    final batch = _db.batch();
    batch.set(_noteDoc('batch_1'), {
      NoteKey.id: 'batch_1',
      NoteKey.title: 'Batch one',
      NoteKey.body: 'created via batch',
      NoteKey.color: 'green',
    });
    batch.set(_noteDoc('batch_2'), {
      NoteKey.id: 'batch_2',
      NoteKey.title: 'Batch two',
      NoteKey.body: 'created via batch',
      NoteKey.color: 'blue',
    });
    batch.update(_noteDoc('batch_1'), {NoteKey.pinned: true});
    await batch.commit();
    _log_('Batch committed: 3 ops');
  });

  Future<void> _transaction() => _safe('transaction', () async {
    final result = await _db.runTransaction<int>((txn) async {
      final ref = _noteDoc('counter_doc');
      final snap = await txn.get(ref);
      final current = (snap.data()?[NoteKey.views] as int?) ?? 0;
      final next = current + 1;
      txn.set(ref, {
        NoteKey.id: 'counter_doc',
        NoteKey.title: 'Counter',
        NoteKey.body: 'Atomic counter',
        NoteKey.views: next,
      });
      return next;
    });
    _log_('Txn committed: counter = $result');
  });

  Future<void> _subcollection() => _safe('subcollection', () async {
    final ref = _noteDoc(_id).collection('comments').doc('c1');
    await ref.set({
      'id': 'c1',
      'text': 'A nested comment',
      'createdAt': InAppFieldValue.serverTimestamp(true),
    });
    final snap = await ref.get();
    _log_('Subcollection: ${snap.exists ? snap.data() : "missing"}');
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(title: const Text('InAppDatabase Test')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Section('Write Operations'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _btn('Create', _create),
                    _btn('CreateRandom (add)', _createRandom),
                    _btn('Update', _update),
                    _btn('Set Merge', _setMerge),
                    _btn('Toggle Pin', _toggle),
                    _btn('Remove Tag', _removeTag),
                    _btn('Delete Field', _deleteField),
                    _btn('Batch (3 ops)', _batch),
                    _btn('Transaction', _transaction),
                    _btn('Subcollection', _subcollection),
                  ],
                ),
                const SizedBox(height: 12),
                const _Section('Read Operations'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _btn('Check By Id', _checkById),
                    _btn('Get All', _get),
                    _btn('Get By Id', _getById),
                    _btn('Query (color)', _query),
                    _btn('whereIn', _queryWhereIn),
                    _btn('arrayContains', _queryArrayContains),
                    _btn('Range', _queryRange),
                    _btn('Search', _search),
                    _btn('Count', _count),
                  ],
                ),
                const SizedBox(height: 12),
                const _Section('Destructive'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _btn('Delete By Id', () => _delete(_id)),
                    _btn('Clear All', _deleteAll),
                  ],
                ),
                const Divider(),
                if (_log.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.black26,
                    child: Text(
                      _log,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                const _Section('Listen Count (count().snapshots())'),
                StreamBuilder<InAppAggregateQuerySnapshot>(
                  stream: _notes.count().snapshots(),
                  builder: (context, s) {
                    return Text('Total notes: ${s.data?.count ?? 0}');
                  },
                ),
                const Divider(),
                const _Section('Listen By Id (doc().snapshots())'),
                StreamBuilder<InAppDocumentSnapshot>(
                  stream: _noteDoc(_id).snapshots(),
                  builder: (context, s) {
                    if (!s.hasData) return const Text('Loading...');
                    final snap = s.data!;
                    if (!snap.exists) return const Text('No data');
                    final n = Note.fromSnapshot(snap);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(n.title),
                      subtitle: Text('${n.body} | pinned: ${n.pinned}'),
                      trailing: Text(n.color),
                    );
                  },
                ),
                const Divider(),
                const _Section('Listen All (collection.snapshots())'),
                StreamBuilder<InAppQuerySnapshot>(
                  stream: _notes.snapshots(),
                  builder: (context, s) {
                    final docs = s.data?.docs ?? const [];
                    if (docs.isEmpty) return const Text('No data');
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.take(5).length,
                      itemBuilder: (_, i) {
                        final n = Note.fromSnapshot(docs[i]);
                        return ListTile(
                          onLongPress: () => _delete(n.id),
                          contentPadding: EdgeInsets.zero,
                          title: Text(n.title),
                          subtitle: Text('${n.color} | ${n.tags.join(", ")}'),
                          trailing: Text('Pinned: ${n.pinned}'),
                        );
                      },
                    );
                  },
                ),
                const Divider(),
                const _Section('Listen By Query (where + orderBy)'),
                StreamBuilder<InAppQuerySnapshot>(
                  stream:
                      _notes
                          .where(NoteKey.pinned, isEqualTo: true)
                          .orderBy(NoteKey.createdAt, descending: true)
                          .limit(10)
                          .snapshots(),
                  builder: (context, s) {
                    final docs = s.data?.docs ?? const [];
                    if (docs.isEmpty) return const Text('No pinned notes');
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.take(5).length,
                      itemBuilder: (_, i) {
                        final n = Note.fromSnapshot(docs[i]);
                        return ListTile(
                          onLongPress: () => _delete(n.id),
                          contentPadding: EdgeInsets.zero,
                          title: Text(n.title),
                          subtitle: Text('${n.color} | ${n.tags.join(", ")}'),
                          trailing: Text('Views: ${n.views}'),
                        );
                      },
                    );
                  },
                ),
                const Divider(),
                const _Section('Listen Subcollection'),
                StreamBuilder<InAppQuerySnapshot>(
                  stream: _noteDoc(_id).collection('comments').snapshots(),
                  builder: (context, s) {
                    final docs = s.data?.docs ?? const [];
                    if (docs.isEmpty) return const Text('No comments');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          docs
                              .take(5)
                              .map(
                                (d) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    d.data()['text']?.toString() ?? '',
                                  ),
                                  subtitle: Text('id: ${d.id}'),
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap) {
    return ElevatedButton(onPressed: onTap, child: Text(label));
  }
}

class _Section extends StatelessWidget {
  final String title;

  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
