import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:mp3_convert/widget/show_bottom_sheet.dart';

class ListMediaTypeWidget extends StatefulWidget with ShowBottomSheet<List<MediaType>> {
  const ListMediaTypeWidget({
    Key? key,
    required this.typeList,
    this.initList,
    this.onApplyAll,
  }) : super(key: key);

  final ListMediaType typeList;
  final List<MediaType>? initList;
  final ValueChanged<List<MediaType>>? onApplyAll;

  @override
  State<ListMediaTypeWidget> createState() => _ListMediaTypeWidgetState();
}

class _ListMediaTypeWidgetState extends State<ListMediaTypeWidget> {
  bool isMultipleChoice = false;
  final Set<MediaType> selected = {};

  @override
  void initState() {
    super.initState();
    if (widget.initList != null) {
      selected.addAll(widget.initList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.typeList.types..sort();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
              ),
            ),
            LText(ConvertPageLocalization.selectConvertType),
          ],
        ),
        const Divider(),
        Flexible(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Wrap(
                spacing: 8,
                children: [
                  ...l.map(
                    (type) => MediaTypeChip(
                      type: type,
                      isSelected: selected.contains(type),
                      onChanged: (value) {
                        if (isMultipleChoice) {
                          if (value) {
                            selected.add(type);
                          } else {
                            selected.remove(type);
                          }
                          setState(() {});
                        } else {
                          if (value) {
                            if (!selected.contains(type)) {
                              selected.clear();
                              selected.add(type);
                            }
                          } else {}
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          minimum: EdgeInsets.only(bottom: 10, top: 10),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                  child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onApplyAll?.call([...selected]);
                      },
                      child: LText(ConvertPageLocalization.applyAll))),
              const SizedBox(width: 12),
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop([...selected]);
                      },
                      child: LText(ConvertPageLocalization.choose))),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class MediaTypeChip extends StatelessWidget {
  const MediaTypeChip({super.key, required this.type, required this.onChanged, required this.isSelected});

  final MediaType type;
  final ValueChanged<bool> onChanged;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: onChanged,
      label: Text(type.name),
    );
  }
}
