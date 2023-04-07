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
  int Turn = 0; // 0 White, 1 Black;

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

  // En Passant
  List EnPassantWhitePawn = [];
  List EnPassantBlackPawn = [];

  /// Possible Moves for Selected Piece
  List PossibleMoves = [];

  // Promotion / Widget Visibility
  bool CanPromote = false;

  // King Danger Zones
  List WhiteDangerZones = [];
  List BlackDangerZones = [];

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

  // Promote
  void SetCanPromote(bool b) {
    setState(() {
      CanPromote = b;
    });
  }
  // Check for king check

  // Check for win

  // Switch Turn

  void ToggleTurn() {
    setState(() {
      Turn = Turn == 0 ? 1 : 0;
    });

    if (Turn == 1) {
      if (EnPassantBlackPawn.length > 0) {
        EnPassantBlackPawn[0].EnPassant = false;
        EnPassantBlackPawn.removeAt(0);
      }
    } else {
      if (EnPassantWhitePawn.length > 0) {
        EnPassantWhitePawn[0].EnPassant = false;
        EnPassantWhitePawn.removeAt(0);
      }
    }
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
        board[SelectedRow][SelectedColumn] = Piece(-1, -1);

        // Delete from teams
        if (!board[row][col].IsEmpty()) {
          if (board[row][col].Team == 0) {
            if (Piece.WhiteTeam.contains(board[row][col])) {
              Piece.WhiteTeam.remove(board[row][col]);
              print("White Team Length: ${Piece.WhiteTeam.length} ");
            }
          } else if (board[row][col].Team == 1) {
            if (Piece.BlackTeam.contains(board[row][col])) {
              Piece.BlackTeam.remove(board[row][col]);

              print("Black Team Length: ${Piece.BlackTeam.length} ");
            }
          }
        }
        // Move Piece
        board[row][col] = SelectedPiece;

        // Do Piece Specific things
        switch (SelectedPiece.Type) {
          case 0: // Pawn
            // First Turn
            if (SelectedPiece.FirstTurn) {
              SelectedPiece.FirstTurn = false;
              SelectedPiece.EnPassant = true;
              if (SelectedPiece.Team == 0) {
                EnPassantWhitePawn.add(SelectedPiece);
              } else if (SelectedPiece.Team == 1) {
                EnPassantBlackPawn.add(SelectedPiece);
              }
            }

            // En Passant Kill
            if (SelectedPiece.Team == 0) {
              if (board[row + 1][col].EnPassant) {
                board[row + 1][col] = Piece(-1, -1);
              }
            } else if (SelectedPiece.Team == 1) {
              if (board[row - 1][col].EnPassant) {
                board[row - 1][col] = Piece(-1, -1);
              }
            }

            // Promotion
            if ((SelectedPiece.Team == 0 && row == 0) ||
                (SelectedPiece.Team == 1 && row == 7)) {
              SetCanPromote(true);
              SelectedRow = row;
              SelectedColumn = col;
            }
            break;
          case 3: // Rook
            if (SelectedPiece.FirstTurn) {
              SelectedPiece.FirstTurn = false;
            }
            break;

          case 5: // King
            if (SelectedPiece.FirstTurn) {
              SelectedPiece.FirstTurn = false;

              // Castling
              if (SelectedPiece.Team == 0) {
                if (row == 7 && col == 2) {
                  if (board[7][0].Type == 3 && board[7][0].FirstTurn) {
                    board[7][3] = board[7][0];
                    board[7][0] = Piece(-1, -1);
                    board[7][3].FirstTurn = false;
                  }
                } else if (row == 7 && col == 6) {
                  if (board[7][7].Type == 3 && board[7][7].FirstTurn) {
                    board[7][5] = board[7][7];
                    board[7][7] = Piece(-1, -1);
                    board[7][5].FirstTurn = false;
                  }
                }
              } else if (SelectedPiece.Team == 1) {
                if (row == 0 && col == 2) {
                  if (board[0][0].Type == 3 && board[0][0].FirstTurn) {
                    board[0][3] = board[0][0];
                    board[0][0] = Piece(-1, -1);
                    board[0][3].FirstTurn = false;
                  }
                } else if (row == 0 && col == 6) {
                  if (board[0][7].Type == 3 && board[0][7].FirstTurn) {
                    board[0][5] = board[0][7];
                    board[0][7] = Piece(-1, -1);
                    board[0][5].FirstTurn = false;
                  }
                }
              }
            }
            break;

          default:
            break;
        }

        // Empty Possible Positions
        PossibleMoves.clear();

        // Opposing player in check?

        // Toggle Turn
        if (!CanPromote) {
          // Empty Selections
          SetSelectedPiece(-1, -1, Piece(-1, -1));
          ToggleTurn();
        }
      } else {
        // Toggle Possible Positions
        TogglePossiblePositions();

        // Empty Possible Positions
        PossibleMoves.clear();

        // Get Selection Variables
        if (!CanPromote) {
          SelectedRow = row;
          SelectedColumn = col;
          SelectedPiece = board[SelectedRow][SelectedColumn];
        }

        if (SelectedRow != -1 &&
            SelectedColumn != -1 &&
            board[SelectedRow][SelectedColumn].Team == Turn &&
            !CanPromote) {
          // Update Widget
          setState(() {
            SelectedPiece.Selected = true;
          });

          PossibleMoves = FindPiecePossibleMoves(SelectedPiece);

          // check for other pieces on possiblemoves
          // if opposite color then kill kill kill

          // Compare PossibleMoves to board
          TogglePossiblePositions();

          // change color of appropriate widgets
        }
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

  // Find Possible Moves for a team
  List FindDangerZone(List Team) {
    List dangerZone = [];
    List possibleMoves = [];
    for (int i = 0; i < Team.length; i++) {
      possibleMoves = FindPiecePossibleMoves(Team[i]);

      if (possibleMoves.isNotEmpty) {
        for (int j = 0; j < possibleMoves.length; j++) {
          for (int k = 0; k < possibleMoves[j]; k++) {
            if (!dangerZone.contains(possibleMoves[j][k])) {
              dangerZone.add(possibleMoves[j][k]);
            }
          }
        }
      }
    }

    return dangerZone;
  }

  // Find the possible moves a piece can do
  List FindPiecePossibleMoves(Piece p) {
    List possibleMoves = [];
    // Get Pieces Moves
    List PieceMoves = p.CheckMoves();

    // Piece Specific Moves
    switch (p.Type) {
      case 0: // Pawn (Kill Move)
        // White
        if (p.Team == 0) {
          // If there is a black piece to diagonally right 1 OR there is an enemy pawn to the right that has EnPassant
          if ((p.Row - 1 >= 0 &&
                  p.Column + 1 < 8 &&
                  !board[p.Row - 1][p.Column + 1].IsEmpty() &&
                  board[p.Row - 1][p.Column + 1].Team == 1) ||
              ((p.Column + 1 < 8 &&
                  board[p.Row][p.Column + 1].Team == 1 &&
                  board[p.Row][p.Column + 1].Type == 0 &&
                  board[p.Row][p.Column + 1].EnPassant &&
                  board[p.Row - 1][p.Column + 1].IsEmpty()))) {
            PieceMoves.add([
              [-1, 1]
            ]); // Move Up Right 1
            //print("EnPassant Possible");
          }
          // (enemy pawn is to right, -1 1 is empty)
          // If there is a black piece to diagonally left 1 OR there is an enemy pawn to the left that has EnPassant
          if ((p.Row - 1 >= 0 &&
                  p.Column - 1 >= 0 &&
                  !board[p.Row - 1][p.Column - 1].IsEmpty() &&
                  board[p.Row - 1][p.Column - 1].Team == 1) ||
              ((p.Column - 1 >= 0 &&
                  board[p.Row][p.Column - 1].Team == 1 &&
                  board[p.Row][p.Column - 1].Type == 0 &&
                  board[p.Row][p.Column - 1].EnPassant &&
                  board[p.Row - 1][p.Column - 1].IsEmpty()))) {
            PieceMoves.add([
              [-1, -1]
            ]); // Move Up Left 1
          }
        } else if (p.Team == 1) {
          // Black
          // If there is a white piece to diagonally right OR there is an enemy pawn to the right that has EnPassant
          if ((p.Row + 1 < 8 &&
                  p.Column + 1 < 8 &&
                  !board[p.Row + 1][p.Column + 1].IsEmpty() &&
                  board[p.Row + 1][p.Column + 1].Team == 0) ||
              ((p.Column + 1 < 8 &&
                  board[p.Row][p.Column + 1].Team == 0 &&
                  board[p.Row][p.Column + 1].Type == 0 &&
                  board[p.Row][p.Column + 1].EnPassant &&
                  board[p.Row - 1][p.Column + 1].IsEmpty()))) {
            PieceMoves.add([
              [1, 1]
            ]); // Move Down Right 1
          }

          // If there is a white piece to diagonally left OR there is an enemy pawn to the left that has EnPassant
          if ((p.Row + 1 < 8 &&
                  p.Column - 1 >= 0 &&
                  !board[p.Row + 1][p.Column - 1].IsEmpty() &&
                  board[p.Row + 1][p.Column - 1].Team == 0) ||
              ((p.Column - 1 >= 0 &&
                  board[p.Row][p.Column - 1].Team == 0 &&
                  board[p.Row][p.Column - 1].Type == 0 &&
                  board[p.Row][p.Column - 1].EnPassant &&
                  board[p.Row - 1][p.Column - 1].IsEmpty()))) {
            PieceMoves.add([
              [1, -1]
            ]); // Move Down Left 1
          }
        }
        break;

      case 5: // King (Castling)
        if (p.FirstTurn) {
          if (p.Team == 0) {
            if (board[7][0].Type == 3 &&
                board[7][0].FirstTurn &&
                board[7][1].IsEmpty() &&
                board[7][2].IsEmpty() &&
                board[7][3].IsEmpty()) {
              PieceMoves.add([
                [0, -2]
              ]);
            }

            if (board[7][7].Type == 3 &&
                board[7][7].FirstTurn &&
                board[7][5].IsEmpty() &&
                board[7][6].IsEmpty()) {
              PieceMoves.add([
                [0, 2]
              ]);
            }
          } else if (p.Team == 1) {
            if (board[0][0].Type == 3 &&
                board[0][0].FirstTurn &&
                board[0][1].IsEmpty() &&
                board[0][2].IsEmpty() &&
                board[0][3].IsEmpty()) {
              PieceMoves.add([
                [0, -2]
              ]);
            }
            if (board[0][7].Type == 3 &&
                board[0][7].FirstTurn &&
                board[0][5].IsEmpty() &&
                board[0][6].IsEmpty()) {
              PieceMoves.add([
                [0, 2]
              ]);
            }
          }
        }
        break;

      default:
        break;
    }

    // Get all possible moves
    bool keepGoing = true;

    //print("SelectedPiece Team: ${SelectedPiece.Team}");
    //print("SelectedPiece Type: ${SelectedPiece.Type}");
    //print("------");

    // Find PossibleMoves
    for (int i = 0; i < PieceMoves.length; i++) {
      keepGoing = true;
      for (int j = 0; j < PieceMoves[i].length; j++) {
        // Make sure PossibleMoves exist on the board
        if (p.Row + PieceMoves[i][j][0] >= 0 &&
            p.Row + PieceMoves[i][j][0] <= 7 &&
            p.Column + PieceMoves[i][j][1] >= 0 &&
            p.Column + PieceMoves[i][j][1] <= 7) {
          // If Current Move isn't moving in the same direction as LastMove OR if it's the same

          //print(" Current Move: ${PieceMoves[i][j]}");

          //keepGoing = true;
          //print("   keepingGoing Condition");
          //print("  keepGoing: $keepGoing");

          if (keepGoing) {
            int r = (p.Row + PieceMoves[i][j][0]).toInt();
            int c = (p.Column + PieceMoves[i][j][1]).toInt();
            // Check if Piece team is the same as SelectedPiece
            if (board[r][c].Team == p.Team) {
              if (!p.CanJump) {
                keepGoing = false;
              }
              //print("   1: $r , $c");
            } else {
              // Check if Piece is empty
              if (board[r][c].IsEmpty()) {
                possibleMoves.add([
                  p.Row + PieceMoves[i][j][0],
                  p.Column + PieceMoves[i][j][1]
                ]);
                //print("   2: $r , $c");

                // Check if Piece is Enemy
              } else {
                // If piece is not a Pawn
                if ((p.Type != 0) ||
                    // OR if Piece IS a pawn AND current move is [-1, 0] or [1, 0]

                    (p.Type == 0 &&
                        ((PieceMoves[i][j][0] != -1 ||
                                PieceMoves[i][j][0] != 1) &&
                            PieceMoves[i][j][1] != 0))) {
                  possibleMoves.add([
                    p.Row + PieceMoves[i][j][0],
                    p.Column + PieceMoves[i][j][1]
                  ]);
                }
                if (!p.CanJump) {
                  keepGoing = false;
                }
                //print("   3: $r , $c");
              }
            }
          }
        }
      }
    }

    return possibleMoves;
  }

  // App
  @override
  Widget build(BuildContext context) {
    Intialize();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        GetChessboardWidget(),
        promotionWidget(CanPromote, Turn, this),
      ]),
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

  // First Turn
  bool FirstTurn = true;

  // Pawn En Passant
  bool EnPassant = false;

  // Can Jump
  bool CanJump = false;

  // is a Possible Position
  bool PossiblePosition = false;

  // Row Position
  int Row = -1;

  // Column Position
  int Column = -1;

  // Teams
  static List WhiteTeam = [];
  static List BlackTeam = [];

  /// Constructors
  Piece(int ty, int te) {
    Type = ty;
    Team = te;

    // Set Piece Icon and Points
    switch (Type) {
      case (0): // Pawn
        Points = 1;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(
            Icons.perm_identity,
            color: Team % 2 == 0 ? Colors.black : Colors.white,
          ),
        );
        break;

      case (1): // Knight
        Points = 3;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(
            Icons.snowshoeing,
            color: Team % 2 == 0 ? Colors.black : Colors.white,
          ),
        );

        CanJump = true;
        break;

      case (2): // Bishop
        Points = 3;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(
            Icons.skip_next,
            color: Team % 2 == 0 ? Colors.black : Colors.white,
          ),
        );
        break;

      case (3): // Rook
        Points = 5;
        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(
            Icons.masks,
            color: Team % 2 == 0 ? Colors.black : Colors.white,
          ),
        );
        break;

      case (4): // Queen
        Points = 9;
        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(
            Icons.female,
            color: Team % 2 == 0 ? Colors.black : Colors.white,
          ),
        );
        break;

      case (5): // King
        Points = 999;

        ChessPiece = Container(
          color: Team % 2 == 0 ? Colors.white : Colors.black,
          child: Icon(
            Icons.male,
            color: Team % 2 == 0 ? Colors.black : Colors.white,
          ),
        );
        break;

      default:
        ChessPiece = Container();
        break;
    }

    // Add to Team
    if (Team == 0) {
      WhiteTeam.add(this);
      print("White Team Length: ${WhiteTeam.length} ");
    } else if (Team == 1) {
      BlackTeam.add(this);
      print("Black Team Length: ${BlackTeam.length} ");
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
      case 1: // Knight
        Moves = [
          [
            // 2 Up 1 Left
            [-2, -1],
            // 2 Up 1 Right
            [-2, 1],
            // 1 Up 2 Left
            [-1, -2],
            // 1 Up 2 Right
            [-1, 2],
            // 2 Down 1 Left
            [2, -1],
            // 2 Down 1 Right
            [2, 1],
            // 1 Down 2 Left
            [1, -2],
            // 1 Down 2 Right
            [1, 2],
          ],
        ];
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
      case 4: // Queen
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

      case 5: // King
        Moves = [
          // Up
          [
            [-1, 0]
          ],
          // Right
          [
            [0, 1]
          ],
          // Left
          [
            [0, -1]
          ],
          // Down
          [
            [1, 0]
          ],
          // Up Right
          [
            [-1, 1]
          ],
          // Down Right
          [
            [1, 1]
          ],
          // Down Left
          [
            [1, -1]
          ],
          // Up Left
          [
            [-1, -1]
          ],
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
  piece.Row = RowPosition;
  piece.Column = ColumnPosition;

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

// Promote Widget
Visibility promotionWidget(
    bool IsVisible, int Turn, _MyHomePageState homepage) {
  ButtonStyle promoteButtonStyle = ButtonStyle(
      backgroundColor: Turn == 0
          ? MaterialStateProperty.all<Color>(Colors.white)
          : MaterialStateProperty.all<Color>(Colors.black));

  void Promote(int type) {
    homepage.board[homepage.SelectedRow][homepage.SelectedColumn] =
        Piece(type, homepage.Turn);
    homepage.SetSelectedPiece(-1, -1, Piece(-1, -1));
    homepage.SetCanPromote(false);
    homepage.ToggleTurn();
  }

  return Visibility(
    visible: IsVisible,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Queen
        ElevatedButton(
          onPressed: () {
            Promote(4);
          },
          child: Text("Queen"),
          style: promoteButtonStyle,
        ),
        ElevatedButton(
          onPressed: () {
            Promote(3);
          },
          child: Text("Rook"),
          style: promoteButtonStyle,
        ),
        ElevatedButton(
          onPressed: () {
            Promote(2);
          },
          child: Text("Bishop"),
          style: promoteButtonStyle,
        ),
        ElevatedButton(
          onPressed: () {
            Promote(1);
          },
          child: Text("Knight"),
          style: promoteButtonStyle,
        ),
      ],
    ),
  );
}
