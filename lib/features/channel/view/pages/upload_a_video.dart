import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';
import '../dialogs/bsd_metube_format.dart';

class UploadAVideoPage extends StatelessWidget {
  const UploadAVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InAppAppbar(titleText: MetubeFormats.uploadAVideo.title),
    );
  }
}
