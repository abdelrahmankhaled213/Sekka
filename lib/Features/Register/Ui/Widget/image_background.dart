import 'package:flutter/material.dart';

import '../../../../Core/Constants/app_image.dart';

class ImageBackground extends StatelessWidget {
final Widget child;
  const ImageBackground({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(image:
      DecorationImage(image:
      AssetImage(
          AppImage.backgroundAuth
      ),
          fit:BoxFit.cover
      ),
      ),
      child: child
      ,);
  }
}
