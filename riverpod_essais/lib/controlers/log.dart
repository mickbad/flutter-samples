import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


///
/// Application logger
///
final logger = MyAppLogger.storeAppDocuments(
    filename: 'var/log.txt',
    maxLogFileLines: 1000,
    level: LogLevel.info,
);


///
/// Log Levels
///
enum LogLevel {
  trace,
  debug,
  info,
  warn,
  error,
  fatal,
}


///
/// Log direction
///
/// [pathname] is the path of the log file
/// [maxLogFileLines] is the maximum number of lines in the log file (default 1000, 0 means no limit)
///
///
class MyAppLogger {
  // properties
  bool _mustConstructPathname = false;
  bool _logFile = false;
  bool showEmojis;
  int maxLogFileLines;
  LogLevel level;
  String? pathname;

  static final Map<LogLevel, String> levelEmojis = {
    LogLevel.trace: '🐾',
    LogLevel.debug: '👀',
    LogLevel.info: '💡',
    LogLevel.warn: '⚠️',
    LogLevel.error: '‼️',
    LogLevel.fatal: '💥',
  };

  ///
  /// Constructors
  ///
  MyAppLogger({
    this.pathname,
    this.maxLogFileLines = 1024,
    this.level = LogLevel.info,
    this.showEmojis = true,
  }) {
    // check arguments
    maxLogFileLines = maxLogFileLines < 0 ? 1024 : maxLogFileLines;
    if (pathname != null) {
      // check arguments
      assert(pathname!.isNotEmpty);
      _logFile = true;
    }
  }

  factory MyAppLogger.storeAppDocuments({
    String filename = 'log.txt',
    int maxLogFileLines = 1024,
    LogLevel level = LogLevel.info,
    bool showEmojis = true,
  }) {
    // check arguments
    assert(filename.isNotEmpty);
    assert(maxLogFileLines >= 0);

    // create
    return MyAppLogger(
      pathname: filename,
      maxLogFileLines: maxLogFileLines,
      level: level,
      showEmojis: showEmojis,
    ).._mustConstructPathname = true
    ..logFile = true;
  }

  ///
  /// enable/disable log file
  ///
  bool get logFile => _logFile;
  set logFile(bool value) {
    // inform maintainer-user
    if (value) {
      i("Starting log file", force: true);
    }
    else {
      w("Stop log file", force: true);
    }
    _logFile = value;
  }

  ///
  /// change log level
  ///
  LogLevel get logLevel => level;
  set logLevel(LogLevel value) => level = value;

  ///
  /// Shortcuts
  ///
  void t(String line, {bool force = false}) => log(line, prefix: LogLevel.trace, force: force);
  void d(String line, {bool force = false}) => log(line, prefix: LogLevel.debug, force: force);
  void i(String line, {bool force = false}) => log(line, prefix: LogLevel.info, force: force);
  void w(String line, {bool force = false}) => log(line, prefix: LogLevel.warn, force: force);
  void e(String line, {bool force = false}) => log(line, prefix: LogLevel.error, force: force);
  void f(String line, {bool force = false}) => log(line, prefix: LogLevel.fatal, force: force);

  ///
  /// Log
  ///
  Future log(String line, {LogLevel prefix = LogLevel.info, bool force = false}) async {
    // check level
    if (prefix.index < level.index) {
      return;
    }

    // get date
    final f = DateFormat('yyyy-MM-dd HH:mm:ss');
    final now = DateTime.now();

    // add date and time
    line = "[${f.format(now)}.${now.millisecond.toString().padRight(3, '0')}] [${prefix.name.toUpperCase()}] $line";

    // emoji
    if (showEmojis) {
      line = "${levelEmojis[prefix]} $line";
    }

    // console
    debugPrint(line);

    // write to file if pathname is not null
    if (pathname != null && (force || _logFile)) {
      // init
      await _constructRealAppDocumentsPathname();

      try {
        // init log file
        if (!File(pathname!).existsSync()) {
          File(pathname!).createSync(recursive: true);
        }

        // count file lines to rotate
        if (maxLogFileLines > 0) {
          if (File(pathname!).readAsLinesSync().length >= maxLogFileLines) {
            // move pathname to new filename with index rotation
            final newPathname = getLastRotateFilename();
            File(pathname!).renameSync(newPathname);
          }
        }

        // write to file
        File(pathname!).writeAsStringSync(
            "$line\n",
            mode: FileMode.append,
        );
      }
      catch (e) {
        // ignore
        debugPrint("write to log file --> $e");
      }
    }
  }

  ///
  /// Tools : clean logs
  ///
  /// delete current log file
  ///
  Future cleanFileLogs() async {
    // make real pathname
    await _constructRealAppDocumentsPathname();

    if (pathname != null) {
      if (File(pathname!).existsSync()) {
        File(pathname!).deleteSync();
      }

      // delete last rotate
      final newPathname = getLastRotateFilename();
      if (File(newPathname).existsSync()) {
        File(newPathname).deleteSync();
      }
    }
  }

  ///
  /// Tools : get last rotate file
  ///
  String getLastRotateFilename() {
    if (pathname != null) {
      // get name of file
      final filename = p.basename(pathname!);

      // get extension
      final extension = p.extension(filename);

      // get filename without extension
      final filenameWithoutExtension = p.basenameWithoutExtension(filename);

      final newPathname = p.join(
        p.dirname(pathname!),
        '$filenameWithoutExtension.1$extension',
      );

      return newPathname;
    }
    return "";
  }

  ///
  /// Tools : get pathname
  ///
  Future _constructRealAppDocumentsPathname() async {
    if (!_mustConstructPathname || pathname == null) {
      return;
    }

    // get documents path
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    // construct pathname
    pathname = p.join(
      appDocumentsDir.path,
      pathname!,
    );

    // disable option
    _mustConstructPathname = false;
  }
}
