import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/base_presentation/theme/theme.dart';
import 'package:mp3_convert/base_presentation/view/base_view.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/home/cubit/home_cubit.dart';
import 'package:mp3_convert/feature/home/cubit/home_state.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/interface/pick_multiple_file.dart';
import 'package:mp3_convert/feature/home/widget/file_type_widget.dart';
import 'package:mp3_convert/feature/home/widget/menu_widget.dart';
import 'package:mp3_convert/main.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/permission/permission_helper.dart';
import 'package:mp3_convert/widget/button/button.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:collection/collection.dart';

part 'home_page.dart';
part 'empty_home.dart';
part 'picked_file_home.dart';
