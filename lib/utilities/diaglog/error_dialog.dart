import 'package:flutter/material.dart';
import 'package:mynotes/utilities/genrics/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenricDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {'Ok': null},
  );
}
