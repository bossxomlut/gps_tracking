import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:mp3_convert/base_presentation/view/safe_set_state.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/cutter/cubit/cutter_cubit.dart';
import 'package:mp3_convert/feature/cutter/load_audio_data.dart';
import 'package:mp3_convert/feature/cutter/waveform/get_wave_form.dart';
import 'package:mp3_convert/feature/cutter/widget/ruller.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/hardcode_string.dart';

class CutterAudioWidget extends StatefulWidget {
  const CutterAudioWidget({super.key, required this.path});

  final String path;

  @override
  State<CutterAudioWidget> createState() => _CutterAudioWidgetState();
}

class _CutterAudioWidgetState extends State<CutterAudioWidget> with SafeSetState {
  final _player = AudioPlayer();

  List<double> get samples => waveform?.data != null ? loadWaveFormSample(waveform!.data, 256) : [];

  Waveform? waveform;

  CutterAudioController? cutterAudioController;

  @override
  void initState() {
    super.initState();

    initPlayAudio();

    initWareForm();
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future initWareForm() async {
    getWaveformFromFile(widget.path).then((value) {
      waveform = value;
      setState(() {});
    }).catchError((err) {});
  }

  Future<void> initPlayAudio() async {
    try {
      _player.setAudioSource(AudioSource.file(widget.path)).then((value) {
        if (value != null) {
          setState(() {});
          context.read<CutterCubit>().setDurations(Duration.zero, value!);
        }
      }).catchError((e) {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final pd = 16.0;
    return Column(
      children: [
        if (_player.duration != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pd),
            child: SizedBox(
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _cutterBarWidth),
                    child: LayoutBuilder(builder: (context, c) {
                      return SizedBox(
                        height: 98,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              child: PolygonWaveform(
                                samples: samples,
                                height: 98,
                                width: c.maxWidth,
                                absolute: true,
                                activeColor: Color(0xfff4570a),
                                inactiveColor: Color(0xfff4570a),
                              ),
                              alignment: Alignment.center,
                            ),
                            StreamBuilder(
                              stream: _player.positionStream,
                              builder: (_, s) {
                                if (s.hasData && s.data != null) {
                                  return Positioned(
                                    left: (s.data!.inSeconds * 1.0 / (_player.duration?.inSeconds ?? 1)) * c.maxWidth,
                                    child: Container(
                                      width: 1,
                                      height: 100,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  CuttingArea(
                    totalSecond: _player.duration?.inSeconds ?? 0,
                    onChanged: (start, end) {},
                    onChangedStop: (l, r) {
                      _player.seek(Duration(seconds: l));
                    },
                    onInitialized: (audioController) {
                      cutterAudioController = audioController;

                      cutterAudioController?.addListener(() {
                        context
                            .read<CutterCubit>()
                            .setDurations(cutterAudioController!.startDuration, cutterAudioController!.endDuration);
                      });
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox(height: 100),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: pd),
          child: Row(
            children: [
              StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final state = snapshot.data!;
                      if (state.playing) {
                        return IconButton(
                            onPressed: () {
                              _player.pause();
                            },
                            icon: const Icon(Icons.pause_circle));
                      }

                      switch (snapshot.data!.processingState) {
                        case ProcessingState.idle:
                        // TODO: Handle this case.
                        case ProcessingState.loading:
                        // TODO: Handle this case.
                        case ProcessingState.buffering:
                        // TODO: Handle this case.
                        case ProcessingState.ready:
                          return IconButton(
                            onPressed: () {
                              _player.play();
                            },
                            icon: const Icon(Icons.play_circle_outline),
                          );
                        case ProcessingState.completed:
                          return IconButton(
                            onPressed: () {
                              _player.seek(Duration.zero);
                              _player.play();
                            },
                            icon: const Icon(Icons.play_circle_outline),
                          );
                      }
                    }
                    return const Text('Loading...');
                  }),
              StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (_, s) {
                  if (s.hasData && s.data != null) {
                    return Text(
                      printDuration(s.data!),
                      style: Theme.of(context).textTheme.labelSmall,
                    );
                  }
                  return const SizedBox();
                },
              ),
              const Spacer(),
              if (_player.duration != null)
                Text(
                  "Time: ${printDuration(_player.duration!)}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
          ),
        ),
        if (cutterAudioController != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            child: ListenableBuilder(
              listenable: cutterAudioController!,
              builder: (context, child) {
                return Row(
                  children: [
                    LText(
                      CutterPageLocalization.from,
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Text(printDuration(cutterAudioController!.startDuration))),
                    LText(
                      CutterPageLocalization.to,
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Text(printDuration(cutterAudioController!.endDuration))),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class CuttingArea extends StatefulWidget {
  const CuttingArea({
    super.key,
    required this.totalSecond,
    required this.onChanged,
    required this.onChangedStop,
    required this.onInitialized,
  });
  final int totalSecond;

  final Function(int start, int end) onChanged;
  final Function(int start, int end) onChangedStop;
  final Function(CutterAudioController audioController) onInitialized;

  @override
  State<CuttingArea> createState() => _CuttingAreaState();
}

class _CuttingAreaState extends State<CuttingArea> {
  late final CutterAudioController _audioController = CutterAudioController(widget.totalSecond);

  @override
  void initState() {
    super.initState();

    _audioController.addListener(() {
      _audioController.getCutterData(widget.onChanged);
    });

    widget.onInitialized(_audioController);
  }

  @override
  Widget build(BuildContext context) {
    final cutterHeight = 100.0;
    return SizedBox(
      height: cutterHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            children: [
              const SizedBox(width: _cutterBarWidth),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, c) {
                    _audioController.containerWidth = c.widthConstraints().maxWidth;
                    return Container(
                      height: cutterHeight,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xfff25d17).withOpacity(0.3),
                            Color(0xfff25d17).withOpacity(0.2),
                            Color(0xfff25d17).withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: _cutterBarWidth),
            ],
          ),
          ListenableBuilder(
            listenable: _audioController,
            builder: (context, child) {
              return Positioned(
                left: _audioController.start,
                right: _audioController.end,
                child: Row(
                  children: [
                    LeftDragBar(
                      height: cutterHeight,
                      onDragUpdate: (r) {
                        _audioController.updateStartPosition(r);
                      },
                      onHorizontalDragEnd: onHorizontalDragEnd,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragDetails) {
                          final r = dragDetails.delta.dx;
                          _audioController.updateStartPosition(r);
                          _audioController.updateEndPosition(r);
                        },
                        onHorizontalDragEnd: (_) => onHorizontalDragEnd(),
                        child: Container(
                          height: cutterHeight,
                          decoration: BoxDecoration(
                            border: Border.all(color: _dragBarColor, strokeAlign: BorderSide.strokeAlignOutside),
                          ),
                        ),
                      ),
                    ),
                    RightDragBar(
                      height: cutterHeight,
                      onDragUpdate: (r) {
                        _audioController.updateEndPosition(r);
                      },
                      onHorizontalDragEnd: onHorizontalDragEnd,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onHorizontalDragEnd() {
    _audioController.getCutterData(widget.onChangedStop);
  }
}

const double _cutterBarWidth = 10.0;
const Color _dragBarColor = Color(0xffc4f061);

class LeftDragBar extends StatelessWidget {
  const LeftDragBar({
    super.key,
    required this.height,
    required this.onDragUpdate,
    required this.onHorizontalDragEnd,
  });
  final double height;

  final ValueChanged<double> onDragUpdate;
  final VoidCallback onHorizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (dragDetail) {
        onDragUpdate(dragDetail.delta.dx);
      },
      onHorizontalDragEnd: (dragDetail) {
        onHorizontalDragEnd();
      },
      child: Container(
        height: height / 2,
        width: _cutterBarWidth,
        decoration: const BoxDecoration(
            color: _dragBarColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            )),
      ),
    );
  }
}

class RightDragBar extends StatelessWidget {
  const RightDragBar({
    super.key,
    required this.height,
    required this.onDragUpdate,
    required this.onHorizontalDragEnd,
  });
  final double height;

  final ValueChanged<double> onDragUpdate;
  final VoidCallback onHorizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (dragDetail) {
        onDragUpdate(dragDetail.delta.dx);
      },
      onHorizontalDragEnd: (dragDetail) {
        onHorizontalDragEnd();
      },
      child: Container(
        height: height / 2,
        width: _cutterBarWidth,
        decoration: const BoxDecoration(
          color: _dragBarColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),
    );
  }
}

class CutterAudioController extends ChangeNotifier {
  double _startPosition = 0;
  double _endPosition = 0;
  double containerWidth = 1;

  double get start => _startPosition;

  double get end => _endPosition;

  final int durationInSeconds;

  CutterAudioController(this.durationInSeconds);

  void updateStartPosition(double dx) {
    _startPosition += dx;
    if (_startPosition < 0) {
      _startPosition = 0;
    }

    if (_startPosition + _endPosition >= containerWidth) {
      _startPosition = containerWidth - _endPosition;
    }
    notifyListeners();
  }

  void updateEndPosition(double dx) {
    _endPosition -= dx;
    if (_endPosition < 0) {
      _endPosition = 0;
    }

    if (_startPosition + _endPosition >= containerWidth) {
      _endPosition = containerWidth - _startPosition;
    }

    notifyListeners();
  }

  void getCutterData(Function(int start, int end) callBack) {
    final l = ((start / containerWidth) * durationInSeconds).floor();
    final r = ((1 - (end.abs() / containerWidth)) * durationInSeconds).floor();

    callBack(l, r);
  }

  Duration get startDuration => Duration(seconds: ((start / containerWidth) * durationInSeconds).floor());

  Duration get endDuration => Duration(seconds: ((1 - (end.abs() / containerWidth)) * durationInSeconds).floor());
}
