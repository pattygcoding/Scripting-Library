#!/usr/bin/env ruby
# frozen_string_literal: true

# Plays a two-player game of Connect Four in the console.

require 'optparse'

RED = "\e[91m"
YELLOW = "\e[93m"
CYAN = "\e[96m"
GREEN = "\e[92m"
BLUE = "\e[94m"
DARK_RED = "\e[31m"
RESET = "\e[0m"

ROWS = 6
COLS = 7
EMPTY = ' '
PLAYERS = %w[O X].freeze
COLORS = { 'O' => RED, 'X' => YELLOW }.freeze

def main
  options = parse_options
  play(options[:p1], options[:p2])
rescue Interrupt
  puts
end

def parse_options
  options = { p1: 'Player 1', p2: 'Player 2' }
  OptionParser.new do |opts|
    opts.banner = 'Usage: connect-four.rb [--p1 NAME] [--p2 NAME]'
    opts.on('--p1 NAME', 'First player name') { |v| options[:p1] = v }
    opts.on('--p2 NAME', 'Second player name') { |v| options[:p2] = v }
  end.parse!
  options
end

def new_board
  Array.new(ROWS) { Array.new(COLS, EMPTY) }
end

def display(board)
  puts "\n#{BLUE}CONNECT FOUR#{RESET}"
  puts "#{CYAN}---------#{RESET}"
  board.each do |row|
    cells = row.map { |cell| "#{COLORS.fetch(cell, '')}#{cell}#{RESET}" }.join
    puts "#{CYAN}|#{RESET}#{cells}#{CYAN}|#{RESET}"
  end
  puts "#{CYAN}---------#{RESET}"
  puts "#{CYAN} 1234567#{RESET}\n"
end

def win?(board, player)
  ROWS.times do |r|
    (COLS - 3).times do |c|
      return true if (0...4).all? { |i| board[r][c + i] == player }
    end
  end
  COLS.times do |c|
    (ROWS - 3).times do |r|
      return true if (0...4).all? { |i| board[r + i][c] == player }
    end
  end
  (ROWS - 3).times do |r|
    (COLS - 3).times do |c|
      return true if (0...4).all? { |i| board[r + i][c + i] == player }
    end
  end
  (3...ROWS).each do |r|
    (COLS - 3).times do |c|
      return true if (0...4).all? { |i| board[r - i][c + i] == player }
    end
  end
  false
end

def drop(board, column, player)
  (ROWS - 1).downto(0) do |row|
    if board[row][column] == EMPTY
      board[row][column] = player
      return true
    end
  end
  false
end

def play(p1, p2)
  board = new_board
  names = [p1, p2]
  turn = 0

  loop do
    display(board)
    player = PLAYERS[turn]
    name = names[turn]
    print "#{COLORS[player]}#{name}, choose a column (1-7):#{RESET} "
    choice = $stdin.gets&.strip

    unless choice&.match?(/\A[1-7]\z/)
      puts "#{DARK_RED}Invalid input. Please enter a number between 1 and 7.#{RESET}"
      next
    end

    column = choice.to_i - 1
    unless drop(board, column, player)
      puts "#{DARK_RED}Column #{column + 1} is full! Choose another column.#{RESET}"
      next
    end

    if win?(board, player)
      display(board)
      puts "#{GREEN}#{name} wins!\n#{RESET}"
      return
    end

    turn = (turn + 1) % 2

    if board.flatten.none? { |cell| cell == EMPTY }
      display(board)
      puts "#{GREEN}It's a tie!\n#{RESET}"
      return
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
