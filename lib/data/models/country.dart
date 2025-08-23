import '../constants/keys.dart';
import 'content.dart';

List<String> _keys = [Keys.i.id, Keys.i.name];

class Country extends Content {
  Country({super.id, super.name});

  Country withCountry({String? id, String? name}) {
    return Country(id: id ?? this.id, name: name ?? this.name);
  }

  factory Country.from(Object? source) {
    final data = Content.parse(source);
    return Country(id: data.id, name: data.name);
  }

  @override
  Map<String, dynamic> get source {
    final data = super.source.entries.where((item) => _keys.contains(item.key));
    return Map.fromEntries(data);
  }
}
