import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const ConfirmButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.pink.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
