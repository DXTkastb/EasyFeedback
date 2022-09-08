import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/widgets/uploading_data_snackbar.dart';

import '../apis/main_api.dart';
import 'inside_overlay.dart';

class FeedBackWidget extends StatefulWidget {
  const FeedBackWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FeedBackWidgetState();
  }
}

class FeedBackWidgetState extends State<FeedBackWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late OverlayEntry overlayEntry;
  late OverlayState overlayState;
  String upiLink = '';

  void showOverlay() {
    overlayEntry = getOverLay(upiLink);
    Overlay.of(context).insert(overlayEntry);
    _controller.forward();
    overlayState = Overlay.of(context);
  }

  Future<void> onDone(String speechData) async {
    await _controller.reverse();
    if (overlayState.mounted) {
      overlayEntry.remove();
    }
    var link = upiLink;
    if (mounted && upiLink.isNotEmpty) upiLink = '';
    if (mounted && speechData.isNotEmpty) {
      String phoneNum =
          Provider.of<UserProvider>(context, listen: false).phoneNumber;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: DataUploadSnackBar(
        speech: speechData,
        link: link,
        phoneNum: phoneNum,
      )));
    }
  }

  OverlayEntry getOverLay(String upiLink) {
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
                            upiLink: upiLink,
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
      onTap: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        final val =  await (Navigator.of(context).pushNamed("scan-qr"));
        if ((mounted && val != null)) {
          upiLink = val as String;
          // check upi with backend db while a circular indicator works
          // once checked push the overlay
          showOverlay();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 30,
                spreadRadius: 0.5,
              )
            ],
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(45)),
        alignment: Alignment.center,
        width: 120,
        height: 70,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner_sharp,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "SCAN",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.black),
            )
          ],
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
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 35),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }
}
