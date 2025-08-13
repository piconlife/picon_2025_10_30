import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/utils/image_provider.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/texted_action.dart';
import '../widgets/editable_image.dart';

class ChoosePhotoPage extends StatefulWidget {
  final Object? args;

  const ChoosePhotoPage({super.key, this.args});

  @override
  State<ChoosePhotoPage> createState() => _ChoosePhotoPageState();
}

class _ChoosePhotoPageState extends State<ChoosePhotoPage> {
  late final provider = EditablePhotoProvider(
    widget.args.findOrNull(key: "List<$EditablePhoto>"),
  );

  void _submit(BuildContext context) {
    context.close(
      result: EditablePhotoFeedback(
        currents: List<EditablePhoto>.from(provider.photos),
        deletes: List<EditablePhoto>.from(provider.removes),
      ),
    );
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Scaffold(
      appBar: InAppAppbar(
        titleText: "Photos",
        actions: [InAppTextedAction("Done", onTap: () => _submit(context))],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListenableBuilder(
            listenable: provider,
            builder: (context, child) {
              final value = provider.photos;
              if (value.isEmpty) {
                return Align(
                  alignment: const Alignment(0, -0.2),
                  child: InAppException(
                    "Not photos choosing yet!",
                    icon: InAppIcons.photo.regular,
                    style: TextStyle(
                      fontSize: dimen.largeFontSize,
                      fontWeight: dimen.lightFontWeight,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: value.length + (provider.status.isLoading ? 5 : 0),
                padding: EdgeInsets.only(bottom: dimen.dp(100)),
                itemBuilder: (context, index) {
                  final item = value.elementAtOrNull(index);
                  return ChoosingEditableImage(
                    photo: item,
                    onCropped: () => provider.crop(context, index),
                    onRemoved: () => provider.remove(index),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: dimen.dp(4));
                },
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: dimen.dp(24),
            child: Center(
              child: InAppFilledButton(
                text: "Choose",
                width: dimen.width * 0.65,
                onTap: provider.choose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
