import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';
import 'package:marquee/marquee.dart';

import '../../../../../app/base/data_cubit.dart';
import '../../../../../app/helpers/user.dart';
import '../../../../../app/interfaces/bsd_privacy.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../data/enums/privacy.dart';
import '../../../../../data/models/content.dart';
import '../../../../../data/models/like.dart';
import '../../../../../data/models/view.dart';
import '../../../../../roots/utils/utils.dart';
import '../../../../../roots/widgets/gesture.dart';
import '../../../../../roots/widgets/hero.dart';
import '../../../../../roots/widgets/icon.dart';
import '../../../../../roots/widgets/image.dart';
import '../../../../../roots/widgets/layout.dart';
import '../../../../../roots/widgets/pleasure_button.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../roots/widgets/transfluent_app_bar.dart';
import '../../../../../routes/keys.dart';
import '../../../../social/data/cubits/like_cubit.dart';
import '../../../../social/data/cubits/view_cubit.dart';
import '../../../../social/view/pages/likes.dart';
import 'expandable_text.dart';

class PhotoPreviewView extends StatefulWidget {
  final bool cubitApplied;
  final String path;
  final int index;
  final List<ContentModel> photos;
  final ValueChanged<int> onChanged;
  final ValueChanged<int> onChangedPageType;
  final ValueChanged<Privacy> onChangePrivacy;
  final ValueChanged<String?> onUpdateTag;

  const PhotoPreviewView({
    super.key,
    this.cubitApplied = false,
    this.index = 0,
    required this.path,
    required this.photos,
    required this.onChanged,
    required this.onChangedPageType,
    required this.onChangePrivacy,
    required this.onUpdateTag,
  });

  @override
  State<PhotoPreviewView> createState() => _PhotoPreviewViewState();
}

class _PhotoPreviewViewState extends State<PhotoPreviewView> {
  final _isBookmarked = ValueNotifier(false);
  late final _pageController = PageController(initialPage: widget.index);

  late final _downloadLabel = ValueNotifier(isDownloaded ? 2 : 0);

  bool _isExpandedText = false;

  Set<String> downloads = {};

  bool get isLocked => !item.isPrivacyAllow;

  bool get isDownloaded => downloads.contains(item.photoUrl);

  ContentModel get item {
    return widget.photos.elementAtOrNull(widget.index) ?? ContentModel();
  }

  void _onShare() {
    if (!item.photoUrl.isValidWebUrl || !item.isPrivacyAllow) {
      context.showMessage("This content is personal");
      return;
    }
    Utils.share(
      context,
      subject: item.title,
      body: item.description,
      loaderBarrierColor: Colors.black12,
      urls: [item.photoUrl!],
    );
  }

  void _onBookmark() {
    _isBookmarked.value = !_isBookmarked.value;
  }

  void _onChangePrivacy() async {
    if (!UserHelper.isCurrentUser(item.publisherId)) return;
    final feedback = await PrivacyBSD.show(context, item.privacy);
    widget.onChangePrivacy(feedback);
  }

  void _addTag() async {
    final feedback = await context.showEditor(
      title: "Tag here",
      hint: "Write something...",
      content: EditableDialogContent(
        args: {kDialogPositiveButtonTextKey: "SEND"},
      ),
      text: item.description,
    );
    if (feedback.isNotValid) return;
    widget.onUpdateTag(feedback);
  }

  void _removeTag() => widget.onUpdateTag(null);

  void _onMore() async {
    final feedback = await context.showOptions(
      initialIndex: -1,
      title: "Choose action",
      options: [
        "Change privacy",
        item.description.isValid ? "Update description" : "Add description",
        if (item.description.isValid) "Remove description",
      ],
    );
    if (feedback < 0) return;
    final action = [_onChangePrivacy, _addTag, _removeTag][feedback];
    action();
  }

  //     private void downloadPhoto() {
  //         if (mPhoto != null && (!UserCondition.isPrivate(mPhoto.getDocument_privacy()) || UserHelper.isCurrentUid(mPhoto.getUid()))) {
  //             if (!mDownloadedIds.contains(mPhoto.getDid())) {
  //                 mBinding.actionDownload.setText(getString(R.string.downloading));
  //                 mViewModel.downloadBitmap(mPhoto.getDocument_photo_url(), ByteQuality.PHOTO_STANDARD_QUALITY, response -> {
  //                     Bitmap bitmap = response.getResult();
  //                     if (response.isSuccessful() && bitmap != null) {
  //                         MediaProvider.saveImage(mContext, bitmap, task -> {
  //                             if (task.isSuccessful()) {
  //                                 mBinding.actionDownload.setText(getString(R.string.done));
  //                                 mDownloadedIds.add(mPhoto.getDid());
  //                             } else {
  //                                 mBinding.actionDownload.setText(getString(R.string.download));
  //                                 mDialog.toast(ExceptionMessage.EXCEPTION_TRY_AGAIN);
  //                             }
  //                         });
  //                     }
  //                 });
  //             } else {
  //                 mDialog.toast("Already downloaded!");
  //             }
  //         } else {
  //             mDialog.toast("This photo is personal");
  //         }
  //     }
  void _download() async {
    if (isLocked || isDownloaded) return;
    // _downloadLabel.value = 1;
    // downloads.add(item.photoUrl ?? '');
    // _downloadLabel.value = 2;
  }

  void _seeLikes() {
    LikesPage.open(context);
  }

  void _comment() => widget.onChangedPageType(1);

  void _changeIndex(int index) {
    if (widget.index == index) return;
    widget.onChanged(index);
  }

  void _like() {
    DataCubit.of<LikeCubit>(context).toggle();
  }

  void _seen(_) {
    DataCubit.of<ViewCubit>(context).seen(ViewModel.create(path: widget.path));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_seen);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _isBookmarked.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBody(context),
        Positioned(top: 0, left: 0, right: 0, child: _buildToolbar(context)),
        Positioned(bottom: 12, left: 0, right: 0, child: _buildFooter(context)),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return TransfluentAppBar(
      leading: Center(child: _buildLeading(context)),
      actions: [_buildActions(context), SizedBox(width: 8)],
    );
  }

  Widget _buildLeading(BuildContext context) {
    return InAppGesture(
      onTap: context.close,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.light.t05,
        ),
        padding: EdgeInsets.all(context.smallPadding),
        child: InAppIcon(InAppIcons.leading.regular, color: context.light),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.light.t05,
        borderRadius: BorderRadius.circular(context.largestRadius),
      ),
      child: Row(
        children: [
          if (item.isPrivacyAllow) ...[
            _buildAction(context, InAppIcons.share.solid, _onShare),
            _buildActionToggle(
              context,
              InAppIcons.save,
              _onBookmark,
              _isBookmarked,
            ),
          ] else ...[
            _buildActionPrivate(context),
          ],
          if (UserHelper.isCurrentUser(item.publisherId))
            _buildAction(context, InAppIcons.more.regular, _onMore),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context, icon, VoidCallback press) {
    return InAppGesture(
      onTap: press,
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(context.smallPadding),
          child: InAppIcon(icon, color: context.light),
        ),
      ),
    );
  }

  Widget _buildActionToggle(
    BuildContext context,
    AndomieIcon icon,
    VoidCallback press,
    ValueNotifier<bool> notifier,
  ) {
    return InAppGesture(
      onTap: press,
      child: ColoredBox(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(context.smallPadding),
          child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, value, child) {
              return InAppIcon(
                value ? icon.solid : icon.regular,
                color: context.light,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionPrivate(BuildContext context) {
    return InAppGesture(
      onTap:
          UserHelper.isCurrentUser(item.publisherId) ? _onChangePrivacy : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.primary,
        ),
        padding: EdgeInsets.all(context.smallPadding),
        child: InAppIcon(InAppIcons.lock.regular, color: context.light),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isExpandedText) return SizedBox.shrink();
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.photos.length,
      onPageChanged: _changeIndex,
      itemBuilder: _buildBodyItem,
    );
  }

  Widget _buildBodyItem(BuildContext context, int index) {
    final item = widget.photos[index];
    final url = item.photoUrl;
    return Align(
      alignment: Alignment(0, -0.1),
      child: InAppHero(
        tag: url,
        child: InAppImage(url, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        left: context.normalPadding,
        right: context.normalPadding,
        top: context.dp(50),
        bottom: MediaQuery.maybePaddingOf(context)?.bottom ?? 0,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.smallerSpace),
            child: InAppLayout(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (expanded) ...[
                  _buildDescription(context),
                  context.smallSpace.h,
                ],
                Row(
                  children: [
                    if (widget.photos.length > 1) _buildIndicator(context),
                    _buildCounter(context),
                    if (item.description.isValid && !expanded) ...[
                      context.smallSpace.w,
                      Expanded(child: _buildDescription(context)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          context.smallSpace.h,
          Row(
            children: [
              Expanded(child: _buildDownloadButton(context)),
              SizedBox(width: context.smallSpace),
              _buildLikeButton(context),
              SizedBox(width: context.smallSpace),
              _buildCommentButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    if (widget.photos.length < 2) return SizedBox.shrink();
    if (widget.photos.length > 5) return _buildIndicatorText(context);
    return _buildIndicators(context);
  }

  Widget _buildIndicators(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: context.normalSpace),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.photos.length, (index) {
          final selected = widget.index == index;
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(context.dp(selected ? 2 : 3)),
            margin: EdgeInsets.only(right: context.smallerSpace),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.transparent : context.lightAsFixed.t50,
              border:
                  selected
                      ? Border.all(
                        color: context.lightAsFixed,
                        width: context.dp(3.5),
                      )
                      : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildIndicatorText(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: context.dp(12)),
      padding: EdgeInsets.only(
        left: context.dp(6),
        right: context.dp(8),
        top: context.dp(3),
        bottom: context.dp(3),
      ),
      decoration: BoxDecoration(
        color: context.lightAsFixed.t10,
        borderRadius: BorderRadius.circular(context.smallRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InAppIcon(
            InAppIcons.nativePhotoLibrary.solid,
            size: context.smallerIconSize * 0.9,
            color: context.lightAsFixed,
          ),
          SizedBox(width: context.smallSpace),
          InAppText(
            "${widget.index + 1}/${widget.photos.length}",
            style: TextStyle(
              color: context.lightAsFixed,
              fontSize: context.normalFontSize,
              fontWeight: context.mediumFontWeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    final style = TextStyle(
      color: context.lightAsFixed,
      fontWeight: context.mediumFontWeight,
      fontSize: context.normalFontSize,
    );
    Widget likes(int count) {
      return InAppGesture(
        onTap: widget.cubitApplied ? _seeLikes : null,
        child: InAppText(Converter.toKMB(count, "Like", "Likes"), style: style),
      );
    }

    Widget views(int count) {
      return InAppText(Converter.toKMB(count, "View", "Views"), style: style);
    }

    return InAppLayout(
      layout: LayoutType.row,
      children: [
        widget.cubitApplied
            ? BlocBuilder<LikeCubit, Response<LikeModel>>(
              builder: (context, value) => likes(value.count),
            )
            : likes(0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.smallSpace),
          child: InAppText("-", style: style),
        ),
        widget.cubitApplied
            ? BlocBuilder<ViewCubit, Response<ViewModel>>(
              builder: (context, value) => views(value.count),
            )
            : views(0),
      ],
    );
  }

  final _descriptionController = ScrollController();

  bool get expanded => item.description.use.length >= 100;

  Widget _buildDescription(BuildContext context) {
    final style = TextStyle(
      color: context.lightAsFixed.t75,
      fontSize: context.mediumFontSize,
    );

    if (!expanded) {
      return SizedBox(
        height: context.dp(24),
        child: Marquee(
          text: item.description.use,
          blankSpace: context.dp(8),
          fadingEdgeStartFraction: 0.1,
          fadingEdgeEndFraction: 0.1,
          style: style,
        ),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: context.h * 0.8),
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: _descriptionController,
          child: AndrossyExpandableText(
            item.description.use,
            expandedText: '',
            charDuration: Duration.zero,
            style: style,
            onChanged: (value) {
              setState(() => _isExpandedText = value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _downloadLabel,
      builder: (context, state, child) {
        return InAppGesture(
          onTap: isDownloaded || isLocked ? null : _download,
          child: Container(
            decoration: BoxDecoration(
              color: context.lightAsFixed.t75,
              borderRadius: BorderRadius.circular(context.largestRadius),
            ),
            padding: EdgeInsets.all(context.smallPadding),
            alignment: Alignment.center,
            child: InAppText(
              ["Download", "Downloading...", "Downloaded", "Locked"][isLocked
                  ? 3
                  : isDownloaded
                  ? 2
                  : state],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.darkAsFixed,
                fontSize: context.mediumFontSize,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    Widget child(bool activated) {
      return InAppPleasureButton(
        icon: activated ? InAppIcons.heart.solid : InAppIcons.heart.regular,
        iconColor:
            activated
                ? context.red
                : (widget.cubitApplied
                    ? context.lightAsFixed
                    : context.lightAsFixed.withValues(alpha: 0.5)),
        onTap: widget.cubitApplied ? _like : null,
      );
    }

    if (!widget.cubitApplied) return child(false);

    return BlocBuilder<LikeCubit, Response<LikeModel>>(
      builder: (context, value) {
        return child(value.isExistByMe);
      },
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return InAppPleasureButton(
      onTap: widget.cubitApplied ? _comment : null,
      icon: InAppIcons.commentWithTreeDots.regular,
      iconColor:
          widget.cubitApplied
              ? context.lightAsFixed
              : context.lightAsFixed.withValues(alpha: 0.5),
    );
  }
}
