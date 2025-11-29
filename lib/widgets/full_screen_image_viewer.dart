import 'dart:ui';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final bool useAssetIfEmpty;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.useAssetIfEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool showNetwork =
        imageUrl.isNotEmpty && !useAssetIfEmpty ? true : false;

    final imageWidget = showNetwork
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/default_avatar.png', fit: BoxFit.cover),
          )
        : Image.asset('assets/default_avatar.png', fit: BoxFit.cover);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // tap anywhere to close
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background image
            Positioned.fill(child: imageWidget),

            // Blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),

            // Center circular profile image
            Center(
              child: Hero(
                tag: heroTag,
                child: ClipOval(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.width * 0.65,
                    child: showNetwork
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/default_avatar.png',
                                    fit: BoxFit.cover),
                          )
                        : Image.asset('assets/default_avatar.png',
                            fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
