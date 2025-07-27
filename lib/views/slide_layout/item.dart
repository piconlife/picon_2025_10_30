part of 'view.dart';

class _Item<T> extends StatefulWidget {
  final SlideLayoutController<T> controller;
  final OnSlideLayoutItemBuilder<T> itemBuilder;

  const _Item({
    super.key,
    required this.controller,
    required this.itemBuilder,
  });

  @override
  State<_Item<T>> createState() => _ItemState<T>();
}

class _ItemState<T> extends State<_Item<T>> {
  late PageController pager;
  late TextViewController tvCounter;
  late SlideLayoutController<T> controller;

  @override
  void initState() {
    controller = widget.controller;
    pager = controller.pager;
    tvCounter = controller.tvCounter;
    super.initState();
  }

  @override
  void dispose() {
    controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = controller.items;
    final size = controller.size;
    return AspectRatio(
      aspectRatio: controller.frameRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pager,
            itemCount: size,
            onPageChanged: controller._changeIndex,
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, index, items[index]);
            },
          ),
          ViewObserver(
            visibility: controller.counterVisible,
            positionType: controller.counterPosition,
            observer: controller.index,
            builder: (context, value) {
              if (controller.counterBuilder != null) {
                return controller.counterBuilder!(
                  context,
                  value,
                  controller.size,
                  controller.item,
                );
              } else {
                return TextView(
                  gravity: Alignment.center,
                  controller: tvCounter,
                  background: Colors.black.withOpacity(0.75),
                  borderRadius: 25,
                  margin: 12,
                  paddingVertical: 8,
                  paddingHorizontal: 12,
                  text: controller.countingText(value + 1, size),
                  textColor: Colors.white,
                  textSize: 12,
                  maxLines: 1,
                  visibility: size > 1,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
