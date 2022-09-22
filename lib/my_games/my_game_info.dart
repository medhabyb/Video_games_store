import 'package:flutter/material.dart';

class MyGameInfo extends StatelessWidget {
  final String _image;
  final String _title;

  const MyGameInfo(this._image, this._title);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.network("http://10.0.2.2:9090/img/" + _image, width: 155, height: 58),
            ),
            Text(_title)
          ],
        ),
      ),
    );
  }
}
