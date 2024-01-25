import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/base_presentation/view/safe_set_state.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class ColumnStart extends Column {
  const ColumnStart({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.children,
  }) : super(crossAxisAlignment: CrossAxisAlignment.start);
}

class HelpAndFeedbackPage extends StatefulWidget {
  const HelpAndFeedbackPage({super.key});

  @override
  State<HelpAndFeedbackPage> createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends BasePageState<HelpAndFeedbackPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: LText(SettingLocalization.helpAndFeedback),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ReportWidget(),
        const SizedBox(height: 20),
        const AppVersion(),
      ],
    );
  }
}

class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ColumnStart(
      children: [
        LText(
          SettingLocalization.developerTeam,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Text(
          "Vịnh Ngô - smile.vinhnt@gmail.com".hardCode,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            try {
              launchUrl(Uri.parse('https://github.com/1712916'));
            } catch (e) {}
          },
          child: Text(
            'Github: 1712916'.hardCode,
            style: textTheme.bodyLarge?.copyWith(color: Colors.blue),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Hải Lê - lehaile37@gmail.com".hardCode,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            try {
              launchUrl(Uri.parse('https://github.com'));
            } catch (e) {}
          },
          child: Text(
            'Github: ---'.hardCode,
            style: textTheme.bodyLarge?.copyWith(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

class AppVersion extends StatefulWidget {
  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> with SafeSetState {
  String version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      version = value.version;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ColumnStart(
      children: [
        LText(
          SettingLocalization.version,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          version,
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
