import 'dart:async';
import 'dart:developer';
import 'package:logging/logging.dart';

class Logger {
  /// This functions are designed to map closely to the logging information
  /// collected by `package:logging`.
  ///
  /// - [message] is the log message
  /// - [time] (optional) is the timestamp
  /// - [sequenceNumber] (optional) is a monotonically increasing sequence number
  /// - [name] (optional) is the name of the source of the log message
  /// - [zone] (optional) the zone where the log was emitted
  /// - [error] (optional) an error object associated with this log event
  /// - [stackTrace] (optional) a stack trace associated with this log event

  static info(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    String name = '',
    Type? runtimeType,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      level: Level.INFO.value,
      sequenceNumber: sequenceNumber,
      name:
          name != ''
              ? name
              : runtimeType != null
              ? runtimeType.toString()
              : '',
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static warn(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    String name = '',
    Type? runtimeType,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      level: Level.WARNING.value,
      sequenceNumber: sequenceNumber,
      name:
          name != ''
              ? name
              : runtimeType != null
              ? runtimeType.toString()
              : '',
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static debug(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    String name = '',
    Type? runtimeType,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      level: Level.SHOUT.value,
      sequenceNumber: sequenceNumber,
      name:
          name != ''
              ? name
              : runtimeType != null
              ? runtimeType.toString()
              : '',
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static error(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    String name = '',
    Type? runtimeType,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      time: time,
      level: Level.SEVERE.value,
      sequenceNumber: sequenceNumber,
      name:
          name != ''
              ? name
              : runtimeType != null
              ? runtimeType.toString()
              : '',
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
