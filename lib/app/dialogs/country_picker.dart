import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/models/country.dart';

import '../../roots/preferences/preferences.dart';

enum CountryPickerType {
  phone,
  currency,
  country,
  language;

  bool get isPhone => this == phone;

  bool get isCurrency => this == currency;

  bool get isCountry => this == country;

  bool get isLanguage => this == language;
}

class CountryPicker extends StatefulWidget {
  final List<Country>? supportedCountries;
  final CountryPickerType type;

  const CountryPicker({super.key, this.supportedCountries, required this.type});

  static Future<Country?>? _show(
    BuildContext context,
    CountryPickerType type, [
    List<Country>? supportedCountries,
  ]) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (context) =>
          CountryPicker(type: type, supportedCountries: supportedCountries),
    );
  }

  static Future<Country?>? country(
    BuildContext context, [
    List<Country>? supportedCountries,
  ]) {
    return _show(context, CountryPickerType.country, supportedCountries);
  }

  static Future<Country?>? currency(
    BuildContext context, [
    List<Country>? supportedCountries,
  ]) {
    return _show(context, CountryPickerType.currency, supportedCountries);
  }

  static Future<Country?>? language(
    BuildContext context, [
    List<Country>? supportedCountries,
  ]) {
    return _show(context, CountryPickerType.language, supportedCountries);
  }

  static Future<Country?>? phone(
    BuildContext context, [
    List<Country>? supportedCountries,
  ]) {
    return _show(context, CountryPickerType.phone, supportedCountries);
  }

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final controller = TextEditingController();

  Iterable<Country> recent = [];
  Iterable<Country> temp = [];
  Set<String> codes = {};
  List<Country> roots = [];
  List<Country> countries = [];

  String get _key => "__country_picker_${widget.type.name}__";

  @override
  void initState() {
    super.initState();
    roots = kCountries.toList();
    countries = List.from(roots);
    codes = Preferences.getStrings(_key).toSet();
    recent = roots.where((e) => codes.contains(e.code));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      if (query.isNotEmpty) {
        if (recent.isNotEmpty) temp = recent;
        recent = [];
        countries = List<Country>.from(roots).where((e) {
          switch (widget.type) {
            case CountryPickerType.country:
              return e.searchCountry(query);
            case CountryPickerType.phone:
              return e.searchPhone(query);
            case CountryPickerType.currency:
              return e.searchCurrency(query);
            case CountryPickerType.language:
              return e.searchLanguage(query);
          }
        }).toList();
      } else {
        recent = temp;
        countries = List.from(roots);
      }
    });
  }

  void _addRecent(Country country) {
    final code = country.code;
    if (code.isNotEmpty) {
      codes.remove(code);
      codes.add(code);
      Preferences.setStrings(_key, codes);
    }
    Navigator.pop(context, country);
  }

  Widget _searchBar(DimenData dimen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dimen.dp(16)),
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: dimen.dp(18), color: context.dark),
          onChanged: _search,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: dimen.dp(16),
              vertical: dimen.dp(12),
            ),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: context.dark.t50),
            fillColor: context.dark.t05,
            filled: true,
          ),
        ),
      ),
    );
  }

  Widget _header(DimenData dimen) {
    return Center(
      child: Text(
        "Choose your ${widget.type.name}",
        style: TextStyle(
          color: context.dark,
          fontWeight: context.mediumFontWeight,
          fontSize: dimen.dp(18),
        ),
      ),
    );
  }

  Widget _icon(DimenData dimen, String? text) {
    return Text(text ?? '', style: TextStyle(fontSize: dimen.dp(24)));
  }

  Widget _title(DimenData dimen, String? text) {
    return Text(
      text ?? '',
      style: TextStyle(
        color: context.dark,
        fontWeight: context.mediumFontWeight,
      ),
    );
  }

  Widget _subtitle(DimenData dimen, String? text) {
    return Text(text ?? '');
  }

  Widget _trailing(DimenData dimen, String? text) {
    return Text(
      text ?? '',
      style: TextStyle(
        fontSize: dimen.dp(16),
        color: context.dark,
        fontWeight: context.mediumFontWeight,
      ),
    );
  }

  Widget _label(DimenData dimen, String? label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimen.dp(24)),
      child: Text(label ?? '', style: TextStyle(color: context.dark.t50)),
    );
  }

  Widget _item(DimenData dimen, Country item) {
    final type = widget.type;
    return ListTile(
      onTap: () => _addRecent(item),
      leading: _icon(dimen, item.flag),
      title: _title(
        dimen,
        type.isPhone || type.isCountry
            ? item.name
            : type.isCurrency
            ? item.currencyCode
            : item.languageName,
      ),
      subtitle: type.isPhone || type.isCountry
          ? null
          : _subtitle(dimen, type.isCurrency ? item.currencyName : item.name),
      trailing: type.isCountry
          ? null
          : _trailing(
              dimen,
              type.isPhone
                  ? item.phoneCode
                  : type.isCurrency
                  ? item.currencySymbol
                  : item.languageCode,
            ),
      contentPadding: EdgeInsets.only(
        top: dimen.dp(4),
        bottom: dimen.dp(4),
        left: dimen.dp(20),
        right: dimen.dp(24),
      ),
    );
  }

  Widget _divider(DimenData dimen) {
    return Divider(height: 0, indent: dimen.dp(16), endIndent: dimen.dp(16));
  }

  Widget _items(DimenData dimen, [ScrollController? controller]) {
    if (countries.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(dimen.dp(32)),
        child: _label(dimen, "Not match any ${widget.type.name}!"),
      );
    }
    return ListView.separated(
      shrinkWrap: controller == null,
      physics: controller != null ? null : const NeverScrollableScrollPhysics(),
      controller: controller,
      itemCount: countries.length,
      itemBuilder: (context, index) {
        return _item(dimen, countries.elementAt(index));
      },
      separatorBuilder: (context, index) => _divider(dimen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final isRecent = recent.isNotEmpty;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 1,
      minChildSize: 0.5,
      snap: true,
      expand: false,
      builder: (context, controller) {
        return Column(
          children: [
            _header(dimen),
            SizedBox(height: dimen.dp(16)),
            _searchBar(dimen),
            Expanded(
              child: isRecent
                  ? ListView(
                      padding: EdgeInsets.symmetric(vertical: dimen.dp(16)),
                      controller: controller,
                      children: [
                        _label(dimen, "Recent"),
                        const Divider(),
                        ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recent.length,
                          itemBuilder: (context, index) {
                            return _item(dimen, recent.elementAt(index));
                          },
                          separatorBuilder: (context, index) => _divider(dimen),
                        ),
                        _label(dimen, "All"),
                        const Divider(),
                        _items(dimen),
                      ],
                    )
                  : _items(dimen, controller),
            ),
          ],
        );
      },
    );
  }
}
