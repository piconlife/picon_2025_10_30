import 'dart:ui';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:in_app_navigator/route.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/constants/keys.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/content.dart';
import '../../../../data/use_cases/content/update.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/scaffold.dart';
import '../../../../roots/widgets/transfluent_app_bar.dart';
import '../../../../routes/paths.dart';
import '../../../social/data/cubits/like_cubit.dart';
import '../../../social/data/cubits/view_cubit.dart';
import '../../../social/view/cubits/comment_cubit.dart';
import 'photos/comments.dart';
import 'photos/photos.dart';

class PreviewPhotosPage extends StatefulWidget {
  final Object? args;

  const PreviewPhotosPage({super.key, this.args});

  static Future<void> open(
    BuildContext context,
    Content item,
    int index,
  ) async {
    context.open(
      Routes.previewPhotos,
      args: {
        "index": index,
        "$Content": item,
        "$LikeCubit": DataCubit.of<LikeCubit>(context),
        "$ViewCubit": DataCubit.of<ViewCubit>(context),
        "$CommentCubit": DataCubit.of<CommentCubit>(context),
      },
      configs: RouteConfigs(transitionType: TransitionType.fadeIn),
    );
  }

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

  Future<void> _update(int index, Map<String, dynamic> data) async {
    final path = photos[index].contentPath.use;
    if (path.isEmpty) return;
    await UpdateUseCase.i.call(path, data);
  }

  void _changePrivacy(Privacy privacy) {
    final data = photos.removeAt(index);
    photos.insert(index, data..privacy = privacy);
    setState(() {});
    _update(index, {
      Keys.i.privacy:
          privacy.isEveryone ? DataFieldValue.delete() : privacy.name,
    });
  }

  void _updateTag(String? tag) async {
    final data = photos.removeAt(index);
    photos.insert(index, data..description = tag);
    setState(() {});
    _update(index, {
      Keys.i.description: (tag ?? '').isEmpty ? DataFieldValue.delete() : tag,
    });
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
    index = widget.args.get("index", 0);
    content = widget.args.getOrNull("$Content");
    photos = List.from(content?.photos ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return InAppScaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: TransfluentAppBar(),
      body: InAppLayout(
        fit: StackFit.expand,
        layout: LayoutType.stack,
        children: [
          InAppImage(selected.photoUrl, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ColoredBox(color: context.darkAsFixed.t80),
          ),
          InAppLayout(
            index: pageType,
            layout: LayoutType.stack,
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
