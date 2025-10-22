import 'dart:ui';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_entity/entity.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../data/enums/privacy.dart';
import '../../../../data/models/photo.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/photo/update.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../routes/keys.dart';
import 'photos/comments.dart';
import 'photos/photos.dart';

class PreviewPhotosPage extends StatefulWidget {
  final Object? args;

  const PreviewPhotosPage({super.key, this.args});

  @override
  State<PreviewPhotosPage> createState() => _PreviewPhotosPageState();
}

class _PreviewPhotosPageState extends State<PreviewPhotosPage> {
  int pageType = 1;
  int index = 0;
  UserPost? content;
  List<Photo> photos = [];

  late final controller = PageController(initialPage: index);

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
    data.privacy = privacy;
    photos.insert(index, data);
    setState(() {});
    _update(index, {PhotoKeys.privacy: privacy.name});
  }

  void _updateTag(String? tag) async {
    final data = photos.removeAt(index);
    data.description = tag;
    photos.insert(index, data);
    setState(() {});
    _update(index, {PhotoKeys.description: tag});
  }

  void _changedIndex(int value) {
    setState(() => index = value);
  }

  @override
  void initState() {
    super.initState();
    index = widget.args.find(key: "index", defaultValue: 0);
    content = widget.args.findOrNull(key: kRouteData);
    photos = List.from(content?.photos ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      dark: true,
      child: Scaffold(
        backgroundColor: context.darkAsFixed,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            InAppImage(photos.firstOrNull?.photoUrl, fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: ColoredBox(color: context.darkAsFixed.t80),
            ),
            IndexedStack(
              sizing: StackFit.expand,
              index: pageType,
              children: [
                PhotoPreviewView(
                  index: index,
                  photos: List.from(photos),
                  onChanged: _changedIndex,
                  onChangePrivacy: _changePrivacy,
                  onUpdateTag: _updateTag,
                ),
                PhotoCommentsView(photo: photos.elementAt(index)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
