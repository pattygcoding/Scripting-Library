-- Plays a two-player game of Connect Four in the console.

local RED = "\27[91m"
local YELLOW = "\27[93m"
local CYAN = "\27[96m"
local GREEN = "\27[92m"
local BLUE = "\27[94m"
local DARK_RED = "\27[31m"
local RESET = "\27[0m"

local ROWS, COLS = 6, 7
local EMPTY = " "
local PLAYERS = { "O", "X" }
local COLORS = { O = RED, X = YELLOW }

local function new_board()
  local board = {}
  for r = 1, ROWS do
    board[r] = {}
    for c = 1, COLS do
      board[r][c] = EMPTY
    end
  end
  return board
end

local function display(board)
  print("\n" .. BLUE .. "CONNECT FOUR" .. RESET)
  print(CYAN .. "---------" .. RESET)
  for r = 1, ROWS do
    local cells = {}
    for c = 1, COLS do
      local cell = board[r][c]
      cells[#cells + 1] = (COLORS[cell] or "") .. cell .. RESET
    end
    print(CYAN .. "|" .. RESET .. table.concat(cells) .. CYAN .. "|" .. RESET)
  end
  print(CYAN .. "---------" .. RESET)
  print(CYAN .. " 1234567" .. RESET .. "\n")
end

local function check_win(board, player)
  for r = 1, ROWS do
    for c = 1, COLS - 3 do
      if board[r][c] == player and board[r][c + 1] == player
          and board[r][c + 2] == player and board[r][c + 3] == player then
        return true
      end
    end
  end
  for c = 1, COLS do
    for r = 1, ROWS - 3 do
      if board[r][c] == player and board[r + 1][c] == player
          and board[r + 2][c] == player and board[r + 3][c] == player then
        return true
      end
    end
  end
  for r = 1, ROWS - 3 do
    for c = 1, COLS - 3 do
      if board[r][c] == player and board[r + 1][c + 1] == player
          and board[r + 2][c + 2] == player and board[r + 3][c + 3] == player then
        return true
      end
    end
  end
  for r = 4, ROWS do
    for c = 1, COLS - 3 do
      if board[r][c] == player and board[r - 1][c + 1] == player
          and board[r - 2][c + 2] == player and board[r - 3][c + 3] == player then
        return true
      end
    end
  end
  return false
end

local function drop(board, column, player)
  for r = ROWS, 1, -1 do
    if board[r][column] == EMPTY then
      board[r][column] = player
      return true
    end
  end
  return false
end

local function board_full(board)
  for r = 1, ROWS do
    for c = 1, COLS do
      if board[r][c] == EMPTY then
        return false
      end
    end
  end
  return true
end

local function main()
  local names = { "Player 1", "Player 2" }

  local i = 1
  while i <= #arg do
    if arg[i] == "--p1" then
      names[1] = arg[i + 1]
      i = i + 2
    elseif arg[i] == "--p2" then
      names[2] = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  local board = new_board()
  local turn = 1

  while true do
    display(board)

    local player = PLAYERS[turn]
    local name = names[turn]
    io.write(COLORS[player] .. name .. ", choose a column (1-7):" .. RESET .. " ")
    local choice = io.read("*l")

    if not choice then
      return
    elseif not choice:match("^%s*[1-7]%s*$") then
      print(DARK_RED .. "Invalid input. Please enter a number between 1 and 7." .. RESET)
    else
      local column = tonumber(choice:match("[1-7]"))
      if not drop(board, column, player) then
        print(DARK_RED .. "Column " .. column .. " is full! Choose another column." .. RESET)
      elseif check_win(board, player) then
        display(board)
        print(GREEN .. name .. " wins!\n" .. RESET)
        return
      else
        turn = (turn % 2) + 1
        if board_full(board) then
          display(board)
          print(GREEN .. "It's a tie!\n" .. RESET)
          return
        end
      end
    end
  end
end

main()
