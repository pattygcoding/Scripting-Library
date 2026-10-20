cache-vsindex() {
  local root="${1:-$(pwd)}"
  local index_file="${2:-}"

  declare -A old_map
  declare -A new_map

  # Read old index file into associative array
  if [[ -f "$index_file" ]]; then
    while IFS='|' read -r key paths; do
      IFS=';' read -ra path_arr <<< "$paths"
      old_map["$key"]="${path_arr[*]}"
    done < "$index_file"
  fi

  # Build new map
  while IFS= read -r -d '' file; do
    base_name=$(basename "$file" .cs)
    dir_name=$(dirname "$file")

    # Append directory to the key
    if [[ -n "${new_map[$base_name]}" ]]; then
      new_map["$base_name"]+=$'\n'"$dir_name"
    else
      new_map["$base_name"]="$dir_name"
    fi
  done < <(find "$root" -type f -name "*.cs" -print0)

  # Deduplicate and sort paths
  for key in "${!new_map[@]}"; do
    IFS=$'\n' read -r -d '' -a sorted <<< "$(echo "${new_map[$key]}" | sort -u | tr '\n' ';' | sed 's/;$//')"
    new_map["$key"]="${sorted[*]}"
  done

  # Compare maps
  added=()
  removed=()
  changed=()

  for key in "${!new_map[@]}"; do
    if [[ -z "${old_map[$key]+_}" ]]; then
      added+=("$key")
    elif [[ "${old_map[$key]}" != "${new_map[$key]}" ]]; then
      changed+=("$key")
    fi
  done

  for key in "${!old_map[@]}"; do
    if [[ -z "${new_map[$key]+_}" ]]; then
      removed+=("$key")
    fi
  done

  if [[ ${#added[@]} -eq 0 && ${#removed[@]} -eq 0 && ${#changed[@]} -eq 0 ]]; then
    echo -e "\033[0;32mNo changes detected in .cs files under '$root'.\033[0m"
    return
  fi

  # Remove lines for removed/changed keys
  if [[ -f "$index_file" ]]; then
    cp "$index_file" "$index_file.tmp"
    grep -Ev "^(${removed[*]}|${changed[*]})\|" "$index_file.tmp" > "$index_file"
    rm "$index_file.tmp"
  fi

  # Add new/changed lines
  {
    [[ -f "$index_file" ]] && cat "$index_file"
    for key in "${added[@]}" "${changed[@]}"; do
      echo "$key|${new_map[$key]}"
    done
  } | sort -t'|' -k1,1 > "$index_file.tmp"

  mv "$index_file.tmp" "$index_file"

  echo -e "\033[0;36mIndex updated: +${#added[@]} / -${#removed[@]} / *${#changed[@]}\033[0m"
}
