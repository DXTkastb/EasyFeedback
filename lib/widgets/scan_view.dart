import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanView extends StatefulWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  bool detected = false;
  String id = '';
  String upiId = '';
  late final MobileScannerController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
       //   const Expanded(child: SizedBox(),),
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                if (!detected) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if(barcodes.last.rawValue!=null && barcodes.last.rawValue!.isNotEmpty && mounted){
                     Uri uri = Uri.parse(barcodes.last.rawValue!);
                    if(uri.host.compareTo("pay") == 0 && uri.scheme.compareTo("upi") == 0) {
                      setState(() {
                      detected = true;
                      id = '${uri.queryParameters['pn']}\n${uri.queryParameters['pa']}';
                      upiId = '${uri.queryParameters['pa']}';
                    });
                    }
                  }
                }
              },
            ),
          ),
          Container(
            color: Colors.black,
            height: 150,
            width: double.infinity,
            padding:const EdgeInsets.only(left: 10,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.lightBlueAccent),
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: cameraController.torchState,
                    builder: (context, state, child) {
                      switch (state as TorchState) {
                        case TorchState.off:
                          return const Icon(Icons.flash_off,
                              color: Colors.black);
                        case TorchState.on:
                          return const Icon(Icons.flash_on,
                              color: Colors.yellow);
                      }
                    },
                  ),
                  onPressed: () => cameraController.toggleTorch(),
                ),
                (id.isEmpty)?const SizedBox(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white,),):SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: 200,
                          child: Text(id,textAlign:TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 17),)),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(Colors.lightBlueAccent),
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                        ),
                        onPressed: () {
                          if(id.isNotEmpty){
                            Navigator.of(context).pop(upiId);
                          }
                      }, child: const Text('proceed'),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.lightBlueAccent),
                    padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: (id.isNotEmpty)?Colors.white:Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      detected = false;
                      id = '';
                    });
                  },
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
