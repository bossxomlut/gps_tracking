import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mp3_convert/feature/home/data/entity/feature_entity.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/widget/show_bottom_sheet.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                child: _CustomMenuButton(
                  title: MenuLocalization.tool.tr(),
                  onTap: () {
                    const ToolCategoryWidget().showBottomSheet(context).then((featureType) {
                      if (featureType == null) {
                        return;
                      }
                      switch (featureType) {
                        case FeatureType.convert:
                        // TODO: Handle this case.
                        case FeatureType.split:
                        // TODO: Handle this case.
                        case FeatureType.merge:
                        // TODO: Handle this case.
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: _CustomMenuButton(
                  title: MenuLocalization.export.tr(),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomMenuButton extends StatelessWidget {
  const _CustomMenuButton({super.key, required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(),
      ),
      child: Container(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        child: Text(title.toUpperCase()),
      ),
    );
  }
}

class ToolCategoryWidget extends StatelessWidget with ShowBottomSheet<FeatureType> {
  const ToolCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final listFeature = <FeatureInfo>[
      FeatureInfo(type: FeatureType.convert, name: "Convert", icon: "icon-convert", isEnabled: true),
      FeatureInfo(type: FeatureType.split, name: "Split", icon: "icon-split", isEnabled: false),
      FeatureInfo(type: FeatureType.merge, name: "Merge", icon: "icon-merge", isEnabled: false),
    ];

    return SizedBox(
      height: 100,
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ...listFeature.map(
            (e) => ToolButton(
              onTap: !e.isEnabled ? null : () => Navigator.of(context).pop(e.type),
              title: e.name,
              icon: e.icon,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureInfo {
  final String name;
  final String icon;
  final FeatureType type;
  final bool isEnabled;

  FeatureInfo({
    required this.name,
    required this.icon,
    required this.type,
    required this.isEnabled,
  });
}

class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(shape: const RoundedRectangleBorder()),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_convenience_store_rounded),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
