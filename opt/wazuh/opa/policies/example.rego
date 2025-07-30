package example

# Allow requests only if input.user is "alice"
allow {
    input.user == "alice"
}

# Deny everything else
default allow = false
