import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

/// The main app widget.
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe Classic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFFFFFF),
          secondary: const Color(0xFF222222),
          surface: const Color(0xFFFFFFFF),
          onPrimary: const Color(0xFF222222),
          onSecondary: const Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        useMaterial3: true,
      ),
      home: const TicTacToeContainer(),
    );
  }
}

/// The main widget for the TicTacToe game.
class TicTacToeContainer extends StatefulWidget {
  const TicTacToeContainer({super.key});

  // PUBLIC_INTERFACE
  @override
  State<TicTacToeContainer> createState() => _TicTacToeContainerState();
}

class _TicTacToeContainerState extends State<TicTacToeContainer> {
  // The game board state: 3x3 matrix filled with '', 'X' or 'O'.
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''), growable: false);
  // True if it's X's turn, false if O's turn.
  bool _xTurn = true;
  // Stores the winner ('X', 'O', or 'Draw').
  String? _winner;
  // Stores game over state for disabling interaction after win/draw.
  bool _gameOver = false;

  // PUBLIC_INTERFACE
  /// Resets the board to start a new game.
  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''), growable: false);
      _xTurn = true;
      _winner = null;
      _gameOver = false;
    });
  }

  // PUBLIC_INTERFACE
  /// Handles a tap on the cell at [row], [col].
  void _handleCellTap(int row, int col) {
    if (_board[row][col] != '' || _gameOver) return;
    setState(() {
      _board[row][col] = _xTurn ? 'X' : 'O';
      _winner = _detectWinner();
      if (_winner != null) {
        _gameOver = true;
      } else {
        // Switch turn
        _xTurn = !_xTurn;
      }
    });
  }

  // PUBLIC_INTERFACE
  /// Returns 'X', 'O', 'Draw', or null for ongoing game.
  String? _detectWinner() {
    // Check rows and columns
    for (int i = 0; i < 3; ++i) {
      // Row
      if (_board[i][0] != '' && _board[i][0] == _board[i][1] && _board[i][1] == _board[i][2]) {
        return _board[i][0];
      }
      // Column
      if (_board[0][i] != '' && _board[0][i] == _board[1][i] && _board[1][i] == _board[2][i]) {
        return _board[0][i];
      }
    }
    // Diagonals
    if (_board[0][0] != '' && _board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) {
      return _board[0][0];
    }
    if (_board[0][2] != '' && _board[0][2] == _board[1][1] && _board[1][1] == _board[2][0]) {
      return _board[0][2];
    }
    // Draw: if no empty spaces remain
    if (_board.expand((row) => row).every((cell) => cell != '')) {
      return 'Draw';
    }
    // No winner yet
    return null;
  }

  // PUBLIC_INTERFACE
  /// Returns the status message according to current game state.
  String _getStatusMessage() {
    if (_winner == 'X') return 'Player X wins! 🎉';
    if (_winner == 'O') return 'Player O wins! 🎉';
    if (_winner == 'Draw') return "It's a draw! 🤝";
    return 'Turn: Player ${_xTurn ? 'X' : 'O'}';
  }

  // Colors
  static const Color backgroundColor = Colors.white;
  static const Color gridColor = Color(0xFF222222);
  static const Color accentColor = Color(0xFF4CAF50);

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 580),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status message
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    _getStatusMessage(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: gridColor,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // 3x3 grid
                _buildBoard(),
                // Reset button
                const SizedBox(height: 36),
                SizedBox(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _resetGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 2,
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the TicTacToe 3x3 board.
  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: gridColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: List.generate(3, (row) {
            return Expanded(
              child: Row(
                children: List.generate(3, (col) {
                  return _buildCell(row, col);
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Builds a cell at [row],[col] in the board.
  Widget _buildCell(int row, int col) {
    final String value = _board[row][col];
    final bool highlight = _winner != null && _isWinningCell(row, col);

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleCellTap(row, col),
        child: Container(
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: highlight ? accentColor.withAlpha((0.25 * 255).toInt()) : backgroundColor,
            border: Border.all(
              color: gridColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: value == ''
                  ? const SizedBox.shrink()
                  : Text(
                      value,
                      key: ValueKey<String>(value + row.toString() + col.toString()),
                      style: TextStyle(
                        color: value == 'X' ? gridColor : accentColor,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns true if [row],[col] is part of the winning line.
  bool _isWinningCell(int row, int col) {
    if (_winner == null || _winner == 'Draw') return false;

    // Row win
    if (_board[row][0] == _winner &&
        _board[row][1] == _winner &&
        _board[row][2] == _winner) {
      return true;
    }
    // Col win
    if (_board[0][col] == _winner &&
        _board[1][col] == _winner &&
        _board[2][col] == _winner) {
      return true;
    }
    // Main diag win
    if (row == col &&
        _board[0][0] == _winner &&
        _board[1][1] == _winner &&
        _board[2][2] == _winner) {
      return true;
    }
    // Anti diag win
    if (row + col == 2 &&
        _board[0][2] == _winner &&
        _board[1][1] == _winner &&
        _board[2][0] == _winner) {
      return true;
    }
    return false;
  }
}
