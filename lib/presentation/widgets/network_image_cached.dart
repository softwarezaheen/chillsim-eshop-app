import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:path/path.dart" as path;

enum ImageSource { network, local }

class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.imagePath,
    required this.source,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.errorFadeInDuration = const Duration(milliseconds: 300),
    this.svgColor,
    this.repeat = true,
  });

  final String imagePath;
  final ImageSource source;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration? fadeInDuration;
  final Duration placeholderFadeInDuration;
  final Duration errorFadeInDuration;
  final Color? svgColor;
  final bool? repeat;

  static CachedImage local({
    required String imagePath,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    Duration? fadeInDuration = const Duration(milliseconds: 300),
    Duration placeholderFadeInDuration = const Duration(milliseconds: 300),
    Duration errorFadeInDuration = const Duration(milliseconds: 300),
    Color? svgColor,
    bool? repeat = true,
  }) {
    return CachedImage(
      imagePath: imagePath,
      source: ImageSource.local,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fadeInDuration: fadeInDuration,
      placeholderFadeInDuration: placeholderFadeInDuration,
      errorFadeInDuration: errorFadeInDuration,
      svgColor: svgColor,
      repeat: repeat,
    );
  }

  static CachedImage network({
    required String imagePath,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    Duration? fadeInDuration = const Duration(milliseconds: 300),
    Duration placeholderFadeInDuration = const Duration(milliseconds: 300),
    Duration errorFadeInDuration = const Duration(milliseconds: 300),
    Color? svgColor,
    bool? repeat = true,
  }) {
    return CachedImage(
      imagePath: imagePath,
      source: ImageSource.network,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fadeInDuration: fadeInDuration,
      placeholderFadeInDuration: placeholderFadeInDuration,
      errorFadeInDuration: errorFadeInDuration,
      svgColor: svgColor,
      repeat: repeat,
    );
  }

  bool get _isSvg => path.extension(imagePath).toLowerCase() == ".svg";

  bool get _isGif => path.extension(imagePath).toLowerCase() == ".gif";

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return _buildSvgImage();
    }
    return source == ImageSource.network
        ? _buildNetworkImage()
        : _buildLocalImage();
  }

  Widget _buildSvgImage() {
    if (source == ImageSource.network) {
      return SvgPicture.network(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        colorFilter: svgColor != null
            ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholder(),
        semanticsLabel: "SVG Image",
      );
    } else if (imagePath.startsWith("assets/")) {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        colorFilter: svgColor != null
            ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholder(),
        semanticsLabel: "SVG Image",
      );
    } else {
      return SvgPicture.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        colorFilter: svgColor != null
            ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) => _buildPlaceholder(),
        semanticsLabel: "SVG Image",
      );
    }
  }

  Widget _buildNetworkImage() {
    if (_isGif) {
      return _buildGifImage();
    }

    return CachedNetworkImage(
      imageUrl: imagePath,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      placeholder: (BuildContext context, String url) => _buildPlaceholder(),
      errorWidget: (BuildContext context, String url, Object error) =>
          _buildErrorWidget(),
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLocalImage() {
    // Check if the path starts with 'assets/' - indicating it's an asset, not a true local file
    if (imagePath.startsWith("assets/")) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeInDuration ?? const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                _buildErrorWidget(),
      );
    }

    // Handle true local file
    final File file = File(imagePath);
    if (!file.existsSync()) {
      return _buildErrorWidget();
    }

    if (_isGif) {
      return _buildLocalGifImage(file);
    }

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: fadeInDuration ?? const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) =>
              _buildErrorWidget(),
    );
  }

  Widget _buildGifImage() {
    return CachedNetworkImage(
      imageUrl: imagePath,
      width: width,
      height: height,
      fit: fit,
      placeholder: (BuildContext context, String url) => _buildPlaceholder(),
      errorWidget: (BuildContext context, String url, Object error) =>
          _buildErrorWidget(),
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) => Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeInDuration ?? const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        repeat: repeat! ? ImageRepeat.repeat : ImageRepeat.noRepeat,
        gaplessPlayback: true,
      ),
    );
  }

  Widget _buildLocalGifImage(File file) {
    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: fadeInDuration ?? const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) =>
              _buildErrorWidget(),
      gaplessPlayback: true,
      repeat: repeat! ? ImageRepeat.repeat : ImageRepeat.noRepeat,
    );
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) {
      return placeholder!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.grey[400],
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            "Image not available",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool?>("repeat", repeat))
      ..add(StringProperty("imagePath", imagePath))
      ..add(EnumProperty<ImageSource>("source", source))
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height))
      ..add(EnumProperty<BoxFit?>("fit", fit))
      ..add(DiagnosticsProperty<Duration?>("fadeInDuration", fadeInDuration))
      ..add(
        DiagnosticsProperty<Duration>(
          "placeholderFadeInDuration",
          placeholderFadeInDuration,
        ),
      )
      ..add(
        DiagnosticsProperty<Duration>(
          "errorFadeInDuration",
          errorFadeInDuration,
        ),
      )
      ..add(ColorProperty("svgColor", svgColor));
  }
}
