part of 'view.dart';

enum ViewScrollingType {
  always(physics: AlwaysScrollableScrollPhysics()),
  bouncing(physics: BouncingScrollPhysics()),
  clamping(physics: ClampingScrollPhysics()),
  fixed(physics: FixedExtentScrollPhysics()),
  never(physics: NeverScrollableScrollPhysics()),
  page(physics: PageScrollPhysics()),
  range(physics: RangeMaintainingScrollPhysics()),
  none;

  final ScrollPhysics? physics;

  const ViewScrollingType({this.physics});
}
