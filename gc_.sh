#!/bin/bash

gc_() {
  local model=gpt-4o

  # Check if we're in a git repository
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository."
    return 1
  fi

  # Check if there are any staged changes
  if git diff --cached --quiet; then
    echo "Error: No staged changes found. Use 'git add' to stage changes first."
    return 1
  fi

  # Get the diff of staged changes
  local diff_output=$(git diff --cached)
  
  echo "Generating commit message with $model..."
  
  # Send diff to GPT-4o to generate commit message
  local generated_message=$(llm prompt "Generate a concise, descriptive git commit message for the following diff. Keep it under 72 characters if possible. Don't include any explanations, just the commit message. Do not wrap in quotes.\n\n\`\`\`\n$diff_output\n\`\`\`" --model "$model" --no-stream)

  git commit -e -m "$generated_message"
}

