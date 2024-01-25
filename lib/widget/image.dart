import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum _ImageType { network, asset, svg, file }

class AppImage extends StatefulWidget {
  AppImage(
    this.url, {
    Key? key,
    this.boxFit,
    this.height,
    this.width,
    this.color,
    _ImageType imageType = _ImageType.network,
  }) : super(key: key) {
    _imageType = imageType;
  }

  final BoxFit? boxFit;
  final String url;
  final double? height;
  final double? width;
  final Color? color;
  late final _ImageType _imageType;

  factory AppImage.asset(
    String url, {
    BoxFit? boxFit,
    double? height,
    double? width,
    Color? color,
  }) {
    return AppImage(
      url,
      boxFit: boxFit,
      imageType: _ImageType.asset,
      width: width,
      height: height,
      color: color,
    );
  }

  factory AppImage.network(
    String url, {
    BoxFit? boxFit,
    double? height,
    double? width,
    Color? color,
  }) {
    return AppImage(
      url,
      boxFit: boxFit,
      imageType: _ImageType.network,
      width: width,
      height: height,
      color: color,
    );
  }

  factory AppImage.svg(
    String url, {
    BoxFit? boxFit,
    double? height,
    double? width,
    Color? color,
  }) {
    return AppImage(
      url,
      boxFit: boxFit,
      imageType: _ImageType.svg,
      width: width,
      height: height,
      color: color,
    );
  }

  factory AppImage.file(
    String url, {
    BoxFit? boxFit,
    double? height,
    double? width,
    Color? color,
  }) {
    return AppImage(
      url,
      boxFit: boxFit,
      imageType: _ImageType.file,
      width: width,
      height: height,
      color: color,
    );
  }

  @override
  _AppImageState createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  @override
  Widget build(BuildContext context) {
    final loadingWidget = ColoredBox(
      color: Colors.grey.shade200,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Icon(
          Icons.image_outlined,
          color: Colors.grey,
        ),
      ),
    );
    switch (widget._imageType) {
      case _ImageType.network:
        if (widget.url.isEmpty) {
          return loadingWidget;
        }

        if (!widget.url.contains('https://') && !widget.url.contains('http://')) {
          return loadingWidget;
        }

        return Image.network(widget.url);

      // return CachedNetworkImage(
      //   imageUrl: widget.url,
      //   fit: widget.boxFit,
      //   width: widget.width,
      //   height: widget.height,
      //   progressIndicatorBuilder: (context, url, progress) {
      //     return loadingWidget;
      //   },
      //   errorWidget: (context, url, error) {
      //     // var _errorText = "Image unavailable\n";
      //     if (error.statusCode == 403) {}
      //
      //     return loadingWidget;
      //   },
      // );

      case _ImageType.asset:
        return Image.asset(
          widget.url,
          color: widget.color,
          fit: widget.boxFit,
          width: widget.width,
          height: widget.height,
          errorBuilder: (context, error, stackTrace) {
            return loadingWidget;
          },
        );
      case _ImageType.svg:
        return SvgPicture.asset(
          widget.url,
          color: widget.color ?? Theme.of(context).iconTheme.color,
          fit: widget.boxFit ?? BoxFit.cover,
          width: widget.width,
          height: widget.height,
        );

      case _ImageType.file:
        return SvgPicture.file(
          File(widget.url),
          color: widget.color,
          fit: widget.boxFit ?? BoxFit.cover,
          width: widget.width,
          height: widget.height,
        );
    }
  }
}
