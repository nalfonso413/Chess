// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'main.dart';

// MAKE CHESSBOARD THE HOMEPAGE WIDGET LMOAO

class Chessboard {
  /// Variables

  // Chessboard
  List board = [
    // Row 1
    [
      Piece(3, 1), // Black Rook
      Piece(1, 1), // Black Knight
      Piece(2, 1), // Black Bishop
      Piece(4, 1), // Black Queen
      Piece(5, 1), // Black King
      Piece(2, 1), // Black Bishop
      Piece(1, 1), // Black Knight
      Piece(3, 1), // Black Rook
    ],
    // Row 2
    [
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
      Piece(0, 1), // Black Pawn
    ],
    // Row 3
    [
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
    ],
    // Row 4
    [
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
    ],
    // Row 5
    [
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
    ],
    // Row 6
    [
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
      Piece(-1, -1),
    ],
    // Row 7
    [
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
      Piece(0, 0), // White Pawn
    ],
    // Row 8
    [
      Piece(3, 0), // White Rook
      Piece(1, 0), // White Knight
      Piece(2, 0), // White Bishop
      Piece(4, 0), // White Queen
      Piece(5, 0), // White King
      Piece(2, 0), // White Bishop
      Piece(1, 0), // White Knight
      Piece(3, 0), // White Rook
    ],
  ];

  // Widget of Chessboard
  Container widget = Container();

  // Current Turn
  bool Turn = false; // false White, true Black;

  // White Points
  int WhitePoints = 0;

  // Black Points
  int BlackPoints = 0;

  // Is Game Over
  bool GameOver = false;

  // Selected Row
  int SelectedRow = -1;

  // Selected Column
  int SelectedColumn = -1;

  /// Constructor
  Chessboard() {
    // Set up Board
    widget = Container(
      child: Column(
        children: [
          chessboardRowWidget(0, board[0], this),
          chessboardRowWidget(1, board[1], this),
          chessboardRowWidget(2, board[2], this),
          chessboardRowWidget(3, board[3], this),
          chessboardRowWidget(4, board[4], this),
          chessboardRowWidget(5, board[5], this),
          chessboardRowWidget(6, board[6], this),
          chessboardRowWidget(7, board[7], this),
        ],
      ),
    );
  }

  /// Getters
  Container GetChessboardWidget() {
    return widget;
  }

  List GetBoard() {
    return board;
  }

  /// Setters

  // Check for king check

  // Check for win

  // Switch Turn

  void ToggleTurn() {
    Turn = !Turn;
  }

  // Selected
  void Selected(int row, int col) {
    // Unselect if possible
    // recolor board squares to normal

    if (row != -1 && col != -1) {
      board[row][col].Selected = false; // setstate

    }

    // get piece
    // check possible moves
    // change color of appropriate widgets
  }
}

/// Chess Piece
class Piece {
  // Type of Pawn
  int Type = -1; // 0 Pawn, 1 Knight, 2 Bishop, 3 Rook, 4 Queen, 5 King

  // Piece Color
  int Team = -1; // 0 White, 1 Black

  // How many points the piece is worth
  int Points = 0;

  // Selected
  bool Selected = false;

  // Piece Widget
  Container ChessPiece = Container(); // TOdo

  // Pawn First Turn

  /// Constructor
  Piece(int ty, int te) {
    Type = ty;
    Team = te;

    // Set Piece Icon and Points
    switch (Type) {
      case (0): // Pawn
        Points = 1;

        ChessPiece = Container(
          child: Icon(Icons.perm_identity),
          color: Team % 2 == 0 ? Colors.white : Colors.black,
        );
        break;

      case (1): // Knight
        Points = 3;

        ChessPiece = Container(
          child: Icon(Icons.snowshoeing),
          color: Team % 2 == 0 ? Colors.white : Colors.black,
        );
        break;

      case (2): // Bishop
        Points = 3;

        ChessPiece = Container(
          child: Icon(Icons.skip_next),
          color: Team % 2 == 0 ? Colors.white : Colors.black,
        );
        break;

      case (3): // Rook
        Points = 5;
        ChessPiece = Container(
          child: Icon(Icons.masks),
          color: Team % 2 == 0 ? Colors.white : Colors.black,
        );
        break;

      case (4): // Queen
        Points = 9;
        ChessPiece = Container(
          child: Icon(Icons.female),
          color: Team % 2 == 0 ? Colors.white : Colors.black,
        );
        break;

      case (5): // King
        Points = 999;

        ChessPiece = Container(
          child: Icon(Icons.male),
          color: Team % 2 == 0 ? Colors.white : Colors.black,
        );
        break;

      default:
        ChessPiece = Container();
        break;
    }
  }

  /// Methods

  // check possible moves
  void CheckMoves() {}

  // Piece is Captured
  void Captured() {}
}

// Widget Row
Row chessboardRowWidget(int row, List board, Chessboard chessboard) {
  int RowPosition = row;
  return Row(
    children: [
      chessboardSquareWidget(row, 0, board[0], chessboard),
      chessboardSquareWidget(row + 1, 1, board[1], chessboard),
      chessboardSquareWidget(row, 2, board[2], chessboard),
      chessboardSquareWidget(row + 1, 3, board[3], chessboard),
      chessboardSquareWidget(row, 4, board[4], chessboard),
      chessboardSquareWidget(row + 1, 5, board[5], chessboard),
      chessboardSquareWidget(row, 6, board[6], chessboard),
      chessboardSquareWidget(row + 1, 7, board[7], chessboard),
    ],
  );
}

// Widget Square
ElevatedButton chessboardSquareWidget(
    int color, int col, Piece piece, Chessboard chessboard) {
  int SquareColor = color;
  int RowPosition = color;
  int ColumnPosition = col;

  return ElevatedButton(
    onPressed: () {
      chessboard.Selected(RowPosition, ColumnPosition);
    },
    child: piece.ChessPiece,
    style: ButtonStyle(
      backgroundColor: piece.Selected
          ? MaterialStateProperty.all<Color>(Colors.green.shade100)
          : color % 2 == 0
              ? MaterialStateProperty.all<Color>(Colors.orange.shade100)
              : MaterialStateProperty.all<Color>(Colors.brown.shade900),
    ),
  );
}
