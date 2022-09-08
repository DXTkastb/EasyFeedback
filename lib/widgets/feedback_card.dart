import 'package:flutter/material.dart';
import 'package:talkback/widgets/custm_indicator.dart';

import '../data/feedback_data.dart';

class FeedbackCardWidget extends StatelessWidget {
  final FeedbackData feedback;

  const FeedbackCardWidget({Key? key, required this.feedback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(171, 226, 250, 1.0),
                borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(feedback.vendorName,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 13),),
                  Text(feedback.time,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 11),),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(212, 240, 253, 1.0),
                  borderRadius: BorderRadius.circular(5)
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Text(feedback.feedback,style: const TextStyle(fontWeight: FontWeight.w500),)
            )
          ],
        ),
      ),
    );
  }
}

class LoadingFeedBackWidget extends StatelessWidget{
  const LoadingFeedBackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
      child: const Padding(
        padding:  EdgeInsets.all(25),
        child: Center(child: CustomIndicatorWidget(),)
      ),
    );
  }
}