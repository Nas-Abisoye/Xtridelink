// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BaseState extends Equatable {
  BaseState({
    this.isLoading = false,
    this.exception,
  });

  final bool isLoading;
  final Exception? exception;

  BaseState copyWith({bool? isLoading, Exception? exception});

  @override
  List<Object?> get props => [isLoading, exception];
}
