import 'package:flutter/material.dart';
import 'package:mynotes/utilities/generic_dialog.dart';

Future<bool> showDeleteNoteDialog(BuildContext context) {
  return showGenricDialog(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {'Cancel': false, 'Delete': true},
  ).then((value) => value ?? false);
}
