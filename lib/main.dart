import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Variables

  // Intial Chessboard
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
  Container chessboardWidget = Container();

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
  void Intialize() {
    // Set up Board
    chessboardWidget = Container(
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
    return chessboardWidget;
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

    if (row == SelectedRow && col == SelectedColumn) {
      setState(() {
        board[SelectedRow][SelectedColumn].Selected = false; // setstate
      });
      SelectedRow = -1;
      SelectedColumn = -1;
    } else {
      if (SelectedColumn != -1 && SelectedColumn != -1) {
        setState(() {
          board[SelectedRow][SelectedColumn].Selected = false; // setstate
        });
      }

      SelectedRow = row;
      SelectedColumn = col;
      setState(() {
        board[SelectedRow][SelectedColumn].Selected = true; // setstate
      });
    }

    // get piece
    // check possible moves
    // change color of appropriate widgets
  }

  // App
  @override
  Widget build(BuildContext context) {
    Intialize();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GetChessboardWidget(),
      ),
    );
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
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(Icons.perm_identity),
        );
        break;

      case (1): // Knight
        Points = 3;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(Icons.snowshoeing),
        );
        break;

      case (2): // Bishop
        Points = 3;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(Icons.skip_next),
        );
        break;

      case (3): // Rook
        Points = 5;
        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(Icons.masks),
        );
        break;

      case (4): // Queen
        Points = 9;
        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(Icons.female),
        );
        break;

      case (5): // King
        Points = 999;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(Icons.male),
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
Row chessboardRowWidget(int row, List board, _MyHomePageState homepage) {
  int RowPosition = row;
  return Row(
    children: [
      chessboardSquareWidget(row, 0, board[0], homepage),
      chessboardSquareWidget(row, 1, board[1], homepage),
      chessboardSquareWidget(row, 2, board[2], homepage),
      chessboardSquareWidget(row, 3, board[3], homepage),
      chessboardSquareWidget(row, 4, board[4], homepage),
      chessboardSquareWidget(row, 5, board[5], homepage),
      chessboardSquareWidget(row, 6, board[6], homepage),
      chessboardSquareWidget(row, 7, board[7], homepage),
    ],
  );
}

// Widget Square
ElevatedButton chessboardSquareWidget(
    int row, int col, Piece piece, _MyHomePageState homepage) {
  int RowPosition = row;
  int ColumnPosition = col;
  int SquareColor = RowPosition + (ColumnPosition % 2);

  return ElevatedButton(
    onPressed: () {
      homepage.Selected(RowPosition, ColumnPosition);
      print(
          "RowPosition: $RowPosition ColumnPosition: $ColumnPosition Selected: ${piece.Selected}");
    },
    style: ButtonStyle(
      fixedSize: MaterialStateProperty.all<Size>(Size(100, 100)),
      backgroundColor: piece.Selected
          ? MaterialStateProperty.all<Color>(Colors.green.shade100)
          : SquareColor % 2 == 0
              ? MaterialStateProperty.all<Color>(Colors.orange.shade100)
              : MaterialStateProperty.all<Color>(Colors.brown.shade900),
    ),
    child: piece.ChessPiece,
  );
}
