import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CategoriesState extends Equatable {
  const CategoriesState();
}

class CategoriesLoading extends CategoriesState {
  @override
  List<Object> get props => [];
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({
    this.categories = const <Map<String, dynamic>>[],
  });

  final List<Map<String, dynamic>> categories;

  @override
  List<Object> get props => [categories];
}

class CategoriesError extends CategoriesState {
  @override
  List<Object> get props => [];
}
