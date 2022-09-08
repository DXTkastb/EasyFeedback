class FeedbackData {
  final String feedback;
  final String vendorName;
  final int feedbackId;
  final String time;
  const FeedbackData(
      {required this.feedback,required this.vendorName,required this.feedbackId,required this.time});

  static FeedbackData getDummy() {
    return const FeedbackData(feedback: 'Monday', vendorName: 'Hot@chips', feedbackId: 565, time: '2 june 2012');
  }
}