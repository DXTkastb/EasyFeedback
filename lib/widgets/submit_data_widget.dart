import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/refreshttext.dart';

import 'custm_indicator.dart';

class SubmitDataWidget extends StatelessWidget {
  final void Function()? onpressed;
  const SubmitDataWidget({Key? key, this.onpressed}) : super(key: key);
  TextStyle getStyle(){
    return const TextStyle(decoration: TextDecoration.none, fontSize: 15,color: Colors.black);
  }
  List<Widget> getChildren(int num){
    List<Widget> list = [];
    if(num == 200) {
      list =  [
        const Icon(Icons.check,size: 40,color: Colors.white,),
      ];
    }
    list = [
      Text('some error occurred. please try later',style: getStyle(),),
    ];

    list.add( ElevatedButton(onPressed: onpressed, child: Text('OK')),);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider
            .of<RefreshText>(context, listen: false)
            .future,
        builder: (ctx, snapshot) {
          List<Widget> widgets= [
            const CustomIndicatorWidget(),
            Text(
              'submitting...',
              style: getStyle(),
            )
          ];
          if (snapshot.connectionState == ConnectionState.done) {
            widgets = getChildren(snapshot.data as int);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          );
        });
  }
}
