import 'dart:ui';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_cache/in_app_cache.dart';
import 'package:in_app_navigator/route.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/constants/keys.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/content.dart';
import '../../../../data/use_cases/content/update.dart';
import '../../../../packages/data_management.dart' show DataFieldValue;
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/scaffold.dart';
import '../../../../roots/widgets/transfluent_app_bar.dart';
import '../../../../routes/paths.dart';
import '../../../social/data/cubits/like_cubit.dart';
import '../../../social/data/cubits/view_cubit.dart';
import '../../../user/view/cubits/bookmark_cubit.dart';
import 'photos/comments.dart';
import 'photos/photos.dart';

class PreviewPhotosPage extends StatefulWidget {
  final Object? args;

  const PreviewPhotosPage({super.key, this.args});

  static Future<void> open(
    BuildContext context,
    ContentModel item,
    int index,
  ) async {
    context.open(
      Routes.previewPhotos,
      args: {
        "index": index,
        "$ContentModel": item,
        "$UserBookmarkCubit": DataCubit.of<UserBookmarkCubit>(context),
      },
      configs: RouteConfigs(transitionType: TransitionType.fadeIn),
    );
  }

  @override
  State<PreviewPhotosPage> createState() => _PreviewPhotosPageState();
}

class _PreviewPhotosPageState extends State<PreviewPhotosPage> {
  late final controller = PageController(initialPage: index);
  late final bookmarkCubit = DataCubit.of<UserBookmarkCubit>(context);
  int pageType = 0;
  int index = 0;
  ContentModel? content;
  List<ContentModel> photos = [];

  String path = '';
  LikeCubit? likeCubit;
  ViewCubit? viewCubit;

  ContentModel get selected {
    return photos.elementAtOrNull(index) ?? ContentModel.empty();
  }

  void _init() {
    path = selected.contentPath ?? '';
    if (path.isEmpty) {
      likeCubit = null;
      viewCubit = null;
      return;
    }
    likeCubit = Cache.put<LikeCubit>("like_cubit[$path]", () {
      return LikeCubit(context, path, initialCount: selected.likeCount)
        ..loadCounter()
        ..load(resultByMe: true);
    });
    viewCubit = Cache.put<ViewCubit>("view_cubit[$path]", () {
      return ViewCubit(context, path, initialCount: selected.viewCount)
        ..loadCounter()
        ..load(resultByMe: true);
    });
  }

  Future<void> _update(int index, Map<String, dynamic> data) async {
    final path = photos[index].contentPath.use;
    if (path.isEmpty) return;
    await ContentUpdateUseCase.i.call(path, data);
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
    _init();
  }

  void _changedPageType(int value) {
    setState(() => pageType = value);
  }

  @override
  void initState() {
    super.initState();
    index = widget.args.get("index", 0);
    content = widget.args.getOrNull("$ContentModel");
    photos = List.from(content?.photos ?? []);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty || likeCubit == null || viewCubit == null) {
      return _buildLayout(false);
    }
    return MultiBlocProvider(
      providers: [
        if (likeCubit != null) BlocProvider.value(value: likeCubit!),
        if (viewCubit != null) BlocProvider.value(value: viewCubit!),
      ],
      child: _buildLayout(true),
    );
  }

  Widget _buildLayout(bool cubitApplied) {
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
                cubitApplied: cubitApplied,
                path: path,
                photos: List.from(photos),
                onChanged: _changedIndex,
                onChangedPageType: _changedPageType,
                onChangePrivacy: _changePrivacy,
                onUpdateTag: _updateTag,
              ),
              if (cubitApplied)
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
