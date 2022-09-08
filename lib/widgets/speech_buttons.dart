import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final void Function()? onpressed;
  final String text;

  const BottomButton({Key? key, this.onpressed, required this.text, required this.color, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
          decoration: BoxDecoration(
              color: (onpressed == null)?Colors.blueGrey:color, borderRadius: BorderRadius.circular(25)),
          alignment: Alignment.center,
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,color: Colors.white,),
              const SizedBox(width: 5,),
              Text(
                text,
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ],
          )
      ),
    );
  }
}