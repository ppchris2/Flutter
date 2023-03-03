import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _showFrontSide = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("widget.title"),
              centerTitle: true,
            ),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                SpinningCard("a", null, 'assets/images/IMG_0.jpeg'),
                SpinningCard("c", null, 'assets/images/IMG_1.jpeg'),
                SpinningCard("asd", null, 'assets/images/IMG_2.jpeg'),
                SpinningCard("g", null, 'assets/images/IMG_3.jpeg'),
                SpinningCard("g", null, 'assets/images/gifTest.gif'),
                SpinningCard("g", null, 'assets/images/gifTest.gif'),
                SpinningCard("g", null, 'assets/images/gifTest.gif'),
                SpinningCard("g", null, 'assets/images/gifTest.gif'),
                SpinningCard("g", null, 'assets/images/gifTest.gif'),
              ],
            )));
  }
}

class SpinningCard extends StatefulWidget {
  final String? front;
  final String? back;
  final String? imagePath;

  SpinningCard(this.front, this.back, this.imagePath, {super.key});

  // String front = this.front;
  @override
  State<SpinningCard> createState() => _SpinningCardState();
}

class _SpinningCardState extends State<SpinningCard> {
  bool _showFrontSide = false;
  Widget __buildLayout(
      {required Key key,
      required String? faceName,
      required String? imagePath,
      required Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: faceName != null
            ? Text(faceName, style: const TextStyle(fontSize: 80.0))
            : Image.asset(imagePath!),
      ),
    );
  }

  Widget _buildFront(String? faceName, String? imagePath) {
    return __buildLayout(
        key: const ValueKey(true),
        backgroundColor: Colors.blue,
        faceName: faceName,
        imagePath: imagePath);
  }

  Widget _buildRear(String? faceName, String? imagePath) {
    return __buildLayout(
        key: const ValueKey(false),
        backgroundColor: Colors.blue.shade700,
        faceName: faceName,
        imagePath: imagePath);
  }

  Widget buildFlipAnimation() {
    return GestureDetector(
      onTap: () => setState(() => _showFrontSide = !_showFrontSide),
      child: AnimatedSwitcher(
        transitionBuilder: __transitionBuilder,
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeOutBack.flipped,
        child: _showFrontSide
            ? _buildFront(widget.front, widget.imagePath)
            : _buildRear(widget.back, widget.imagePath),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != (widget?.key ?? "asd"));
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(const Size.square(200.0)),
      child: buildFlipAnimation(),
    );
  }
}
