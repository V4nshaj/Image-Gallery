import 'package:flutter/material.dart';

int calculateColumns(double screenWidth) {
  // Adjust these values based on your desired minimum and maximum columns
  const double minColumnWidth = 50.0;
  const int maxColumns = 4;

  int calculatedColumns = (screenWidth / minColumnWidth).floor();
  return calculatedColumns.clamp(1, maxColumns); // Ensure at least 1 column
}
