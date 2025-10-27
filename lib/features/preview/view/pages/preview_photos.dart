import 'dart:ui';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_entity/entity.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../data/constants/keys.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/photo.dart';
import '../../../../data/use_cases/photo/update.dart';
import '../../../../roots/widgets/image.dart';
import 'photos/comments.dart';
import 'photos/photos.dart';

class PreviewPhotosPage extends StatefulWidget {
  final Object? args;

  const PreviewPhotosPage({super.key, this.args});

  @override
  State<PreviewPhotosPage> createState() => _PreviewPhotosPageState();
}

class _PreviewPhotosPageState extends State<PreviewPhotosPage> {
  int pageType = 0;
  int index = 0;
  Content? content;
  List<Content> photos = [];

  late final controller = PageController(initialPage: index);

  Content get selected => photos.elementAtOrNull(index) ?? Content.empty();

  Future<Response<Photo>> _update(int index, Map<String, dynamic> data) async {
    final old = photos[index];
    return UpdateFeedPhotoUseCase.i.call(
      referencePath: old.path.use,
      id: old.id,
      data: data,
    );
  }

  void _changePrivacy(Privacy privacy) {
    final data = photos.removeAt(index);
    photos.insert(index, data.change(privacy: privacy));
    setState(() {});
    _update(index, {Keys.i.privacy: privacy.name});
  }

  void _updateTag(String? tag) async {
    final data = photos.removeAt(index);
    photos.insert(index, data.change(description: tag));
    setState(() {});
    _update(index, {Keys.i.description: tag});
  }

  void _changedIndex(int value) {
    if (index == value) return;
    setState(() => index = value);
  }

  void _changedPageType(int value) {
    setState(() => pageType = value);
  }

  @override
  void initState() {
    super.initState();
    index = widget.args.find(key: "index", defaultValue: 0);
    content = widget.args.findOrNull(key: "$Content");
    photos = List.from(content?.photos ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          InAppImage(selected.photoUrl, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ColoredBox(color: context.darkAsFixed.t80),
          ),
          IndexedStack(
            index: pageType,
            children: [
              PhotoPreviewView(
                index: index,
                photos: List.from(photos),
                onChanged: _changedIndex,
                onChangedPageType: _changedPageType,
                onChangePrivacy: _changePrivacy,
                onUpdateTag: _updateTag,
              ),
              PhotoCommentsView(
                photo: selected,
                onChangedPageType: _changedPageType,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
