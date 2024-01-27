import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/feature/cutter/load_audio_data.dart';
import 'package:mp3_convert/feature/cutter/waveform/get_wave_form.dart';
import 'package:mp3_convert/feature/cutter/widget/audio_cutter_widget.dart';
import 'package:mp3_convert/feature/setting/help_and_feedback_page.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:mp3_convert/widget/empty_picker_widget.dart';
import 'dart:math' as math;

class AudioCutterPage extends StatefulWidget {
  const AudioCutterPage({Key? key}) : super(key: key);

  @override
  _AudioCutterPageState createState() => _AudioCutterPageState();
}

class _AudioCutterPageState extends BasePageState<AudioCutterPage> {
  AppFile? file;

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: super.build(context));
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(file?.name ?? ''),
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    if (file != null) {
      return _AudioPage(file: file!);
    }
    return EmptyPickerWidget(
      canPickMultipleFile: false,
      onGetFiles: (files) {
        file = files.first;
        setState(() {});
      },
    );
  }
}

class _AudioPage extends StatefulWidget {
  const _AudioPage({super.key, required this.file});
  final AppFile file;

  @override
  State<_AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<_AudioPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          CutterAudioWidget(path: widget.file.path),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xfffff25d17),
              ),
              onPressed: () {},
              child: Center(child: Text("Start Cut".hardCode)),
            ),
          ),
          ColumnStart(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Option".hardCode,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: false,
                    onChanged: (value) {},
                  ),
                  Text("Remove selection"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Convert Type",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
