function copycwd
    echo "Choose how to display the home directory:"
    echo "1) ~"
    echo "2) \$HOME"
    echo "3) $HOME"
    read -P "Enter choice (1, 2, or 3): " choice

    switch $choice
        case 1
            pwd | sed "s|^$HOME|~|" | tr -d '\n' | pbcopy
            echo "Current path copied to clipboard with ~ as home directory."
        case 2
            pwd | sed "s|^$HOME|\$HOME|" | tr -d '\n' | pbcopy
            echo "Current path copied to clipboard with \$HOME as home directory."
        case 3
            pwd | tr -d '\n' | pbcopy
            echo "Current path copied to clipboard with full path as home directory."
        case '*'
            echo "Invalid choice. Please enter 1, 2, or 3."
    end
end
