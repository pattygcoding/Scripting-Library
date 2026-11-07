# connect-four - Plays a two-player game of Connect Four in the console.
connect-four() {
    local p1="${1:-Player 1}"
    local p2="${2:-Player 2}"
    local rows=6 cols=7

    local -a board
    local i
    for ((i = 0; i < rows * cols; i++)); do
        board[$i]=" "
    done

    _cf_display() {
        echo -e "\n\033[94mCONNECT FOUR\033[0m"
        echo -e "\033[96m---------\033[0m"
        local r c cell
        for ((r = 0; r < rows; r++)); do
            printf '\033[96m|\033[0m'
            for ((c = 0; c < cols; c++)); do
                cell="${board[r * cols + c]}"
                if [[ "$cell" == "O" ]]; then
                    printf '\033[91mO\033[0m'
                elif [[ "$cell" == "X" ]]; then
                    printf '\033[93mX\033[0m'
                else
                    printf ' '
                fi
            done
            printf '\033[96m|\033[0m\n'
        done
        echo -e "\033[96m---------\033[0m"
        echo -e "\033[96m 1234567\033[0m\n"
    }

    _cf_win() {
        local player="$1" r c
        for ((r = 0; r < rows; r++)); do
            for ((c = 0; c <= cols - 4; c++)); do
                [[ ${board[r*cols+c]} == $player && ${board[r*cols+c+1]} == $player \
                   && ${board[r*cols+c+2]} == $player && ${board[r*cols+c+3]} == $player ]] && return 0
            done
        done
        for ((c = 0; c < cols; c++)); do
            for ((r = 0; r <= rows - 4; r++)); do
                [[ ${board[r*cols+c]} == $player && ${board[(r+1)*cols+c]} == $player \
                   && ${board[(r+2)*cols+c]} == $player && ${board[(r+3)*cols+c]} == $player ]] && return 0
            done
        done
        for ((r = 0; r <= rows - 4; r++)); do
            for ((c = 0; c <= cols - 4; c++)); do
                [[ ${board[r*cols+c]} == $player && ${board[(r+1)*cols+c+1]} == $player \
                   && ${board[(r+2)*cols+c+2]} == $player && ${board[(r+3)*cols+c+3]} == $player ]] && return 0
            done
        done
        for ((r = 3; r < rows; r++)); do
            for ((c = 0; c <= cols - 4; c++)); do
                [[ ${board[r*cols+c]} == $player && ${board[(r-1)*cols+c+1]} == $player \
                   && ${board[(r-2)*cols+c+2]} == $player && ${board[(r-3)*cols+c+3]} == $player ]] && return 0
            done
        done
        return 1
    }

    local -a players=("O" "X")
    local -a names=("$p1" "$p2")
    local -a colors=(91 93)
    local turn=0 player name choice col row placed
    local full

    while true; do
        _cf_display
        player="${players[$turn]}"
        name="${names[$turn]}"
        printf '\033[%sm%s, choose a column (1-7):\033[0m ' "${colors[$turn]}" "$name"
        read -r choice || { echo; return 0; }

        if [[ ! "$choice" =~ ^[1-7]$ ]]; then
            echo -e "\033[31mInvalid input. Please enter a number between 1 and 7.\033[0m"
            continue
        fi

        col=$((choice - 1))
        placed=0
        for ((row = rows - 1; row >= 0; row--)); do
            if [[ "${board[row*cols+col]}" == " " ]]; then
                board[row*cols+col]="$player"
                placed=1
                break
            fi
        done

        if [[ $placed -eq 0 ]]; then
            echo -e "\033[31mColumn $choice is full! Choose another column.\033[0m"
            continue
        fi

        if _cf_win "$player"; then
            _cf_display
            echo -e "\033[92m$name wins!\033[0m\n"
            return 0
        fi

        turn=$(( (turn + 1) % 2 ))

        full=1
        for ((i = 0; i < rows * cols; i++)); do
            [[ "${board[$i]}" == " " ]] && { full=0; break; }
        done
        if [[ $full -eq 1 ]]; then
            _cf_display
            echo -e "\033[92mIt's a tie!\033[0m\n"
            return 0
        fi
    done
}
