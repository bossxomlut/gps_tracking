import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/base_presentation/view/base_view.dart';
import 'package:mp3_convert/base_presentation/view/safe_set_state.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/home/cubit/convert_setting_cubit.dart';
import 'package:mp3_convert/feature/setting/help_and_feedback_page.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConvertSettingPage extends StatefulWidget {
  const ConvertSettingPage({super.key});

  @override
  State<ConvertSettingPage> createState() => _ConvertSettingPageState();
}

class _ConvertSettingPageState extends SingleProviderBasePageState<ConvertSettingPage, ConvertSettingCubit> {
  _ConvertSettingPageState() : super(cubit: ConvertSettingCubit());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: LText(SettingLocalization.setting),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        AutoDownloadSettingWidget(),
      ],
    );
  }
}

class AutoDownloadSettingWidget extends StatefulWidget {
  const AutoDownloadSettingWidget({super.key});

  @override
  State<AutoDownloadSettingWidget> createState() => _AutoDownloadSettingWidgetState();
}

class _AutoDownloadSettingWidgetState extends State<AutoDownloadSettingWidget> with SafeSetState {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BlocSelector<ConvertSettingCubit, ConvertSettingState, bool>(
          selector: (state) => state.isAutoDownload,
          builder: (context, isAutoDownload) {
            return Switch(
              value: isAutoDownload,
              onChanged: (value) {
                context.read<ConvertSettingCubit>().setAutoDownload(value);
              },
            );
          },
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LText(
            ConvertPageLocalization.autoDownload,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
