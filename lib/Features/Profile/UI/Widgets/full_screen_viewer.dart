import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullScreenImageViewer extends StatelessWidget {
  
  final String imagePath;
  final bool isNetwork;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imagePath,
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: isNetwork
                  ? Image.network(imagePath, fit: BoxFit.contain)
                  : Image.file(File(imagePath), fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}