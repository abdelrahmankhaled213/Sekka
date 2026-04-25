import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Constants/app_style.dart';

class CustomTextSpan extends StatefulWidget {

  final String text;

  final String text2;

  final void Function()? onTapGesture;

  const CustomTextSpan({
     super.key
    ,required this.text
    ,required this.text2,
     this.onTapGesture

  });

  @override
  State<CustomTextSpan> createState() => _CustomTextSpanState();
}

class _CustomTextSpanState extends State<CustomTextSpan> {

  TapGestureRecognizer? _tapGestureRecognizer;

  @override
  void initState() {

     super.initState();

     if(widget.onTapGesture!=null){

       _tapGestureRecognizer = TapGestureRecognizer() ..onTap
       = widget.onTapGesture;
                                        }

  }

  @override void didUpdateWidget(covariant CustomTextSpan oldWidget)
  { super.didUpdateWidget(oldWidget);
    if (widget.onTapGesture != oldWidget.onTapGesture)
    { _tapGestureRecognizer?.dispose(); if (widget.onTapGesture != null)
    { _tapGestureRecognizer = TapGestureRecognizer() ..onTap
    = widget.onTapGesture; } else { _tapGestureRecognizer = null;
    }
    }
    }
  @override void dispose()
  {
    _tapGestureRecognizer
        ?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        TextSpan(
            children: [
              TextSpan(
                  text: '${widget.text}\t',
                  style: AppStyle.regular16RobotoGrey.copyWith(
                    fontSize: 14.sp
                  )
              ),

              TextSpan(
                  text: '${widget.text2}\t',
                  style: AppStyle.bold14RobotoBlue,
recognizer: _tapGestureRecognizer
              ),
            ]
        )
    );
  }
}