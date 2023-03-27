import 'package:flutter/material.dart';

class UnderReview extends StatefulWidget {
  @override
  State<UnderReview> createState() => _UnderReviewState();
}

class _UnderReviewState extends State<UnderReview> {
  late BuildContext ctx;
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.red,
              child: _isHidden
                  ? Text('data')
                  : Text("Container 1",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Container(
              height: 100,
              width: 100,
              color: Colors.blue,
              child: !_isHidden
                  ? null
                  : Text("Container 2",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isHidden = !_isHidden;
                });
              },
              child: Text("Toggle Containers"),
            ),
          ],
        ),
      ),
    );
  }
}

