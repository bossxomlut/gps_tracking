import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/view/view.dart';
import 'package:gps_speed/feature/dangerous_mark/cubit/dangerous_cubit.dart';
import 'package:gps_speed/resource/string.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';

class DangerousMarkSetting extends StatelessWidget {
  const DangerousMarkSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Flexible(
              child: LText(
                SettingLocalization.dangerousMarker,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                //show snack bar to information this feature
                const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  showCloseIcon: false,
                  content: AwesomeSnackbarContent(
                    title: 'Help',
                    message: 'Marked current location as dangerous location',
                    contentType: ContentType.help,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    snackBar,
                  );
              },
            ),
          ],
        ),
      ),
      subtitle: Column(
        children: [
          ListTile(
            title: LText(SettingLocalization.enableDangerousMarker),
            trailing: BlocSelector<DangerousCubit, DangerousState, bool>(
                selector: (state) => state.showMarkButton,
                builder: (context, showMarkButton) {
                  return Switch(
                    value: showMarkButton,
                    onChanged: (value) {
                      context.read<DangerousCubit>().switchShowMarkButton();
                    },
                  );
                }),
          ),
          ListTile(
            title: LText(SettingLocalization.listingDangerousMarker),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              AppNavigator.to(GetListingDangerousMarkPage());
            },
          ),
        ],
      ),
      // trailing: IconButton(
      //   icon: Icon(Icons.info_outline),
      //   onPressed: () {},
      // ),

      // subtitle: BlocBuilder<DangerousCubit, DangerousState>(
      //   builder: (context, state) {
      //     final maxSpeedList = state.maxSpeedList;
      //     final maxSpeed = state.maxSpeed;
      //     return Column(
      //       children: [
      //         ...?maxSpeedList?.map(
      //           (sp) => ListTile(
      //             onTap: () {
      //               context.read<MaxSpeedCubit>().setMaxSpeed(sp);
      //             },
      //             leading: IgnorePointer(
      //               child: Radio(
      //                 value: state.haveMaxSpeed && maxSpeed == sp,
      //                 groupValue: true,
      //                 onChanged: (_) {},
      //               ),
      //             ),
      //             title: LText("${sp.toStringAsFixed(0)} km"),
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
