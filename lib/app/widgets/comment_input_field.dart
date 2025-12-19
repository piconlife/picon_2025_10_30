import 'package:flutter/material.dart';

typedef CommentInputFieldWidgetBuilder<T> =
    Widget Function(BuildContext context, T value);

class CommentInputField extends StatefulWidget {
  final String? text;
  final String? hint;
  final CommentInputFieldWidgetBuilder<String>? sendButton;

  const CommentInputField({super.key, this.text, this.hint, this.sendButton});

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  late TextEditingController editor = TextEditingController(
    text: widget.text ?? '',
  );

  @override
  void didUpdateWidget(covariant CommentInputField oldWidget) {
    if (widget.text != oldWidget.text) {
      editor.dispose();
      editor = TextEditingController(text: widget.text ?? '');
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    editor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
    );
    return TextField(
      controller: editor,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.white.withValues(alpha: .5)),
        ),
        hintText: widget.hint ?? "Type here...",
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        suffixIcon: _buildSubmitButton(),
        suffixIconConstraints: BoxConstraints(maxHeight: 40, minHeight: 40),
      ),
    );
  }

  Widget? _buildSubmitButton() {
    if (widget.sendButton == null) return null;
    return ListenableBuilder(
      listenable: editor,
      builder: (context, child) {
        return widget.sendButton!(context, editor.text.trim());
      },
    );
  }
}
