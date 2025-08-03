import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/stack.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';

const kSeenPrivacyPolicy = "seen_privacy_policy";

bool get isPrivacySeen => Settings.get(kSeenPrivacyPolicy, false);

class PrivacyPage extends StatefulWidget {
  final Object? args;
  final bool isStartupMode;

  const PrivacyPage({super.key, this.args, this.isStartupMode = false});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage>
    with TranslationMixin, ColorMixin {
  final privacy =
      "Smart Assistant integrates many Feature Cards to realize your frequently used functions or show you important message by one-touch, bringing your life mor convenience. "
      "To achieve the above objectives, we and third-party content or service providers may need to, for specific functional modules or needs, collect the follow information provided by you or of your device (including but not limited to personal information) or synchronize such information with independent applications or functions:\n\n"
      "1.\tQuick Functions: list of your frequently used applications or quick functions;\n"
      "2.\tWeather: your location information, such as GPS signals of your device or geographical location information of nearby Wi-Fi access point or mobile phone signal tower;\n"
      "3.\tFavorite Contacts: list of favorite contacts in your address book, a shortcut function to read or edit your contact information or call or text them;\n"
      "4.\tEvents: schedule information in your calendar;\n"
      "5.\tStep Tracker: information of your sport steps;\n\n"
      "For the above information, if we have informed you in the independent applications or functions, and have collected or presented relevant information with your prior consent, Smart Assistant will only share such information to present in relevant Feature Cards, and will not re-collect information of you or your device.\n\n"
      "The collected information will be used to optimize the function of Smart Assistant, personalize baseUser experience, and assist with our operation necessary for such function. We will only use your personal information for the above purpose, which is confirmed when collecting your information and agreed by you. "
      "We will obtain your consent prior to any other use of your information.\n\n"
      "We have no absolute control of the content and service provided by the third party, which may be accessed by you at your discretion. As we have no control upon the third party's privacy and item protection policy, the third party is not bound by this Statement or our Privacy Policy; please read the third party's privacy policy and baseUser agreement carefully before providing your personal information to the third party.\n\n"
      "Except as stated in this Statement, we will not disclose your personal information without your consent to the third parties for their respective independent marketing or commercial purposes. "
      "However, in order to provide you with service, we may share your personal information, after obtaining your consent, with our affiliates and authorized partners for providing better customer service and baseUser experience. we will inform you of the relevant type of sensitive personal information, identity of the item recipient and its item security capability, and obtain your prior express consent before sharing your sensitive personal information with others.\n\n"
      "We will use all specific organizational and technical measures that are reasonable and feasible to protect your personal information collected by Smart Assistant from unauthorized access, public disclosure, use, change, damage or loss.\n\n"
      "For specific privacy policy issues not specified in this Statement regarding personal information related to Smart Assistant (including but not limited to \"Our Third-Party Service Providers and Their Services\", \"How We Protect Your Personal Information\", \"Your Rights\", How We Process Children's Personal Data\" and How Your Personal Data Is Transferred Globally\"), please refer to and comply with our Privacy Policy (you can refer to the latest version of the Privacy Policy at \"Settings - Legal Information - Privacy Policy\" in your device).\n\n"
      "Clicking \"Agree to enable the function of Smart Assistant means that you fully and clearly understand the foregoing action of information collection and use (including but not limited to its scope, manner, purpose and time limit) and all your rights, and agree that we may collect and use relevant information provided by you and of your device. "
      "#More About Privacy Policy";

  void _accept() async {
    if (Settings.set(kSeenPrivacyPolicy, true)) {
      if (widget.isStartupMode) {
        context.next(Routes.privacy);
      } else {
        context.close();
      }
    } else {
      final value = await context.showAlert(
        title: "Something went wrong, please try again?",
        positiveButtonText: "Try Again",
        negativeButtonText: "Cancel",
      );
      if (value) {
        _accept();
      } else {
        if (!mounted) return;
        context.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InAppAppbar(
        titleText: "Privacy Policy",
        centerTitle: true,
        actions: [InAppLogoTrailing()],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: ColoredBox(
            color: light,
            child: InAppStack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: 100,
                  ),
                  child: InAppText(
                    privacy,
                    style: TextStyle(fontSize: 14, height: 1.8),
                  ),
                ),
                if (widget.isStartupMode || !isPrivacySeen)
                  InAppAlign(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [light.withAlpha(0), light],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.5],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
                        child: InAppFilledButton(
                          onTap: _accept,
                          text: widget.isStartupMode ? "Next" : "Accept",
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get name => "about:privacy";
}
