import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';
import '../dialogs/bsd_feed_format.dart';

class CreateAVideoPage extends StatelessWidget {
  const CreateAVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: InAppAppbar(titleText: FeedFormats.video.title));
  }
}
