part of 'view.dart';

enum LayoutGravity {
  center(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.center,
  ),
  end(
    main: MainAxisAlignment.end,
    cross: CrossAxisAlignment.end,
  ),
  start(
    main: MainAxisAlignment.start,
    cross: CrossAxisAlignment.start,
  ),
  spaceAround(
    main: MainAxisAlignment.spaceAround,
    cross: CrossAxisAlignment.center,
  ),
  spaceBetween(
    main: MainAxisAlignment.spaceBetween,
    cross: CrossAxisAlignment.center,
  ),
  spaceEvenly(
    main: MainAxisAlignment.spaceEvenly,
    cross: CrossAxisAlignment.center,
  ),
  baseline(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.baseline,
  ),
  stretch(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.stretch,
  ),
  centerVertical(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.start,
  ),
  centerHorizontal(
    main: MainAxisAlignment.start,
    cross: CrossAxisAlignment.center,
  );

  final MainAxisAlignment main;
  final CrossAxisAlignment cross;

  const LayoutGravity({
    required this.main,
    required this.cross,
  });
}
