import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imagepicker = ImagePicker();
  late File image;
  var tf = 1;
  List? predictions = [];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/disease_new.tflite', labels: 'assets/labels.txt');
  }

  predictModel(image) async {
    var pred = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 224,
        imageStd: 224,
        numResults: 15,
        threshold: 0.5,
        asynch: true);
    // print(pred);
    setState(() {
      predictions = pred;
      tf = 0;
      // print(predictions);
    });
  }

  loadImageGallery() async {
    var img = await imagepicker.pickImage(source: ImageSource.gallery);

    if (img == null) {
      return null;
    } else {
      image = File(img.path);
    }
    predictModel(image);
  }

  loadCamera() async {
    var img = await imagepicker.pickImage(source: ImageSource.camera);

    if (img == null) {
      return null;
    } else {
      image = File(img.path);
    }
    predictModel(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 59, 214, 27),
        title: Text(
          'Crop Doctor',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 20,
            ),
            Lottie.asset('assets/home.json', height: 250, width: 200),
            // const SizedBox(
            //   height: 100,
            // ),
            TextButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 59, 214, 27),
              ),
              onPressed: () {
                loadCamera();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "CAMERA",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 59, 214, 27),
              ),
              onPressed: () {
                loadImageGallery();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "GALLERY",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            tf == 0
                ? Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          height: 200,
                          width: 200,
                          child: Image.file(image),
                        ),
                        predictions!.isNotEmpty
                            ? Container(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "It is " +
                                          predictions![0]['label']
                                              .toString()
                                              .substring(1),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text('Confidence : ' +
                                        predictions![0]['confidence']
                                            .toString())
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                child: Text(
                                    "No Disease was Recognized, Kindly Provide Proper Image !"),
                              ),
                      ],
                    ),
                  )
                : Container()
          ]),
        ),
      ),
    );
  }
}
