import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class PngHome extends StatefulWidget {
  const PngHome({Key? key}) : super(key: key);

  @override
  State<PngHome> createState() => _PngHomeState();
}

class _PngHomeState extends State<PngHome> {
  GlobalKey globalKey = GlobalKey();

  Future<void> _capturePng() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    print(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Center(
        child: TextButton(
          child: const Text('Hello World', textDirection: TextDirection.ltr),
          onPressed: _capturePng,
        ),
      ),
    );
  }
}
