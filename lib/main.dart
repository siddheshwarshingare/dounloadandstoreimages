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

      setState(() {
        _images.add(savedImage);
        // Show a SnackBar when an image is successfully added
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Image saved successfully!',
              style: TextStyle(color: Colors.pink),
            ),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image selected."),
        ),
      );
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
    // Uncomment if you want to load previously saved images on startup
    // _loadSavedImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 144, 116, 177),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 163, 123),
        title: const Text('Take photo and store in gallery'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 200, left: 100),
            child: ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 68, 224, 20), // Button color
              ),
              child: const Text('Take Picture'),
            ),
          ),
          // Add a widget here to display the images if needed
        ],
      ),
    );
  }
}
