import 'dart:ui';

import 'package:flutter/material.dart';

import 'inside_overlay.dart';

class FeedBackWidget extends StatefulWidget {
  final vendrID;
  final int ordernumber;

  const FeedBackWidget({Key? key, this.vendrID, this.ordernumber = -1})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FeedBackWidgetState();
  }
}

class FeedBackWidgetState extends State<FeedBackWidget>
    with SingleTickerProviderStateMixin {
  late bool feedbackCompleted;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 35),
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
    if (false) {
      setState(() {
        if (!feedbackCompleted) {
          feedbackCompleted = true;
        }
      });
    }
  }

  OverlayEntry getOverLay() {
    return OverlayEntry(
        builder: (overlayContext) {
          return FadeTransition(
            opacity: _animation,
            child: Container(
              color: Colors.white.withOpacity(0.55),
              alignment: Alignment.bottomCenter,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: LayoutBuilder(
                        builder: (ctx, cons) {
                          return InsideOverlay(
                            boxConstraints: cons,
                            onpressed: onDone,
                            vendorID: widget.vendrID,
                          );
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
      onTap: (feedbackCompleted)
          ? null
          : () {
              showOverlay(context);
            },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: (feedbackCompleted)
                ? null
                : const [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 30,
                      spreadRadius: 0.5,
                    )
                  ],
            color:
                (feedbackCompleted) ? Colors.white60 : Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(45)),
        alignment: Alignment.center,
        width: 100,
        height: 70,
        child: const Text(
          "TAP",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    feedbackCompleted = false;
    super.initState();
  }
}
