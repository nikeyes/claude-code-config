#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

# Calculate context usage percentage (without autocompact buffer)
# current_usage already includes everything: system prompt, tools, agents, memory, and messages

if [ "$USAGE" != "null" ]; then
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .output_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    # Calculate percentage with rounding to nearest integer (matches /context behavior)
    PERCENT_REAL=$(echo "scale=0; ($CURRENT_TOKENS * 100 + $CONTEXT_SIZE / 2) / $CONTEXT_SIZE" | bc)
else
    # After clear, assume baseline context (system prompt + tools + agents + memory ≈ 10%)
    PERCENT_REAL=10
fi

# Create progress bar with solid blocks and dotted pattern (30 chars total)
TOTAL_CHARS=30
FILLED_CHARS=$((PERCENT_REAL * TOTAL_CHARS / 100))
EMPTY_CHARS=$((TOTAL_CHARS - FILLED_CHARS))

# Determine color based on actual percentage
if [ $PERCENT_REAL -ge 60 ]; then
    COLOR="\033[31m"  # Red text
elif [ $PERCENT_REAL -ge 40 ]; then
    COLOR="\033[33m"  # Yellow text
else
    COLOR="\033[32m"  # Green text
fi

# Build bar with solid blocks (█) and dotted pattern (░)
FILLED_BAR=""
EMPTY_BAR=""

if [ $FILLED_CHARS -gt 0 ]; then
    FILLED_BAR=$(printf '█%.0s' $(seq 1 $FILLED_CHARS))
fi

if [ $EMPTY_CHARS -gt 0 ]; then
    EMPTY_BAR=$(printf '░%.0s' $(seq 1 $EMPTY_CHARS))
fi

BAR="${COLOR}${FILLED_BAR}${EMPTY_BAR}\033[0m"

# Add warning if approaching context limit
WARNING=""
if [ $PERCENT_REAL -ge 70 ]; then
    WARNING=" \033[33m⚠️\033[0m"
fi

# Display status line: ✓ [bar] [12% ctx] (Sonnet 4.5) [warning]
echo -e "✓ ${BAR} \033[36m[${PERCENT_REAL}% ctx]\033[0m \033[90m(${MODEL})\033[0m${WARNING}"
