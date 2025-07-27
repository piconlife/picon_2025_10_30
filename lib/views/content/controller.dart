part of 'view.dart';

class ContentViewController extends ViewController {
  String? header;
  String? description;
  DotStyle dotStyle = DotStyle.bullet;
  List<Content> paragraphs = [];
  ContentStyle paragraphStyle = const ContentStyle();
  ContentStyle? _titleStyle;

  ContentViewController fromContentView(ContentView view) {
    super.fromView(view);
    header = view.header;
    description = view.description;
    dotStyle = view.dotStyle ?? DotStyle.bullet;
    paragraphs = view.paragraphs ?? [];
    paragraphStyle = view.paragraphStyle ?? const ContentStyle();
    _titleStyle = view.titleStyle;
    return this;
  }

  ContentStyle get titleStyle {
    return _titleStyle ??
        paragraphStyle.copy(
          fontWeight: FontWeight.bold,
        );
  }

  set titleStyle(ContentStyle value) => _titleStyle = value;
}
