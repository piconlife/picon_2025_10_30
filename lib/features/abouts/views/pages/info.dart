import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/logo.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/text.dart';

class AboutsContent {
  final String text;
  final dynamic icon;
  final Color? color;
  final VoidCallback? callback;

  const AboutsContent({
    required this.text,
    this.icon,
    this.color,
    this.callback,
  });

  static List<AboutsContent> items = [
    AboutsContent(
      text: "Update",
      color: Color(0xff4BBEEB),
      icon: Icons.update_outlined,
      callback: () {},
    ),
    AboutsContent(
      text: "Support",
      color: Color(0xff4B8BEB),
      icon: Icons.support_outlined,
      callback: () {},
    ),
    AboutsContent(
      text: "Recommend to Friends",
      color: Color(0xff4BEB8B),
      icon: Icons.recommend_outlined,
      callback: () {},
    ),
    AboutsContent(
      text: "Like",
      color: Color(0xffEB9E4B),
      icon: Icons.thumb_up_outlined,
      callback: () {},
    ),
    AboutsContent(
      text: "Privacy and Legal",
      color: Color(0xff4B86EB),
      icon: Icons.privacy_tip_outlined,
      callback: () {},
    ),
  ];
}

class InfoPage extends StatefulWidget {
  final Object? args;

  const InfoPage({super.key, this.args});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with ColorMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light,
      appBar: InAppAppbar(
        backgroundColor: light,
        elevation: 0,
        titleText: "Abouts",
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: InAppColumn(
            children: [
              Expanded(
                flex: 40,
                child: InAppColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const InAppLogo(size: 120),
                    SizedBox(height: 16),
                    const InAppText(
                      AppConstants.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InAppText(
                      AppConstants.versionCode,
                      style: TextStyle(color: dark.t50, fontSize: 12),
                    ),
                    InAppText(
                      AppConstants.versionName,
                      style: TextStyle(color: dark.t50, fontSize: 12),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Expanded(
                flex: 60,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: InAppColumn(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: AboutsContent.items.map((e) {
                      return InAppGesture(
                        onTap: e.callback,
                        scalerLowerBound: 1,
                        backgroundColor: light,
                        highlightColor: context.dark.t05,
                        splashColor: context.dark.t05,
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            child: InAppRow(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: e.icon != null ? 16 : 0,
                              children: [
                                if (e.icon != null)
                                  InAppIcon(e.icon, size: 24, color: e.color),
                                Expanded(
                                  child: InAppText(
                                    e.text,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
