import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gps_speed/base_presentation/page/base_page.dart';
import 'package:gps_speed/base_presentation/view/view.dart';
import 'package:gps_speed/data/gps/dangerous_entity.dart';
import 'package:gps_speed/feature/dangerous_mark/cubit/dangerous_cubit.dart';
import 'package:gps_speed/resource/string.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';

//format date to dd/mm/yyyy - hh:mm
String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}";
}

class DangerousLocationsList extends StatefulWidget {
  const DangerousLocationsList({super.key});

  @override
  _DangerousLocationsListState createState() => _DangerousLocationsListState();
}

class _DangerousLocationsListState extends BasePageState<DangerousLocationsList> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: LText(SettingLocalization.listingDangerousMarker),
      actions: [
        BlocBuilder<DangerousCubit, DangerousState>(
          builder: (context, state) {
            final list = state.dangerousLocations;
            if (list.isEmpty) {
              return const SizedBox();
            }

            return IconButton(
              onPressed: () {
                AppNavigator.to(GetListDangerousMapPage(), list);
              },
              icon: const Icon(Icons.map_outlined),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<DangerousCubit, DangerousState>(
      builder: (context, state) {
        final list = state.dangerousLocations;
        if (list.isEmpty) {
          return const Center(
            child: Text("No dangerous locations"),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            final entity = list[index];

            return Slidable(
              key: ValueKey(entity),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () => buildRemoveDangerousLocations(context, entity, index)),
                children: [
                  SlidableAction(
                    onPressed: (context) => buildRemoveDangerousLocations(context, entity, index),
                    backgroundColor: const Color(0xFFFE4A49).withOpacity(0.8),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text("lat: ${entity.latitude} - long: ${entity.longitude}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_sharp,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(child: Text(formatDate(entity.time))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(child: Text(entity.addressInfo ?? "No address info")),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  AppNavigator.to(GetDangerousMapPage(), entity);
                },
              ),
            );
          },
          itemCount: state.dangerousLocations.length,
        );
      },
    );
  }

  void buildRemoveDangerousLocations(BuildContext context, DangerousEntity entity, int index) =>
      context.read<DangerousCubit>().removeDangerousLocations(entity, index);
}
