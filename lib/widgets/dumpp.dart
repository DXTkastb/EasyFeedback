// @override
// Widget build(BuildContext context) {
//   return ChangeNotifierProvider<RefreshText>(
//     create: (BuildContext ctx) => RefreshText(),
//     builder: (cnp, _) {
//       return FutureBuilder(
//           future: audioFuture,
//           builder: (futureContext1, snapshot1) {
//             if (snapshot1.connectionState == ConnectionState.done) {
//               //   widget.onpressed!();
//               // }
//               // if (snapshot1.connectionState == ConnectionState.done) {
//               return Column(
//                 children: [
//                   Container(
//                       child: const LinearIndicator(),
//                       width: 200,
//                       padding: const EdgeInsets.all(20)),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.blue.shade200,
//                         borderRadius: BorderRadius.circular(30)),
//                     height: widget.boxConstraints.maxHeight - 145,
//                     width: widget.boxConstraints.maxWidth,
//                     child: Center(
//                       child: SingleChildScrollView(
//                         reverse: true,
//                         padding: const EdgeInsets.all(15),
//                         child: Consumer<RefreshText>(
//                           builder: (cnp2, b, c) {
//                             if(b.recording) {
//                               return StreamTextWidget(widget.upiLink);
//                             }
//                             return SubmitDataWidget(onpressed:widget.onpressed!);
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     padding: const EdgeInsets.all(10),
//                     child: (recording)?const SpinKitPulse(
//                       color: Colors.black,
//                       size: 30,
//                       duration: Duration(milliseconds: 700),
//                     ):const SizedBox(width: 30,height: 30,),
//                   ),
//                   SizedBox(
//                     height: 50,
//                     width: widget.boxConstraints.maxWidth,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         BottomButton(
//                             onpressed: (recording)?() async {
//                               AudioApi.api.closeAllConnections();
//                               widget.onpressed!();
//                             }:null,color: Colors.redAccent,
//                             icon: Icons.cancel,
//                             text: 'Cancel'),
//                         BottomButton(
//                             onpressed: (recording)?() async {
//                               await Provider.of<RefreshText>(
//                                   futureContext1,
//                                   listen: false)
//                                   .refresh();
//                             }:null,color: Colors.black,
//                             icon: Icons.refresh,
//                             text: 'Restart'),
//                         BottomButton(
//                             onpressed: () async {
//                               if(!recording) return;
//                               setState(() {
//                                 recording = false;
//                               });
//                               Provider.of<RefreshText>(
//                                   futureContext1,
//                                   listen: false).recordingOff();
//                               AudioApi.api.closeAllConnections();
//                               // widget.onpressed!();
//                             },color: Colors.green,
//                             icon: Icons.check_circle_rounded,
//                             text: 'Submit')
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             }
//             return const CircularProgressIndicator(
//               color: Colors.black,
//             );
//           });
//     },
//   );
// }