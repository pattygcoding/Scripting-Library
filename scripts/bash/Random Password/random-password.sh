# random-password - Generates a random password.
random-password() {
    local length="${1:-12}"

    if [[ ! "$length" =~ ^[0-9]+$ || "$length" -lt 1 ]]; then
        echo "random-password: length must be a positive integer." >&2
        return 1
    fi

    LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()-_=+' < /dev/urandom | head -c "$length"
    echo
}
