// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/game.dart';
import 'package:flutter_application_1/objects/game_state.dart';
import 'package:flutter_application_1/widgets/car.dart';
import 'package:flutter_application_1/widgets/pointCounter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'dart:math' as math;


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Points should increase when started',
      (WidgetTester tester) async {
    // Build the point counter
    PointCounter pointCounter = PointCounter();
    // Start the point counter
    pointCounter.start();
    // Pump the initial state
    await tester.pumpAndSettle();
    // Count for 3 seconds
    await tester.pump(const Duration(seconds: 3));
    // Get 3 points
    expect(pointCounter.getPoints(), equals(3));
    // Stop timer once done
    pointCounter.stop();
  });

  testWidgets('Tilting left moves car to the left when landscape',
    (WidgetTester tester) async {
    GameState gameState = GameState(30, 50, (){});
    gameState.cancelTimer();
    expect(gameState.carPos.x, 25);
      gameState.moveCar(-1);
      expect(gameState.carPos.x, 24);
    });

    testWidgets('Tilting right moves car to the right when landscape',
    (WidgetTester tester) async {
    GameState gameState = GameState(30, 50, (){});
    gameState.cancelTimer();
    expect(gameState.carPos.x, 25);
      gameState.moveCar(1);
      expect(gameState.carPos.x, 26);
    });
}
