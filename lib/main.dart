import 'package:SpeechApp/utils/decorators.dart';
import 'package:SpeechApp/utils/utils.dart';

import 'package:camera/camera.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
 
  runApp(
    MyApp(firstCamera: firstCamera,));
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  CameraScreen({Key key, this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  dynamic _results;
  CameraController _camera;
  // bool _isDetecting = false;
  // Future<void> _controllerFuture;

  FirebaseVision vision;

  @override
  void initState() {
    super.initState();
    
    vision = FirebaseVision.instance;
    
    _camera = CameraController(widget.camera, ResolutionPreset.medium);
    
    imagepreview();
     
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key:new GlobalKey(),
      body: Stack(
        fit:StackFit.expand, 
        children: <Widget>[
          CameraPreview(_camera),
          _buildResults()
        ],
      )
    );
  }

  void imagepreview() async{

    await _camera.initialize();
    _camera.startImageStream(
       (image){ 
         detect(image, vision.textRecognizer().processImage)
            .then((value){setState(() {
              _results = value;
            });})
            .catchError((_)=> null);
        }
    ); 
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('No results!');
    print(_results);
    print(_camera);
    print(_camera.value.isInitialized);

    if (_results == null || !_camera.value.isInitialized) {
      return noResultsText;
    }

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );
    print(_results.text);
    return CustomPaint(
      painter: ScannedTextPainter(imageSize, _results),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _camera.dispose();
  }
}

class MyApp extends StatelessWidget {
  final firstCamera;
  MyApp({this.firstCamera});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen( camera: firstCamera ),
    );
  }
}