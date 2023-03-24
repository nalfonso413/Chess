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

  /// Selected Piece
  Piece SelectedPiece = Piece(-1, -1);

  /// Possible Moves for Selected Piece
  List PossibleMoves = [];

  /// Constructor
  void Intialize() {
    // Set up Board
    chessboardWidget = Container(
      child: Column(
        children: [
          chessboardRowWidget(0, this),
          chessboardRowWidget(1, this),
          chessboardRowWidget(2, this),
          chessboardRowWidget(3, this),
          chessboardRowWidget(4, this),
          chessboardRowWidget(5, this),
          chessboardRowWidget(6, this),
          chessboardRowWidget(7, this),
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

    // Toggle Possible Positions
    TogglePossiblePositions();

    // Empty Possible Positions
    PossibleMoves.clear();

    // Unselect if player chose the same piece as last time
    if (row == SelectedRow && col == SelectedColumn) {
      setState(() {
        SelectedPiece.Selected = false;
      });
      SelectedRow = -1;
      SelectedColumn = -1;
      SelectedPiece = Piece(-1, -1);
    } else {
      // Unselect if player chooses a piece with no prior selection
      if (SelectedColumn != -1 && SelectedColumn != -1) {
        setState(() {
          SelectedPiece.Selected = false;
        });
      }

      // Check if button position was a possible position
      if (CheckPossiblePositions(row, col)) {
        // Chess Movement

      } else {
        // Get Selection Variables
        SelectedRow = row;
        SelectedColumn = col;
        SelectedPiece = board[SelectedRow][SelectedColumn];

        // Update Widget
        setState(() {
          SelectedPiece.Selected = true;
        });
      }

      // Make sure a Piece is Selected
      if (SelectedRow != -1 ||
          SelectedColumn != -1 ||
          !SelectedPiece.IsEmpty()) {
        // Get Pieces Moves
        List PieceMoves = board[SelectedRow][SelectedColumn].CheckMoves();

        // Get all possible moves
        for (int i = 0; i < PieceMoves.length; i++) {
          // Make sure PossibleMoves exist on the board
          if (SelectedRow + PieceMoves[i][0] >= 0 &&
              SelectedRow + PieceMoves[i][0] <= 7 &&
              SelectedColumn + PieceMoves[i][1] >= 0 &&
              SelectedColumn + PieceMoves[i][1] <= 7) {
            PossibleMoves.add([
              SelectedRow + PieceMoves[i][0],
              SelectedColumn + PieceMoves[i][1]
            ]);
          }
        }

        // check for other pieces on possiblemoves
        // if opposite color then kill kill kill

        // Compare PossibleMoves to board
        TogglePossiblePositions();

        // change color of appropriate widgets
      }
    }
  }

  // Toggle Possible Positions pieces
  void TogglePossiblePositions() {
    Piece boardPiece = Piece(-1, -1);
    for (int i = 0; i < PossibleMoves.length; i++) {
      // Set boardPiece
      boardPiece = board[PossibleMoves[i][0]][PossibleMoves[i][1]];

      // Toggle
      setState(() {
        boardPiece.PossiblePosition = !boardPiece.PossiblePosition;
      });
    }
  }

  // Checks if any of the Possible Positions matches the row and column
  bool CheckPossiblePositions(int row, int column) {
    for (int i = 0; i < PossibleMoves.length; i++) {
      if (row == PossibleMoves[i][0] && column == PossibleMoves[i][1]) {
        return true;
      }
    }
    return false;
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
  bool FirstTurn = true;

  // Can Jump
  bool CanJump = false;

  // is a Possible Position
  bool PossiblePosition = false;

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

        CanJump = true;
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

  // Is empty
  bool IsEmpty() {
    if (this.Type == -1 || this.Team == -1) {
      return true;
    }

    return false;
  }

  bool ComparePieces(Piece p) {
    //not used
    if (this.Type == p.Type && this.Team == p.Team) {
      return true;
    }
    return false;
  }

  // Positions the piece can move
  List CheckMoves() {
    List Moves = [];
    switch (Type) {
      case 0: // Pawn
        if (Team == 0) {
          if (FirstTurn) {
            Moves = [
              [-1, 0], // Move Up 1
              [-2, 0], // Move Up 2
              [-1, -1], // Move Up Left 1
              [-1, 1], // Move Up Right 1
            ];
          } else {
            Moves = [
              [-1, 0], // Move Up 1
              [-1, -1], // Move Up Left 1
              [-1, 1], // Move Up Right 1
            ];
          }
        } else {
          if (FirstTurn) {
            Moves = [
              [1, 0], // Move Down 1
              [2, 0], // Move Down 2
              [1, -1], // Move Down Left 1
              [1, 1], // Move Down Right 1
            ];
          } else {
            Moves = [
              [1, 0], // Move Down
              [1, -1], // Move Down Left 1
              [1, 1], // Move Down Right 11
            ];
          }
        }
        break;

      default:
        break;
    }

    return Moves;
  }

  // Piece is Captured
  void Captured() {}
}

// Widget Row
Row chessboardRowWidget(int row, _MyHomePageState homepage) {
  int RowPosition = row;
  return Row(
    children: [
      chessboardSquareWidget(row, 0, homepage),
      chessboardSquareWidget(row, 1, homepage),
      chessboardSquareWidget(row, 2, homepage),
      chessboardSquareWidget(row, 3, homepage),
      chessboardSquareWidget(row, 4, homepage),
      chessboardSquareWidget(row, 5, homepage),
      chessboardSquareWidget(row, 6, homepage),
      chessboardSquareWidget(row, 7, homepage),
    ],
  );
}

// Widget Square
ElevatedButton chessboardSquareWidget(
    int row, int col, _MyHomePageState homepage) {
  int RowPosition = row;
  int ColumnPosition = col;
  int SquareColor = RowPosition + (ColumnPosition % 2);
  Piece piece = homepage.GetBoard()[row][col];

  // INSTEAD OF HAVING A PIECE USE A REFERENCE TO THE BOARD AND GET PIECE FROM THERE

  return ElevatedButton(
    onPressed: () {
      homepage.Selected(RowPosition, ColumnPosition);
      //print("RowPosition: $RowPosition ColumnPosition: $ColumnPosition Selected: ${piece.Selected}");
    },
    style: ButtonStyle(
      fixedSize: MaterialStateProperty.all<Size>(Size(100, 100)),
      backgroundColor: piece.PossiblePosition
          ? MaterialStateProperty.all<Color>(Colors.green.shade500)
          : piece.Selected
              ? MaterialStateProperty.all<Color>(Colors.green.shade100)
              : SquareColor % 2 == 0
                  ? MaterialStateProperty.all<Color>(Colors.orange.shade100)
                  : MaterialStateProperty.all<Color>(Colors.brown.shade900),
    ),
    child: piece.ChessPiece,
  );
  ;
}
