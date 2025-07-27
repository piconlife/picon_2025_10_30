part of 'view.dart';

class Underline extends StatelessWidget {
  final Color? color;
  final bool active;
  final double height;

  const Underline({
    super.key,
    this.color,
    this.active = true,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: active ? 0 : height),
      decoration: BoxDecoration(color: color),
      height: active ? height * 2 : height,
    );
  }
}
