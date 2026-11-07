#!/usr/bin/env python3
"""Play a two-player game of Connect Four in the console."""

from __future__ import annotations

import argparse
import sys

RED = "\033[91m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
GREEN = "\033[92m"
BLUE = "\033[94m"
DARK_RED = "\033[31m"
RESET = "\033[0m"

ROWS = 6
COLS = 7
EMPTY = " "
PLAYERS = ("O", "X")
COLORS = {"O": RED, "X": YELLOW}


def new_board() -> list[list[str]]:
    """Return an empty board."""
    return [[EMPTY] * COLS for _ in range(ROWS)]


def display(board: list[list[str]]) -> None:
    """Print the board with colored pieces."""
    print(f"\n{BLUE}CONNECT FOUR{RESET}")
    print(f"{CYAN}---------{RESET}")
    for row in board:
        cells = "".join(f"{COLORS.get(cell, '')}{cell}{RESET}" for cell in row)
        print(f"{CYAN}|{RESET}{cells}{CYAN}|{RESET}")
    print(f"{CYAN}---------{RESET}")
    print(f"{CYAN} 1234567{RESET}\n")


def check_win(board: list[list[str]], player: str) -> bool:
    """Return True when *player* has four in a row."""

    def get(row: int, col: int) -> str:
        return board[row][col]

    for row in range(ROWS):
        for col in range(COLS - 3):
            if all(get(row, col + i) == player for i in range(4)):
                return True
    for col in range(COLS):
        for row in range(ROWS - 3):
            if all(get(row + i, col) == player for i in range(4)):
                return True
    for row in range(ROWS - 3):
        for col in range(COLS - 3):
            if all(get(row + i, col + i) == player for i in range(4)):
                return True
    for row in range(3, ROWS):
        for col in range(COLS - 3):
            if all(get(row - i, col + i) == player for i in range(4)):
                return True
    return False


def drop(board: list[list[str]], column: int, player: str) -> bool:
    """Drop a piece into *column*; return False if the column is full."""
    for row in range(ROWS - 1, -1, -1):
        if board[row][column] == EMPTY:
            board[row][column] = player
            return True
    return False


def play(player_one: str, player_two: str) -> None:
    """Run the game loop until someone wins or the board fills."""
    board = new_board()
    names = (player_one, player_two)
    turn = 0

    while True:
        display(board)
        player = PLAYERS[turn]
        name = names[turn]
        print(f"{COLORS[player]}{name}, choose a column (1-7):{RESET}")
        choice = input().strip()

        if choice not in "1234567" or len(choice) != 1:
            print(f"{DARK_RED}Invalid input. Please enter a number between 1 and 7.{RESET}")
            continue

        column = int(choice) - 1
        if not drop(board, column, player):
            print(f"{DARK_RED}Column {column + 1} is full! Choose another column.{RESET}")
            continue

        if check_win(board, player):
            display(board)
            print(f"{GREEN}{name} wins!\n{RESET}")
            return

        turn = (turn + 1) % 2

        if all(cell != EMPTY for row in board for cell in row):
            display(board)
            print(f"{GREEN}It's a tie!\n{RESET}")
            return


def main() -> int:
    parser = argparse.ArgumentParser(description="Play Connect Four.")
    parser.add_argument("--p1", default="Player 1", help="First player name.")
    parser.add_argument("--p2", default="Player 2", help="Second player name.")
    args = parser.parse_args()

    try:
        play(args.p1, args.p2)
    except (EOFError, KeyboardInterrupt):
        print()
    return 0


if __name__ == "__main__":
    sys.exit(main())
