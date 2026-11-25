#!/bin/bash
# Path to the image file
#IMAGE_PATH="$HOME/.local/share/fastfetch/logos/asukaDress.txt"

# Check if the image exists
if [ ! -f "$IMAGE_PATH" ]; then
    # Fetch system information without logo
    fastfetch -c /home/gonzo/.local/share/fastfetch/configs/config.jsonc
    exit 0
else
    # Get the image dimensions
    DIMENSIONS=$(identify -format "%wx%h" "$IMAGE_PATH")
    
    # Extract width and height
    WIDTH=$(echo "$DIMENSIONS" | cut -d'x' -f1)
    HEIGHT=$(echo "$DIMENSIONS" | cut -d'x' -f2)
    
    # Calculate the aspect ratio
    RATIO=$(echo "scale=2; $WIDTH/$HEIGHT" | bc)
    
    # Ensure COLUMNS is set
    COLUMNS=${COLUMNS:-$(tput cols)}
    
    ARGUMENTS=""
    
    # Determine fetch arguments based on ratio
    if (($(echo "$RATIO >= 1" | bc -l))); then
        ARGUMENTS="--logo-width $(echo "$COLUMNS / 2.5" | bc)"
    else
        ARGUMENTS="--logo-height 21"
    fi
    
    # Fetch system information with adjusted logo size
    fastfetch --logo /home/gonzo/.local/share/fastfetch/logos/asukaDress.txt -c /home/gonzo/.local/share/fastfetch/config.jsonc
fi
