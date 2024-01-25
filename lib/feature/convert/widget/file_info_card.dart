import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:share_plus/share_plus.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({super.key, required this.file});

  final AppFile file;

  @override
  Widget build(BuildContext context) {
    final stat = FileStat.statSync(file.path);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_present_rounded,
                  size: 60,
                ),
                Text(file.type),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stat.modified.toString(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Share.shareXFiles([XFile(file.path)]);
              },
              icon: Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }
}
