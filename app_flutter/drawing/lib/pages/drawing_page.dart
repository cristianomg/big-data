import 'dart:io';

import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:drawing/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/drawn_line.dart';
import '../widgets/sketcher.dart';
import '../widgets/toolbar_button.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey globalKey = GlobalKey();
  DrawnLine? line;
  List<DrawnLine> undoLine = <DrawnLine>[];
  Color selectedColor = Colors.white;
  double selectedWidth = 5.0;

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGestureDetector(context),
        buildToolbar(context),
      ],
    );
  }

  void onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);

    if (line == null) {
      setState(() {
        line = DrawnLine([point], selectedColor, selectedWidth);
      });
    } else {
      final List<Offset> path = (List.from(line!.path)..add(point));
      setState(() {
        line = DrawnLine(path, selectedColor, selectedWidth);
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    final List<Offset> path = (List.from(line!.path)..add(point));
    setState(() {
      line = DrawnLine(path, selectedColor, selectedWidth);
    });
  }

  void onPanEnd(DragEndDetails details) {
    undoLine.add(line!);
  }

  void onReset() {
    setState(() {
      line = DrawnLine([], selectedColor, selectedWidth);
      undoLine.clear();
    });
  }

  void onUndo() {
    if (undoLine.isNotEmpty) {
      final lastUndo = undoLine.last;
      undoLine.removeLast();
      setState(() {
        line = lastUndo;
      });
    }
  }

  Future<void> onSubmit() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final file = await writeToFile(byteData!);

    final response = await _apiService.predict(file!);
    if (response != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Resultado'),
              content: Text(response),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    }
  }

  Future<File?> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Widget buildGestureDetector(context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(4.0),
          color: Colors.transparent,
          alignment: Alignment.topLeft,
          child: CustomPaint(
            painter: Sketcher(
                lines: [line ?? DrawnLine([], selectedColor, selectedWidth)]),
          ),
        ),
      ),
    );
  }

  Widget buildToolbar(context) {
    return Positioned(
      bottom: 5.0,
      right: 10,
      child: Column(
        children: [
          ToolBarButton(
            onPressed: onSubmit,
            text: 'Submit',
          ),
          ToolBarButton(
            onPressed: onUndo,
            text: 'Undo',
          ),
          ToolBarButton(
            onPressed: onReset,
            text: 'Reset',
          ),
        ],
      ),
    );
  }
}
