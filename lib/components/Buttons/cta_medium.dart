

import 'package:finamp/color_schemes.g.dart';
import 'package:flutter/material.dart';

class CTAMedium extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  const CTAMedium({super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          jellyfinBlueColor.withOpacity(0.3),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: jellyfinBlueColor,
            weight: 1.5,
          ),
          const SizedBox(width: 8,),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}