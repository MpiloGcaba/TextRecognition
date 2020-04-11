
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';

typedef HandleDetection = Future<dynamic> Function(FirebaseVisionImage image);

Uint8List planesList(List<Plane> planes){
  final WriteBuffer allBytes = WriteBuffer();
  planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
  return allBytes.done().buffer.asUint8List();
}

FirebaseVisionImageMetadata imageMetaData(CameraImage image){
  return FirebaseVisionImageMetadata(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rawFormat: image.format.raw,
    planeData: image.planes.map((Plane plane) => 
      FirebaseVisionImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height, 
        width: plane.width)
    ).toList());
}

Future<dynamic> detect( CameraImage image, HandleDetection handleDetection) async =>  
  handleDetection(
    FirebaseVisionImage.fromBytes(
      planesList(image.planes),
      imageMetaData(image))
  );

