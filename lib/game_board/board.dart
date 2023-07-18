import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/game_board/piece.dart';
import 'package:tetris/game_board/pixel.dart';
import 'package:tetris/game_board/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece
  Pieces currentPiece = Pieces(type: Tetromino.J);

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.intializePiece();

    Duration framerarte = const Duration(milliseconds: 800);
    gameLoop(framerarte);
  }

  void gameLoop(Duration framerate) {
    Timer.periodic(framerate, (timer) {
      setState(() {
        checkLanding();
        currentPiece.movePiece(Directions.down);
      });
    });
  }

  bool checkColission(Directions directions) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (directions == Directions.left) {
        col -= 1;
      } else if (directions == Directions.right) {
        col += 1;
      } else if (directions == Directions.down) {
        row += 1;
      }

      //check pieces are out of bound
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    }

    return false;
  }

  void checkLanding() {
    // if going down is occupied or landed on other pieces
    if (checkColission(Directions.down) || checkLanded()) {
      // mark position as occupied on the game board
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, create the next piece
      createNewPiece();
    }
  }

  void moveLeft() {
    if (!checkColission(Directions.left)) {
      setState(() {
        currentPiece.movePiece(Directions.left);
      });
    }
  }

  void rotatePiece() {
    currentPiece.rotatePiece();
  }

  void moveRight() {
    if (!checkColission(Directions.left)) {
      setState(() {
        currentPiece.movePiece(Directions.right);
      });
    }
  }

  bool checkLanded() {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // check if the cell below is already occupied
      if (row + 1 < colLength && row >= 0 && gameBoard[row + 1][col] != null) {
        return true; // collision with a landed piece
      }
    }

    return false; // no collision with landed pieces
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Pieces(type: randomType);
    currentPiece.intializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength),
              itemBuilder: (context, index) {
                //row and column of each index
                int row = (index / rowLength).floor();
                int col = index % rowLength;
                //current piece
                if (currentPiece.position.contains(index)) {
                  return Pixel(
                    color: currentPiece.color,
                    child: index,
                  );
                }

                //landed pieces
                else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(color: tetrominoColor[tetrominoType], child: '');
                }

                //black piece
                else {
                  return Pixel(
                    color: Colors.grey[900],
                    child: index,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: moveLeft,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.rotate_right_rounded,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: moveRight,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
