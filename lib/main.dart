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

    // Unselect if player chose the same piece as last time
    if (row == SelectedRow && col == SelectedColumn) {
      setState(() {
        SelectedPiece.Selected = false;
      });

      // Empty Selection
      SetSelectedPiece(-1, -1, Piece(-1, -1));

      // Toggle Possible Positions
      TogglePossiblePositions();

      // Empty Possible Positions
      PossibleMoves.clear();
    } else {
      // Unselect previous
      if (row != -1 && col != -1) {
        setState(() {
          SelectedPiece.Selected = false;
        });
      }

      // Check if button position was a possible position
      if (CheckPossiblePositions(row, col)) {
        // Toggle Possible Positions
        TogglePossiblePositions();

        // Empty Original Position
        board[SelectedRow][SelectedColumn] = Piece(-1, 1);

        // Move Piece
        board[row][col] = SelectedPiece;

        // Do Piece Specific things
        switch (SelectedPiece.Type) {
          case 0: // Pawn
            // First Turn
            SelectedPiece.FirstTurn = false;
            break;

          default:
            break;
        }

        // Empty Selections
        SetSelectedPiece(-1, -1, Piece(-1, -1));

        // Empty Possible Positions
        PossibleMoves.clear();

        // Opposing player in check?

        // Toggle Turn
        ToggleTurn();
      } else {
        // Toggle Possible Positions
        TogglePossiblePositions();

        // Empty Possible Positions
        PossibleMoves.clear();

        // Get Selection Variables
        SelectedRow = row;
        SelectedColumn = col;
        SelectedPiece = board[SelectedRow][SelectedColumn];

        // Update Widget
        setState(() {
          SelectedPiece.Selected = true;
        });

        // Get Pieces Moves
        List PieceMoves = SelectedPiece.CheckMoves();

        /* Pawn Specific Kill Move
        if (SelectedPiece.Type == 0) {
          // White
          if (SelectedPiece.Team == 0) {
            // If there is a black piece to diagonally right 1
            if (SelectedRow - 1 >= 0 &&
                SelectedColumn + 1 < 8 &&
                !board[SelectedRow - 1][SelectedColumn + 1].IsEmpty() &&
                board[SelectedRow - 1][SelectedColumn + 1].Team == 1) {
              PieceMoves.add([-1, 1]); // Move Up Right 1
            }

            // If there is a black piece to diagonally left 1
            if (SelectedRow - 1 >= 0 &&
                SelectedColumn - 1 >= 0 &&
                !board[SelectedRow - 1][SelectedColumn - 1].IsEmpty() &&
                board[SelectedRow - 1][SelectedColumn - 1].Team == 1) {
              PieceMoves.add([-1, -1]); // Move Up Left 1
            }
          } else if (SelectedPiece.Team == 1) {
            // Black
            // If there is a white piece to diagonally right
            if (SelectedRow + 1 < 8 &&
                SelectedColumn + 1 < 8 &&
                !board[SelectedRow + 1][SelectedColumn + 1].IsEmpty() &&
                board[SelectedRow + 1][SelectedColumn + 1].Team == 0) {
              PieceMoves.add([1, 1]); // Move Down Right 1
            }

            // If there is a white piece to diagonally left
            if (SelectedRow + 1 < 8 &&
                SelectedColumn - 1 >= 0 &&
                !board[SelectedRow + 1][SelectedColumn - 1].IsEmpty() &&
                board[SelectedRow + 1][SelectedColumn - 1].Team == 0) {
              PieceMoves.add([1, -1]); // Move Down Left 1
            }
          }
        }
        */

        // Get all possible moves
        List LastMove = PieceMoves[0];
        bool keepGoing = true;

        print("------");

        // Find PossibleMoves
        for (int i = 0; i < PieceMoves.length; i++) {
          keepGoing = true;
          for (int j = 0; j < PieceMoves[i].length; j++) {
            // Make sure PossibleMoves exist on the board
            if (SelectedRow + PieceMoves[i][j][0] >= 0 &&
                SelectedRow + PieceMoves[i][j][0] <= 7 &&
                SelectedColumn + PieceMoves[i][j][1] >= 0 &&
                SelectedColumn + PieceMoves[i][j][1] <= 7) {
              // If Current Move isn't moving in the same direction as LastMove OR if it's the same

              print(" Current Move: ${PieceMoves[i][j]}");
              print("  Last Move: $LastMove");

              //keepGoing = true;
              //print("   keepingGoing Condition");
              print("    keepGoing: $keepGoing");

              if (keepGoing) {
                int r = (SelectedRow + PieceMoves[i][j][0]).toInt();
                int c = (SelectedColumn + PieceMoves[i][j][1]).toInt();
                // Check if Piece team is the same as SelectedPiece
                if (board[r][c].Team == SelectedPiece.Team) {
                  keepGoing = false;
                  print("     1: $r , $c");
                } else {
                  // Check if Piece is empty
                  if (board[r][c].IsEmpty()) {
                    PossibleMoves.add([
                      SelectedRow + PieceMoves[i][j][0],
                      SelectedColumn + PieceMoves[i][j][1]
                    ]);
                    print("     2: $r , $c");

                    // Check if Piece is Enemy
                  } else {
                    PossibleMoves.add([
                      SelectedRow + PieceMoves[i][j][0],
                      SelectedColumn + PieceMoves[i][j][1]
                    ]);

                    keepGoing = false;
                    print("     3: $r , $c");
                  }
                }
              }

              LastMove = PieceMoves[i][j];
            }
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
      // Check for piece specific things (ie pawn kills, en passant)
      if (row == PossibleMoves[i][0] && column == PossibleMoves[i][1]) {
        return true;
      }
    }
    return false;
  }

  // Sets Selected Piece, Column, and Row
  void SetSelectedPiece(int row, int column, Piece p) {
    SelectedRow = row;
    SelectedColumn = column;
    SelectedPiece = p;
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

  // Moves all must be ordered in Up, Right, Down, Left, UpRight, DownRight, DownLeft, UpLeft
  List CheckMoves() {
    List Moves = [];
    switch (Type) {
      case 0: // Pawn
        if (Team == 0) {
          if (FirstTurn) {
            Moves = [
              // Up
              [
                [-1, 0],
                [-2, 0],
              ],
            ];
          } else {
            Moves = [
              // Up
              [
                [-1, 0],
              ]
            ];
          }
        } else {
          if (FirstTurn) {
            Moves = [
              // Down
              [
                [1, 0],
                [2, 0],
              ]
            ];
          } else {
            Moves = [
              // Down
              [
                [1, 0], // Move Down
              ]
            ];
          }
        }
        break;

      case 2: // Bishop
        Moves = [
          // Up
          [],

          // Right
          [],

          // Down
          [],

          // Left
          [],

          // Up Right
          [
            [-1, 1],
            [-2, 2],
            [-3, 3],
            [-4, 4],
            [-5, 5],
            [-6, 6],
            [-7, 7],
          ],

          // Down Right
          [
            [1, 1],
            [2, 2],
            [3, 3],
            [4, 4],
            [5, 5],
            [6, 6],
            [7, 7],
          ],

          // Down Left
          [
            [1, -1],
            [2, -2],
            [3, -3],
            [4, -4],
            [5, -5],
            [6, -6],
            [7, -7],
          ],

          // Up Left
          [
            [-1, -1],
            [-2, -2],
            [-3, -3],
            [-4, -4],
            [-5, -5],
            [-6, -6],
            [-7, -7],
          ],
        ];
        break;
      case 3: // Rook
        Moves = [
          // Up
          [
            [-1, 0],
            [-2, 0],
            [-3, 0],
            [-4, 0],
            [-5, 0],
            [-6, 0],
            [-7, 0],
          ],

          // Right
          [
            [0, 1],
            [0, 2],
            [0, 3],
            [0, 4],
            [0, 5],
            [0, 6],
            [0, 7],
          ],

          // Down
          [
            [1, 0],
            [2, 0],
            [3, 0],
            [4, 0],
            [5, 0],
            [6, 0],
            [7, 0],
          ],

          // Left
          [
            [0, -1],
            [0, -2],
            [0, -3],
            [0, -4],
            [0, -5],
            [0, -6],
            [0, -7],
          ],

          // Up Right
          [],

          // Down Right
          [],

          // Down Left
          [],

          // Down Left
          [],
        ];
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
  int row,
  int col,
  _MyHomePageState homepage,
) {
  int RowPosition = row;
  int ColumnPosition = col;
  int SquareColor = RowPosition + (ColumnPosition % 2);
  Piece piece = homepage.GetBoard()[row][col];

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
}
