#!/usr/bin/env bash
cd ~/projects
echo '
repo: Projects
tabs:'

while read projectFolder; do
  if [ -d "$projectFolder" ]; then
    echo "- tab: $projectFolder"
    echo "  dir: $projectFolder"
    README="$(find "$projectFolder" -maxdepth 1 -iname readme.md)"
    if [[ -n "$README" ]]; then
      DOC=$(grep --only-matching -E '^#[ 0-9a-zA-Z/_-]+' "$README" | head -n1 | cut -d'#' -f2-)
      if [[ -n "$DOC" ]]; then
        echo '  doc: "'"$DOC"' "'
      fi
    fi
  fi
done <<<$(ls ~/projects)
