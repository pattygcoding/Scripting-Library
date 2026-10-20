time() {
  if [[ $# -eq 0 ]]; then
    echo -e "\033[1;31mYou must pass a command to time.\033[0m"
    return 1
  fi

  local start=$(date +%s.%N)
  "$@"
  local exit_code=$?
  local end=$(date +%s.%N)
  local elapsed=$(echo "$end - $start" | bc)

  echo -e "\n\033[1;35mThe task took ${elapsed} seconds to complete.\033[0m\n"
  return $exit_code
}
