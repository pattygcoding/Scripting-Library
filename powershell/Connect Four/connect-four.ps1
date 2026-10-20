function connect-four {
	param (
        [string]$p1 = "Player 1",
        [string]$p2 = "Player 2"
    )
	
    # Initialize the board
    $board = @(
        @(" ", " ", " ", " ", " ", " ", " "),
        @(" ", " ", " ", " ", " ", " ", " "),
        @(" ", " ", " ", " ", " ", " ", " "),
        @(" ", " ", " ", " ", " ", " ", " "),
        @(" ", " ", " ", " ", " ", " ", " "),
        @(" ", " ", " ", " ", " ", " ", " ")
    )

    # Display the board
    function Display-Board {
		Write-Host "`nCONNECT FOUR" -ForegroundColor Blue
		Write-Host "---------" -ForegroundColor Cyan
        foreach ($row in $board) {
            Write-Host -NoNewline "|" -ForegroundColor Cyan
            foreach ($cell in $row) {
                if ($cell -eq "O") {
                    Write-Host -NoNewline "O" -ForegroundColor Red
                } elseif ($cell -eq "X") {
                    Write-Host -NoNewline "O" -ForegroundColor Yellow
                } else {
                    Write-Host -NoNewline " "
                }
            }
            Write-Host "|" -ForegroundColor Cyan
        }
        Write-Host "---------" -ForegroundColor Cyan
        Write-Host " 1234567`n" -ForegroundColor Cyan
    }

    # Check for a win
    function Check-Win {
        param (
            [char]$player
        )

        # Check horizontal
        for ($r = 0; $r -le 5; $r++) {
            for ($c = 0; $c -le 3; $c++) {
                if ($board[$r][$c] -eq $player -and $board[$r][$c+1] -eq $player -and $board[$r][$c+2] -eq $player -and $board[$r][$c+3] -eq $player) {
                    return $true
                }
            }
        }

        # Check vertical
        for ($c = 0; $c -le 6; $c++) {
            for ($r = 0; $r -le 2; $r++) {
                if ($board[$r][$c] -eq $player -and $board[$r+1][$c] -eq $player -and $board[$r+2][$c] -eq $player -and $board[$r+3][$c] -eq $player) {
                    return $true
                }
            }
        }

        # Check diagonal (down-right)
        for ($r = 0; $r -le 2; $r++) {
            for ($c = 0; $c -le 3; $c++) {
                if ($board[$r][$c] -eq $player -and $board[$r+1][$c+1] -eq $player -and $board[$r+2][$c+2] -eq $player -and $board[$r+3][$c+3] -eq $player) {
                    return $true
                }
            }
        }

        # Check diagonal (up-right)
        for ($r = 3; $r -le 5; $r++) {
            for ($c = 0; $c -le 3; $c++) {
                if ($board[$r][$c] -eq $player -and $board[$r-1][$c+1] -eq $player -and $board[$r-2][$c+2] -eq $player -and $board[$r-3][$c+3] -eq $player) {
                    return $true
                }
            }
        }

        return $false
    }

    # Main game loop
    $players = @("O", "X")
    $playerNames = @("$p1", "$p2")
    $playerColors = @("Red", "Yellow")
    $currentPlayerIndex = 0

    while ($true) {
        Display-Board

        $currentPlayer = $players[$currentPlayerIndex]
        $currentPlayerName = $playerNames[$currentPlayerIndex]
        $currentPlayerColor = $playerColors[$currentPlayerIndex]
		if($currentPlayerName -match $p1)
		{
			Write-Host "$currentPlayerName, choose a column (1-7):" -ForegroundColor Red
		}
		elseif($currentPlayerName -match $p2)
		{
			Write-Host "$currentPlayerName, choose a column (1-7):" -ForegroundColor Yellow
		}
        $column = Read-Host
        if ($column -match '^[1-7]$') {
            $column = [int]$column - 1

            # Find the lowest empty row in the chosen column
            $placed = $false
            for ($row = 5; $row -ge 0; $row--) {
                if ($board[$row][$column] -eq ' ') {
                    $board[$row][$column] = $currentPlayer
                    $placed = $true
                    break
                }
            }

            if (-not $placed) {
                Write-Host "Column $($column+1) is full! Choose another column." -ForegroundColor DarkRed
            } else {
                if (Check-Win -player $currentPlayer) {
                    Display-Board
                    Write-Host "$currentPlayerName wins!`n" -ForegroundColor Green
                    break
                }

                # Switch players
                $currentPlayerIndex = ($currentPlayerIndex + 1) % 2
            }
        } else {
            Write-Host "Invalid input. Please enter a number between 1 and 7." -ForegroundColor DarkRed
        }

        # Check for tie
        $tie = $true
        foreach ($row in $board) {
            if ($row -contains ' ') {
                $tie = $false
                break
            }
        }

        if ($tie) {
            Display-Board
            Write-Host "It's a tie!`n" -ForegroundColor Green
            break
        }
    }
}
