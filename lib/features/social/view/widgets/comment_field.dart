import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/row.dart';

class CommentField extends StatefulWidget {
  final bool loading;
  final bool fill;
  final ValueChanged<String> onSubmitText;
  final VoidCallback? onAdd;
  final VoidCallback? onEmoji;
  final VoidCallback? onVoice;

  const CommentField({
    super.key,
    this.loading = false,
    this.fill = false,
    required this.onSubmitText,
    this.onAdd,
    this.onEmoji,
    this.onVoice,
  });

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> with ColorMixin {
  final editor = TextEditingController();

  void _submit() {
    final text = editor.text.trim();
    if (text.isEmpty) return;
    widget.onSubmitText(text);
    editor.clear();
  }

  @override
  void dispose() {
    editor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppBottomBar(
      backgroundColor: light,
      elevation: 1,
      shadowBlurRadius: 0,
      ignoreSystemPadding: true,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: InAppRow(
            children: [
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: editor,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    contentPadding: const EdgeInsets.only(left: 12, right: 8),
                    filled: true,
                    fillColor: dark.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ValueListenableBuilder(
                valueListenable: editor,
                builder: (context, value, child) {
                  final enabled = value.text.isNotEmpty && !widget.loading;
                  return InAppGesture(
                    onTap: enabled ? _submit : null,
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(8),
                      child: InAppIcon(
                        InAppIcons.send.regularBold(enabled),
                        color: enabled ? primary : grey,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
