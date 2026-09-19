import 'package:flutter/material.dart';
import 'package:mynotes/utilities/genrics/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenricDialog(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this item',
    optionsBuilder: () => {'Cancel': false, 'Delete': true},
  ).then((value) => value ?? false);
}
