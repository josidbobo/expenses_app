import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final Function()? handler;

  const AdaptiveTextButton({Key? key, required this.text, required this.handler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: const TextStyle( 
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handler)
        : TextButton(
            style: TextButton.styleFrom(primary: Colors.purple),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handler,
          );
  }
}
