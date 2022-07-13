import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:talkback/feedbackWidget/inside_overlay.dart';

class FeedBackWidget extends StatefulWidget {
  const FeedBackWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FeedBackWidgetState();
  }
}

class FeedBackWidgetState extends State<FeedBackWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late OverlayEntry overlayEntry;
  late OverlayState overlayState;

  void showOverlay(BuildContext context) {
    overlayEntry = getOverLay();
    Overlay.of(context)!.insert(overlayEntry);
    _controller.forward();
    overlayState = Overlay.of(context)!;
  }

  Future<void> onDone() async {
  await _controller.reverse();
  if (overlayState.mounted) {
  overlayEntry.remove();
  }
}

  OverlayEntry getOverLay() {
    return OverlayEntry(
        builder: (overlayContext) {
          return FadeTransition(
            opacity: _animation,
            child: Container(
              color: Colors.white.withOpacity(0.2),
              alignment: Alignment.bottomCenter,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: LayoutBuilder(
                        builder: (ctx, cons) {
                          return InsideOverlay(boxConstraints: cons,onpressed: onDone,);
                        },
                      ),
                    ),
                  )),
            ),
          );
        },
        opaque: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showOverlay(context);
        },
        child: const Text('press'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
