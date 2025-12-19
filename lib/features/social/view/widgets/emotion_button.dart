import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../roots/utils/sound.dart';
import '../../../../roots/widgets/animated_button.dart';
import '../../../../roots/widgets/popup.dart';

enum Emotions {
  like('Like', true),
  love('Love', true),
  wow('Wow', true),
  care('Care', true),
  sad('Sad', true),
  haha('Haha', true),
  angry('Angry', true);

  final bool anim;
  final String label;

  const Emotions(this.label, this.anim);

  String get png => "assets/reacts/$name.png";

  String get gif => "assets/reacts/$name.gif";

  String get lottie => "assets/reacts/$name.json";

  static Emotions? tryParse(Object? source) {
    if (source is Emotions) return source;
    try {
      return values.firstWhere((e) {
        if (e.index == source) return true;
        if (e.name == source.toString().toLowerCase()) return true;
        if (e.toString().toLowerCase() == source.toString().toLowerCase()) {
          return true;
        }
        return false;
      });
    } catch (_) {
      return null;
    }
  }
}

enum EmotionAnimation {
  lottie,
  gif,
  none;

  bool get isAnim => isGif || isLottie;

  bool get isNone => this == none;

  bool get isGif => this == gif;

  bool get isLottie => this == lottie;
}

class Emotion extends StatefulWidget {
  final EmotionAnimation animation;
  final Object? data;
  final double? size;

  const Emotion(
    this.data, {
    super.key,
    this.animation = EmotionAnimation.none,
    this.size,
  });

  @override
  State<Emotion> createState() => _EmotionState();
}

class _EmotionState extends State<Emotion> {
  late Emotions? data = Emotions.tryParse(widget.data);

  @override
  void didUpdateWidget(covariant Emotion oldWidget) {
    if (widget.data != oldWidget.data) {
      data = Emotions.tryParse(widget.data);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return SizedBox();
    final size = widget.size ?? Theme.of(context).iconTheme.size ?? 24;
    return !widget.animation.isAnim
        ? Image.asset(data!.png, width: size, height: size)
        : widget.animation.isLottie && data!.anim
        ? Lottie.asset(data!.lottie, width: size, height: size)
        : Image.asset(data!.gif, width: size, height: size);
  }
}

class EmotionStack extends StatelessWidget {
  final double iconSize;
  final double? iconOffset;
  final TextDirection? textDirection;
  final List<Emotions> emotions;

  const EmotionStack({
    super.key,
    required this.emotions,
    this.iconSize = 24,
    this.iconOffset,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final emotions = this.emotions;
    final offset = iconOffset ?? (iconSize * 0.5);
    final itemCount = emotions.length;
    return SizedBox(
      width: iconSize + (offset * (itemCount - 1)),
      height: iconSize,
      child: Stack(
        textDirection: textDirection,
        children:
            List.generate(emotions.length, (index) {
              final emotion = emotions.elementAt(index);
              Widget child = Image.asset(
                emotion.png,
                width: iconSize,
                height: iconSize,
              );
              return Positioned(left: offset * index, child: child);
            }).reversed.toList(),
      ),
    );
  }
}

class EmotionButton extends StatefulWidget {
  final EmotionAnimation animation;
  final Object? initial;
  final bool darkTheme;
  final List<Emotions>? emotions;
  final int quantityPerPage;
  final double iconSize;
  final double iconSpacing;
  final Function(Emotions?)? onTap;
  final Function(Emotions)? onChanged;
  final Widget Function(BuildContext context, Emotions? emotion) builder;

  const EmotionButton({
    super.key,
    this.animation = EmotionAnimation.gif,
    this.darkTheme = false,
    this.quantityPerPage = 5,
    this.iconSize = 24,
    this.iconSpacing = 6,
    this.emotions,
    this.onTap,
    this.onChanged,
    this.initial,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() => _EmotionButtonState();
}

class _EmotionButtonState extends State<EmotionButton> {
  late final _pageController = PageController(initialPage: 0);
  late final _pages = (widget.emotions ?? Emotions.values).slices(5).toList();

  late Emotions? _emotion = Emotions.tryParse(widget.initial);

  void _tap() async {
    setState(() {
      _emotion = widget.initial != null ? null : Emotions.like;
    });
    if (widget.onTap != null) {
      if (widget.initial == null) kSounds.pop();
      widget.onTap?.call(_emotion);
    }
  }

  void _hold(Emotions item) {
    setState(() {
      _emotion = item;
      widget.onChanged?.call(item);
    });
  }

  @override
  void didUpdateWidget(covariant EmotionButton oldWidget) {
    if (widget.initial != oldWidget.initial) {
      _emotion = Emotions.tryParse(widget.initial);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.iconSize + widget.iconSpacing * 2;
    return Popup(
      onTap: _tap,
      showOnTap: false,
      showOnDoubleTap: true,
      showOnLongPressed: true,
      contentBuilder: (context, hide) {
        return Container(
          height: size,
          width: size * widget.quantityPerPage,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.darkTheme ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
          ),
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            clipBehavior: Clip.none,
            children: List.generate(_pages.length, (pageIndex) {
              final page = _pages[pageIndex];
              final extra = pageIndex == _pages.length - 1 ? 0 : 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(page.length + extra, (index) {
                  final item = page.elementAtOrNull(index);
                  return AnimatedButton(
                    onTap: () {
                      kSounds.pop();
                      hide();
                      if (item != null) _hold(item);
                    },
                    onLongPress: () {
                      kSounds.pop();
                      hide();
                      if (item != null) _hold(item);
                    },
                    animations: [
                      Animations.scale(begin: 1.2),
                      Animations.slide(),
                    ],
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(widget.iconSpacing),
                      width: size,
                      height: size,
                      child: FittedBox(
                        child:
                            item == null
                                ? DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        widget.darkTheme
                                            ? Colors.white.withValues(
                                              alpha: 0.2,
                                            )
                                            : Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      widget.iconSize * 0.1,
                                    ),
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.add,
                                        color:
                                            widget.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                                : Emotion(
                                  item,
                                  animation: widget.animation,
                                  size: widget.iconSize,
                                ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      position: PopupPosition.top,
      arrowSize: 0,
      child: widget.builder(context, _emotion),
    );
  }
}
