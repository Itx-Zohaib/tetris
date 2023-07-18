import 'package:flutter/material.dart';

//grid dimensions
int rowLength = 10;
int colLength = 15;

enum Directions {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetromino, Color> tetrominoColor = {
  Tetromino.L: Colors.blue,
  Tetromino.J: Colors.cyan,
  Tetromino.I: Colors.deepOrange,
  Tetromino.O: Colors.deepPurple,
  Tetromino.S: Colors.green,
  Tetromino.Z: Colors.teal,
  Tetromino.T: Colors.yellow
};
