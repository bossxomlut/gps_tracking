import 'package:flutter/material.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/widget/show_bottom_sheet.dart';

class ListMediaTypeWidget extends StatefulWidget with ShowBottomSheet<List<MediaType>> {
  const ListMediaTypeWidget({Key? key, required this.typeList, this.initList}) : super(key: key);

  final ListMediaType typeList;
  final List<MediaType>? initList;

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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Row(
        //   children: [
        //     Checkbox(
        //       value: isMultipleChoice,
        //       onChanged: (value) {
        //         isMultipleChoice = value!;
        //         selected.clear();
        //         setState(() {});
        //       },
        //     ),
        //     Text("Multiple selection"),
        //     const Spacer(),
        //     if (isMultipleChoice)
        //       TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(selected.toList());
        //           },
        //           child: Text("Select"))
        //   ],
        // ),
        Wrap(
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
                      Navigator.of(context).pop([type]);
                    }
                  }
                },
              ),
            ),
          ],
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
