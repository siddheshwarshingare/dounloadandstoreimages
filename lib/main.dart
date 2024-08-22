import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:path/path.dart' as path;

void main() {
  runApp(ImageCaptureApp());
}

class ImageCaptureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageCaptureScreen(),
    );
  }
}

class ImageCaptureScreen extends StatefulWidget {
  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  List<File> _images = [];

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      // Save the image to the gallery
      await GallerySaver.saveImage(savedImage.path);
      print('Saved image to: ${savedImage.path} and Gallery');

      setState(() {
        _images.add(savedImage);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _loadSavedImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = Directory(appDir.path).listSync();

    setState(() {
      _images = files.whereType<File>().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // _loadSavedImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Capture and Gallery')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _takePicture,
            child: const Text('Take dsfdfds Picture'),
          ),
        ],
      ),
    );
  }
}
