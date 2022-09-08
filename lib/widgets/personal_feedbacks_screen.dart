import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/widgets/custm_indicator.dart';
import 'package:talkback/widgets/feedback_card.dart';

class PersonalFeedbacksView extends StatelessWidget {
  const PersonalFeedbacksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // backgroundColor: const Color.fromRGBO(213, 244, 255, 1.0),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var provider = Provider.of<UserProvider>(context, listen: false);
          provider.refreshLoad();
        },
        backgroundColor: const Color.fromRGBO(10, 57, 89, 1.0),
        child: const Icon(Icons.replay),
      ),
      appBar: AppBar(
        title: const Text('Your feedbacks'),
        backgroundColor: Colors.black,
      ),
      body: const FeedbacksListWidget(),
    );
  }
}

class FeedbacksListWidget extends StatefulWidget {
  const FeedbacksListWidget({Key? key}) : super(key: key);

  @override
  State<FeedbacksListWidget> createState() => _FeedbacksListWidgetState();
}

class _FeedbacksListWidgetState extends State<FeedbacksListWidget> {
  void loadMoreFeedbacks() {
    Provider.of<UserProvider>(context, listen: false)
        .loadMoreFeedbacksForUser();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: Consumer<UserProvider>(
      builder: (ctx, up, wid) {
        return FutureBuilder(
            future: up.loadDataList,
            builder: (ctx2, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomIndicatorWidget());
              } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'some error occurred. please retry.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
              } else if (snapshot.connectionState == ConnectionState.done || 1<0) {
                if (up.dataList.isEmpty) {
                  return const Center(
                    child: Text(
                      'no feedbakcs yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.extentAfter < 30) {
                      loadMoreFeedbacks();
                    }
                    return true;
                  },
                  child: ListView.builder(
                      padding:
                          const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                      itemCount: (up.canLoadMore)
                          ? (up.dataList.length + 1)
                          : (up.dataList.length),
                      itemBuilder: (ctx3, index) {
                        if (index == up.dataList.length) {
                          return const LoadingFeedBackWidget();
                        }
                        return FeedbackCardWidget(
                          feedback: up.dataList[index],
                        );
                      }),
                );
              }
              return const Center();
            });
      },
    ));
  }
}
