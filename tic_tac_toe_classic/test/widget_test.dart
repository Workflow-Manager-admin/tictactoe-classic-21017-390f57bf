import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_classic/main.dart';

void main() {
  testWidgets('TicTacToe Classic board and reset button appear', (WidgetTester tester) async {
    // Build the TicTacToeApp and trigger a frame.
    await tester.pumpWidget(const TicTacToeApp());

    // There should be a status message containing "Turn: Player".
    expect(find.textContaining('Turn: Player'), findsOneWidget);

    // The Reset button should be present.
    expect(find.text('Reset'), findsOneWidget);

    // There should be exactly 9 cells (GestureDetectors for taps).
    final cellFinder = find.byType(GestureDetector);
    expect(cellFinder, findsNWidgets(9));
  });

  testWidgets('Players can take turns and board updates', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Tap the top-left cell.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // After the first move, there should be one 'X' and no 'O'
    expect(find.text('X'), findsOneWidget);
    expect(find.text('O'), findsNothing);

    // Tap the next available cell (second GestureDetector)
    await tester.tap(find.byType(GestureDetector).at(1));
    await tester.pump();

    // Now there should be one 'X' and one 'O'
    expect(find.text('X'), findsOneWidget);
    expect(find.text('O'), findsOneWidget);
  });

  testWidgets('Reset button clears the board', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Play some moves
    await tester.tap(find.byType(GestureDetector).first); // X
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).at(1)); // O
    await tester.pump();

    // Press reset
    await tester.tap(find.text('Reset'));
    await tester.pump();

    // Board must be empty
    expect(find.text('X'), findsNothing);
    expect(find.text('O'), findsNothing);

    // Status message should indicate new game start
    expect(find.textContaining('Turn: Player'), findsOneWidget);
  });
}
