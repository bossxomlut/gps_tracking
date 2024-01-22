import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/data/entity/pick_multiple_file.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/page/convert_page.dart';
import 'package:mp3_convert/feature/home/widget/app_file_card.dart';
import 'package:mp3_convert/main.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/navigator/app_navigator.dart';
import 'package:mp3_convert/util/navigator/app_page.dart';
import 'package:mp3_convert/util/permission/permission_helper.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:mp3_convert/widget/image.dart';

import '../../../util/show_lost_connect_internet_helper.dart';
import 'history_download_widget.dart';

part 'empty_home.dart';

part 'home_page.dart';

part 'picked_file_home.dart';
