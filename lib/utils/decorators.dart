import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ScannedTextPainter extends CustomPainter {

  final Size size;
  final VisionText scannedText;
  
  ScannedTextPainter(this.size, this.scannedText);

  var container ;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

     for (TextBlock block in scannedText.blocks) {

      paint.color = Colors.red;
      canvas.drawRect(
        _scalingRectangle(
          rect: block.boundingBox, 
          imageSize: this.size,
          widgetSize: size),
          paint);

      for (TextLine line in block.lines) {
        paint.color = Colors.yellow;
        canvas.drawRect(
          _scalingRectangle(
            rect: line.boundingBox, 
            imageSize: this.size,
            widgetSize: size),
            paint);

        for (TextElement element in line.elements) {
          paint.color = Colors.green;
          canvas.drawRect(
            _scalingRectangle(
              rect: element.boundingBox, 
              imageSize: this.size,
              widgetSize: size),
              paint);
        }
      }
    }
  }

    Rect _scalingRectangle({
      @required Rect rect, 
      @required Size imageSize, 
      @required Size widgetSize}){
        
        final double scaleY = widgetSize.height/ imageSize.height;
        final double scaleX = widgetSize.width/ imageSize.width;
      
        return Rect.fromLTRB(
          rect.top.toDouble() * scaleY, 
          rect.bottom.toDouble() *scaleY, 
          rect.right.toDouble() * scaleX, 
          rect.left.toDouble() *scaleX
        );  
      } 

  @override
  bool shouldRepaint(ScannedTextPainter oldDelegate) => 
    oldDelegate.size != size || oldDelegate.scannedText != scannedText; 

  @override
  bool shouldRebuildSemantics(ScannedTextPainter oldDelegate) => 
    oldDelegate.size != size || oldDelegate.scannedText != scannedText; 
}