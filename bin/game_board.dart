import 'dart:io';

void main() {
  List<String> board = List.generate(9, (index) => '${index + 1}');
  int playerXScore = 0;
  int playerOScore = 0;
  bool playAgain = true;

  print('Welcome to Tic-Tac-Toe!');
  drawBoard(board);

  do {
    bool? winner = handleRound(board, playerXScore, playerOScore);

    if (winner != null) {
      if (winner) {
        playerXScore++;
      } else {
        playerOScore++;
      }
    }

    print('Score - X: $playerXScore | O: $playerOScore');
    playAgain = askPlayAgain();

    if (playAgain) {
      board = resetBoard();
      drawBoard(board);
    }
  } while (playAgain);

  print('\nFinal Score:');
  print('Player X: $playerXScore');
  print('Player O: $playerOScore');
}

bool? handleRound(List<String> board, int playerXScore, int playerOScore) {
  int counter = 0;
  int boardFilled = 0;

  while (boardFilled < 9) {
    String currentPlayer = getPlayerSymbol(counter);
    int move = getPlayerMove(currentPlayer);

    if (makeMove(board, move, currentPlayer)) {
      boardFilled++;
      drawBoard(board);

      if (checkWinner(board)) {
        print("Player $currentPlayer wins!");
        return currentPlayer == 'X';
      }

      if (boardFilled == 9) {
        print("It's a draw!");
        return null;
      }

      counter++;
    }
  }

  return null;
}

String getPlayerSymbol(int counter) {
  return counter % 2 == 0 ? 'X' : 'O';
}

int getPlayerMove(String currentPlayer) {
  while (true) {
    print('Player $currentPlayer, enter your move (1-9): ');
    try {
      int move = int.parse(stdin.readLineSync()!);
      if (move >= 1 && move <= 9) {
        return move;
      } else {
        print('Invalid input. Please enter a number between 1 and 9.');
      }
    } catch (_) {
      print('Invalid input. Please enter a number between 1 and 9.');
    }
  }
}

bool makeMove(List<String> board, int move, String symbol) {
  if (board[move - 1] != 'X' && board[move - 1] != 'O') {
    board[move - 1] = symbol;
    return true;
  } else {
    print('Invalid move. Cell is already occupied. Try again.');
    return false;
  }
}

bool askPlayAgain() {
  print('Do you want to play again? (y/n): ');
  String? input = stdin.readLineSync();
  return input != null && input.toLowerCase() == 'y';
}

List<String> resetBoard() {
  return List.generate(9, (index) => '${index + 1}');
}

void drawBoard(List<String> board) {
  print('\nCurrent Board:');
  for (int i = 0; i < 3; i++) {
    String row = '';
    for (int j = 0; j < 3; j++) {
      int index = i * 3 + j;
      row += ' ${board[index]} ';
      if (j < 2) row += '|';
    }
    print(row);
    if (i < 2) {
      print('-----------');
    }
  }
}

bool checkWinner(List<String> board) {
  List<List<int>> winPositions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (var pos in winPositions) {
    String a = board[pos[0]];
    String b = board[pos[1]];
    String c = board[pos[2]];
    if (a == b && b == c) return true;
  }

  return false;
}
