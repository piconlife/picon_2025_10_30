import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';
import '../dialogs/bsd_feed_format.dart';

class CreateANotePage extends StatelessWidget {
  const CreateANotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: InAppAppbar(titleText: FeedFormats.note.title));
  }
}
