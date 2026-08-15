import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// ANSI color codes for terminals
const _reset = '\x1B[0m';
const _bold = '\x1B[1m';
const _red = '\x1B[31m';
const _green = '\x1B[32m';
const _yellow = '\x1B[33m';
const _blue = '\x1B[34m';
const _magenta = '\x1B[35m';
const _cyan = '\x1B[36m';
const _grey = '\x1B[90m';

/// Indent used for error, stack trace and wrapped message lines so they sit
/// visually underneath their header line.
const _indent = '   ';

/// How many stack frames to keep. Full traces drown the console.
const _maxStackFrames = 8;

const _jsonEncoder = JsonEncoder.withIndent('  ');

String _timeNow() {
  final now = DateTime.now();
  final h = now.hour.toString().padLeft(2, '0');
  final m = now.minute.toString().padLeft(2, '0');
  final s = now.second.toString().padLeft(2, '0');
  final ms = now.millisecond.toString().padLeft(3, '0');
  return '$h:$m:$s.$ms';
}

String _levelColor(Level level) {
  switch (level) {
    case Level.trace:
      return _magenta;
    case Level.debug:
      return _cyan;
    case Level.info:
      return _green;
    case Level.warning:
      return _yellow;
    case Level.error:
      return _red;
    case Level.fatal:
      return '$_bold$_red';
    default:
      return _grey;
  }
}

String _levelEmoji(Level level) {
  switch (level) {
    case Level.trace:
      return '🔍';
    case Level.debug:
      return '🐞';
    case Level.info:
      return 'ℹ️';
    case Level.warning:
      return '⚠️';
    case Level.error:
      return '❌';
    case Level.fatal:
      return '💥';
    default:
      return '•';
  }
}

/// Short, fixed-width level labels so the message column always lines up.
String _levelLabel(Level level) {
  switch (level) {
    case Level.warning:
      return 'WARN';
    case Level.trace:
      return 'TRACE';
    default:
      return level.name.toUpperCase();
  }
}

/// Renders maps and lists as indented JSON instead of Dart's single-line
/// `toString()`, and leaves everything else as-is.
String _formatMessage(Object? message) {
  if (message == null) return 'null';
  if (message is Map || message is Iterable) {
    try {
      return _jsonEncoder.convert(message);
    } catch (_) {
      // Not JSON-encodable (contains non-primitives) — fall through.
    }
  }
  return message.toString();
}

class ColorfulPrinter extends LogPrinter {
  final bool colors;
  final bool emojis;

  ColorfulPrinter({this.colors = true, this.emojis = true});

  String _paint(String text, String color) =>
      colors && color.isNotEmpty ? '$color$text$_reset' : text;

  @override
  List<String> log(LogEvent event) {
    final level = event.level;
    final color = _levelColor(level);
    final emoji = emojis ? '${_levelEmoji(level)} ' : '';
    final label = _levelLabel(level).padRight(5);

    final lines = <String>[];

    // Header: emoji, level, time, then the first line of the message.
    final messageLines = _formatMessage(event.message).split('\n');
    final header =
        '$emoji${_paint(label, color)} ${_paint('│', _grey)} '
        '${_paint(_timeNow(), _grey)} ${_paint('│', _grey)} ';
    lines.add('$header${_paint(messageLines.first, color)}');

    // Any remaining message lines sit indented under the header.
    for (final line in messageLines.skip(1)) {
      lines.add('$_indent${_paint(line, color)}');
    }

    if (event.error != null) {
      lines.add(_paint('$_indent↳ ${event.error}', _red));
    }

    if (event.stackTrace != null) {
      final frames = event.stackTrace!.toString().trimRight().split('\n');
      for (final frame in frames.take(_maxStackFrames)) {
        lines.add(_paint('$_indent  ${frame.trim()}', _blue));
      }
      final hidden = frames.length - _maxStackFrames;
      if (hidden > 0) {
        lines.add(_paint('$_indent  … $hidden more frames', _grey));
      }
    }

    return lines;
  }
}

// Flutter routes logs through the `flutter:` channel, which does not interpret
// ANSI escapes — they show up as literal `^[[32m` noise in the debug console.
// Flip this to true only when running in a real terminal that renders colors.
const _useAnsiColors = false;

final logger = Logger(
  level: kDebugMode ? Level.debug : Level.off,
  printer: ColorfulPrinter(colors: _useAnsiColors, emojis: true),
);
