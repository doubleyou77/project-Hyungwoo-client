import 'package:flutter/material.dart';
import 'package:project_hyungwoo/page/pop_up.dart';

class pop_up extends StatelessWidget {
  final String scannedText;

  pop_up({required this.scannedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.0),
          ElevatedButton(
            onPressed: () {
              goBack(context);
            },
            child: Text('Go Back'),
          ),
          Expanded(
            child: scannedText != ""
                ? Text(
                    scannedText,
                    style: TextStyle(fontSize: 18),
                    // textAlign: TextAlign.center,
                  )
                : Text('No scanned image available.'),
          ),
        ],
      ),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
