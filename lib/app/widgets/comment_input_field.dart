import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../roots/widgets/icon.dart';
import '../res/icons.dart';

class CommentInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const CommentInputField({super.key, required this.onChanged});

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final editor = TextEditingController();

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
        hintText: "Type something...",
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        suffixIcon: _buildSubmitButton(),
        suffixIconConstraints: BoxConstraints(maxHeight: 40, minHeight: 40),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ListenableBuilder(
      listenable: editor,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: InAppIcon(
            editor.text.isEmpty ? InAppIcons.add.solid : InAppIcons.send.solid,
            color: context.primary,
          ),
        );
      },
    );
  }
}
