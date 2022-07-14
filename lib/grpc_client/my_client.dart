import 'package:grpc/grpc.dart';
import '/grpc_client/grpc_core/service.pbgrpc.dart';

class MyClient {
  MyClient._privateConstructor();
  static MyClient myClient = MyClient._privateConstructor();

  Future<String> main() async {
  final channel = ClientChannel(
    '10.0.2.2',
    port: 8080,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure())
  );

  final stub = HelloServiceClient(channel);
  await Future.delayed(const Duration(seconds: 2));

  try {
  var request =HelloRequest();
  request.setField(1, "Kaustubh");
  request.setField(2, "Dixit");
  var response =await stub.hello(request);
  return response.greeting;

  } catch (e) {
    print(e);
  return 'nothing';
  }
  finally{
    await channel.shutdown();
  }

}


}