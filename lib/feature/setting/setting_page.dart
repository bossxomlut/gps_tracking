import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/page/base_page.dart';
import 'package:gps_speed/base_presentation/view/view.dart';
import 'package:gps_speed/feature/dangerous_mark/dangerous_mark_setting.dart';
import 'package:gps_speed/feature/setting/cubit/cubit.dart';
import 'package:gps_speed/feature/setting/cubit/monitor_cubit.dart';
import 'package:gps_speed/resource/string.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BasePageState<SettingPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: LText(SettingLocalization.setting),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Loca(),
          MonitorSetting(),
          MaxSpeedSetting(),
          DangerousMarkSetting(),
          HelpAndFeedback(),
        ],
      ),
    );
  }
}

class Loca extends StatelessWidget {
  const Loca({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: Border(),
      title: LText(
        SettingLocalization.language,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      children: [
        ...context.supportedLocales.map(
          (l) => ListTile(
            onTap: () {
              context.setLocale(l);
            },
            leading: IgnorePointer(
              child: Radio(
                value: l.languageCode,
                groupValue: context.locale.languageCode,
                onChanged: (_) {},
              ),
            ),
            title: LText("${l.languageCode}"),
          ),
        ),
      ],
    );
  }
}

class MaxSpeedSetting extends StatelessWidget {
  const MaxSpeedSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LText(
          SettingLocalization.maxSpeed,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      subtitle: BlocBuilder<MaxSpeedCubit, MaxSpeedState>(
        builder: (context, state) {
          final maxSpeedList = state.maxSpeedList;
          final maxSpeed = state.maxSpeed;
          return Column(
            children: [
              ...?maxSpeedList?.map(
                (sp) => ListTile(
                  onTap: () {
                    context.read<MaxSpeedCubit>().setMaxSpeed(sp);
                  },
                  leading: IgnorePointer(
                    child: Radio(
                      value: state.haveMaxSpeed && maxSpeed == sp,
                      groupValue: true,
                      onChanged: (_) {},
                    ),
                  ),
                  title: LText("${sp.toStringAsFixed(0)} km"),
                ),
              ),
            ],
          );
        },
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class MonitorSetting extends StatelessWidget {
  const MonitorSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LText(
          SettingLocalization.monitor,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      subtitle: BlocBuilder<MonitorCubit, MonitorState>(
        builder: (context, state) {
          final cubit = context.read<MonitorCubit>();

          final maxSpeedList = cubit.viewTypeList;
          final maxSpeed = state.viewType;
          return Column(
            children: [
              ...?maxSpeedList?.map(
                (sp) => ListTile(
                  onTap: () {
                    cubit.setViewType(sp);
                  },
                  leading: IgnorePointer(
                    child: Radio(
                      value: maxSpeed == sp,
                      groupValue: true,
                      onChanged: (_) {},
                    ),
                  ),
                  title: LText("${sp.name}"),
                ),
              ),
            ],
          );
        },
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class HelpAndFeedback extends StatelessWidget {
  const HelpAndFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: LText(
        SettingLocalization.helpAndFeedback,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      onTap: () {
        AppNavigator.to(GetHelpAndFeedbackPage());
      },
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
