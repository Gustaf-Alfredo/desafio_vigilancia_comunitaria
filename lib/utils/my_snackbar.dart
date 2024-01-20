import "package:flutter/material.dart";

showSnackBar(
    {required BuildContext context, required String text, bool isErro = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    backgroundColor: (isErro) ? Colors.red : Colors.green,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
