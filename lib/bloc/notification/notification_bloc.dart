import 'package:equatable/equatable.dart';
import 'package:flixage/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc extends Bloc<SimpleNotification> {
  final PublishSubject<SimpleNotification> _notificationSubject = PublishSubject();

  Stream<SimpleNotification> get notifications => _notificationSubject.stream;

  @override
  void onEvent(SimpleNotification notification) {
    _notificationSubject.add(notification);
  }

  @override
  void dispose() {
    _notificationSubject.close();
  }
}

class SimpleNotification extends Equatable {
  final String content;
  final Duration duration;
  final Color backgroundColor;
  final Color fontColor;

  SimpleNotification._(
      {this.content, this.duration, this.backgroundColor, this.fontColor});

  static SimpleNotification error({content, duration: const Duration(seconds: 3)}) =>
      SimpleNotification._(
          content: content,
          duration: duration,
          backgroundColor: Colors.red,
          fontColor: Colors.white);

  static SimpleNotification info({content, duration: const Duration(seconds: 3)}) =>
      SimpleNotification._(
          content: content,
          duration: duration,
          backgroundColor: Colors.blue,
          fontColor: Colors.white);

  @override
  List<Object> get props => [content, duration, backgroundColor, fontColor];
}
