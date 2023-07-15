import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../service/ml_service.dart';
import './pop_up.dart';
// import 'package:';

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  MLService _mlService = MLService();

  File? _image;
  final picker = ImagePicker();

  late String? scannedText = "";
  late String? answeredText = "";

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    scanImage(image);
    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    // 화면 세로 고정
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
        body: SingleChildScrollView(
           child:Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               SizedBox(height: 25.0),
               SizedBox (
                 child: Column (
                   children: [
                     InkWell(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => pop_up(scannedText:scannedText!)),
                         );
                       },
                       child: Container(
                         color: const Color(0xffd0cece),
                         width: MediaQuery.of(context).size.width,
                         height: MediaQuery.of(context).size.width,
                         child: Center(
                           child: _image == null
                               ? Text('No image selected.')
                               : Image.file(File(_image!.path)),
                         ),
                       ),
                     ),
                     SizedBox(height: 5.0),
                     SizedBox(
                       width: 350,
                       child: Row(
                         children: [
                           Expanded(
                             child: TextField(
                               controller: _controller,
                               decoration: InputDecoration(
                                 labelText: '입력란 레이블',
                                 hintText: '입력 내용을 입력하세요',
                               ),
                             ),
                           ),
                           ElevatedButton(
                             onPressed: () {
                               String inputValue = _controller.text;
                               submitQuestion(inputValue);
                               // Do something with the input value
                             },
                             child: Text('submit'),
                           ),
                         ],
                       ),
                     ),

                     SizedBox(height: 25.0),
                     SizedBox(
                       height: 200,
                       child:
                       Container(
                         color: const Color(0xffd0cece),
                         // width: MediaQuery.of(context).size.width,
                         // height: MediaQuery.of(context).size.width,

                         child: Center(

                           child: answeredText != ""
                               ? Text(
                             answeredText!,
                             style: TextStyle(fontSize: 18),
                             textAlign: TextAlign.center,
                           )
                               : Text('No answered image available.'),
                         ),
                       ),
                     ),

                     SizedBox(height: 25.0),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: <Widget>[
                         // 카메라 촬영 버튼
                         FloatingActionButton(
                           child: Icon(Icons.add_a_photo),
                           tooltip: 'pick Iamge',
                           onPressed: () {
                             getImage(ImageSource.camera);
                           },
                         ),

                         // 갤러리에서 이미지를 가져오는 버튼
                         FloatingActionButton(
                           child: Icon(Icons.wallpaper),
                           tooltip: 'pick Iamge',
                           onPressed: () {
                             getImage(ImageSource.gallery);
                           },
                         ),
                       ],
                     )
                   ],
                 ),

               ),


               //   SizedBox(height: 50.0),
               //
             ],

           )
        ),

    );
  }

  Future<Uint8List?> convertXFileToUint8List(XFile xFile) async {
    try {
      File file = File(xFile.path);
      Uint8List bytes = await file.readAsBytes();
      return bytes;
    } catch (e) {
      print('Error converting XFile to Uint8List: $e');
      return null;
    }
  }

  void scanImage(XFile? image) async {
    setState(() {
      scannedText = "";
    });

    Uint8List? bytes = await convertXFileToUint8List(image!);

    var scannedTextData = await _mlService.convertDocImage(bytes!);

    setState(() {
      scannedText = scannedTextData ?? "";
    });
  }

  void submitQuestion(String question) async {
    setState(() {
      answeredText = "";
    });

    String? answeredTextData = await _mlService.answertoText(scannedText!, question);
    answeredTextData = "질문 : " + question + "\n-----------------\n" + "대답 : " + answeredTextData!;
    setState(() {
      answeredText = answeredTextData ?? "";
    });
  }
}
