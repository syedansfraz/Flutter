import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: OurGame(),
  ));
}

class OurGame extends StatefulWidget {
  @override
  _OurGameState createState() => _OurGameState();
}

class _OurGameState extends State<OurGame> {
  List<String> board = List.filled(9, ""); // 3x3 board
  String winner = "";

  // Winning combinations
  final List<List<int>> winningStates = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6],
  ];

  // Handle a move
  void handleMove(int index) {
    if (board[index] == "" && winner == "") {
      setState(() {
        board[index] = "P"; // Player's move
        checkWinner();
        if (winner == "") computerMove();
      });
    }
  }

  // Computer's random move
  void computerMove() {
    int randomIndex;
    do {
      randomIndex = Random().nextInt(9);
    } while (board[randomIndex] != "");
    setState(() {
      board[randomIndex] = "C"; // Computer's move
      checkWinner();
    });
  }

  // Check for winner or draw
  void checkWinner() {
    for (var ws in winningStates) {
      if (board[ws[0]] != "" &&
          board[ws[0]] == board[ws[1]] &&
          board[ws[0]] == board[ws[2]]) {
        winner = board[ws[0]] == "P" ? "Player Wins!" : "Computer Wins!";
        return;
      }
    }
    if (!board.contains("") && winner == "") {
      winner = "It's a Draw!";
    }
  }

  // Reset game
  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      winner = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TikTok Game")),
      body: Column(
        children: [
          // Game board
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => handleMove(index),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    color: board[index] == "P"
                        ? Colors.orange
                        : board[index] == "C"
                            ? Colors.green
                            : Colors.grey[300],
                  ),
                );
              },
            ),
          ),
          // Winner display
          Text(
            winner,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Reset button
          ElevatedButton(
            onPressed: resetGame,
            child: Text("Reset Game"),
          ),
        ],
      ),
    );
  }
}
