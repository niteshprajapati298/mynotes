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

String _timeNow() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
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
    final label = level.name.toUpperCase().padRight(7);

    final header =
        '${_paint('[${_timeNow()}]', _grey)} ${_paint('$emoji$label', color)}';

    final lines = <String>[
      '$header ${_paint(event.message?.toString() ?? '', color)}',
    ];

    if (event.error != null) {
      lines.add(_paint('  ↳ ${event.error}', _red));
    }
    if (event.stackTrace != null) {
      for (final frame in event.stackTrace!.toString().trimRight().split('\n')) {
        lines.add(_paint('    $frame', _blue));
      }
    }

    return lines;
  }
}

final logger = Logger(
  level: kDebugMode ? Level.debug : Level.off,
  printer: ColorfulPrinter(colors: true, emojis: true),
);
