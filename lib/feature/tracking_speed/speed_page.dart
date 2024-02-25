import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/util/gps/gps_util.dart';

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  State<SpeedPage> createState() => _SpeedPageState();
}

class _SpeedPageState extends BasePageState<SpeedPage> {
  final GPSUtil gpsUtil = GPSUtil.instance;

  late Stream<GPSEntity> gpsStream;
  late Stream<double> speedStream;

  bool isInit = false;

  @override
  void initState() {
    super.initState();

    gpsUtil.requestLocationPermission().then((value) {
      gpsUtil.checkEnableLocationService().then((value) {
        gpsStream = gpsUtil.listenGPSChanged();
        isInit = true;
        setState(() {});
        speedStream = SpeedUtil().listenSpeedChanged();
      });
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    if (isInit) {
      return SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: gpsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data?.kmh().round()}",
                    style: Theme.of(context).textTheme.headlineLarge,
                  );
                }
                return Text("LOADING");
              },
            ),
            StreamBuilder(
              stream: speedStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data?.round()}",
                    style: Theme.of(context).textTheme.headlineLarge,
                  );
                }
                return Text("LOADING");
              },
            ),
          ],
        ),
      );
    }

    return Text("LOADING");
  }
}
