import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/services/auth_service.dart';
import 'package:talkback/widgets/custm_indicator.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';
import '../styles/user_button_styles.dart';

class NetworkErrorScreenWidget extends StatefulWidget{
  const NetworkErrorScreenWidget({Key? key}) : super(key: key);

  @override
  State<NetworkErrorScreenWidget> createState() => _NetworkErrorScreenWidgetState();
}

class _NetworkErrorScreenWidgetState extends State<NetworkErrorScreenWidget> {
  bool retrying = false;

  void retry() async {
    setState(() {
      retrying = true;
    });
    var response = await AuthService.service.userLoggedIn();
    response = response as http.Response;
    if(response.statusCode == 200) {
      if(mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .setUserNamePhoneNumber(response.body);
        Navigator.of(context).pushReplacementNamed('home-page');
        return;
      }
    }
    else if(response.statusCode == 403) {
      Navigator.of(context).pushReplacementNamed('login');
    } else {
      setState(() {
        retrying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(177, 220, 255, 1.0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.network_ping_rounded,size: 40,),
            const SizedBox(height: 10,),
            const Text('Unable to connect to internet. Please check your device connection.',textAlign: TextAlign.center,),
            const SizedBox(height: 10,),
            retrying?ElevatedButton(onPressed: (){}, child: const CustomIndicatorWidget(),style: UserButtonStyles.userButtonStyle,):
            ElevatedButton(onPressed: retry, child: const Text('retry'),style: UserButtonStyles.userButtonStyle,)
          ],
        ),
      ),
    );
  }
}