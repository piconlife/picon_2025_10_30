import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/text_button.dart';

class InAppUploadingImage extends StatelessWidget {
  final dynamic data;
  final double progress;
  final bool progressing;
  final bool loading;
  final bool processing;
  final bool processingError;
  final bool internetError;
  final bool error;
  final VoidCallback? tryAgain;

  const InAppUploadingImage({
    super.key,
    this.data,
    this.progress = 0,
    this.loading = false,
    this.progressing = false,
    this.processing = false,
    this.processingError = false,
    this.internetError = false,
    this.error = false,
    this.tryAgain,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final loadingMode = loading || progressing || processing;
    final errorMode = (internetError || error) && tryAgain != null;
    return Container(
      width: double.infinity,
      color: dark.t05,
      child: Stack(
        children: [
          InAppImage(data, width: double.infinity, fit: BoxFit.fitWidth),
          if (loadingMode || errorMode)
            Positioned.fill(
              child: ColoredBox(
                color: dark.t50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (errorMode)
                      Positioned.fill(
                        child: Center(
                          child: InAppTextButton(
                            "Try again",
                            style: TextStyle(color: context.light),
                            onTap: tryAgain,
                          ),
                        ),
                      ),
                    if (loadingMode) ...[
                      SizedBox(
                        width: dimen.width * 0.2,
                        height: dimen.width * 0.2,
                        child: CircularProgressIndicator(
                          value: loading || processing ? null : progress / 100,
                          backgroundColor: context.primary.t25,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      if (!processing)
                        InAppText(
                          "${progress.toInt()}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dimen.width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
