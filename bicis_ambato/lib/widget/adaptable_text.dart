// import 'package:flutter/material.dart';

// class AdaptableText extends StatelessWidget {
//   var style;
//   var textAlign;
//   var textDirection;
//   var minimumFontScale;
//   var textOverflow;
//   var text;

//   AdaptableText(this.text,
//       {required this.style,
//       this.textAlign = TextAlign.left,
//       this.textDirection = TextDirection.ltr,
//       this.minimumFontScale = 0.5,
//       this.textOverflow = TextOverflow.ellipsis,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//        TextPainter _painter = TextPainter(
//         text: TextSpan(text: this.text, style: this.style),
//         textAlign: this.textAlign,
//         textScaler: TextScaler.noScaling,
//         maxLines: 100,
//         textDirection: textDirection);
        
//    return LayoutBuilder(
//     builder: (BuildContext context, BoxConstraints constraints) 
//     { 
//            _painter.layout(maxWidth: constraints.maxWidth);
//         double textScaleFactor = 1;

//         //  if (_painter.height > constraints.maxHeight) { //
//         //   print('${_painter.size}');
//         //   _painter.textScaler  = minimumFontScale;
//         //   _painter.layout(maxWidth: constraints.maxWidth);
//         //   print('${_painter.size}');

//           // if (_painter.height > constraints.maxHeight) { //
//           //   //even minimum does not fit render it with minimum size
//           //   print("Using minimum set font");
//           //   textScaleFactor = minimumFontScale;
//           // } else{

//           // }
//      },


//    );
//   }
// }
