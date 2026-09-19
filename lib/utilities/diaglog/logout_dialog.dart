import 'package:flutter/material.dart';
import 'package:mynotes/utilities/genrics/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenricDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure want to logout',
    optionsBuilder: () => {'Cancel': false, 'Yes': true},
  ).then((value) => value ?? false);
}
