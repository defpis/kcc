if [ $# -eq 0 ] || [ ! -d "$1" ]; then
  echo "Error: Directory does not exist."
  exit 1
fi

items=()
for item in "$1"/*; do
  filename=$(basename "$item")
  if [[ "$filename" =~ ^[\$\.].* ]]; then
    continue
  fi
  if { [ -f "$item" ] && [[ "$item" =~ \.(cbz|zip|rar)$ ]]; } || [ -d "$item" ]; then
    items+=("$item")
  fi
done

if [ ${#items[@]} -eq 0 ]; then
  echo "Error: No supported items found in directory '$1'."
  echo "Supported target types: file with extension .cbz, .zip, .rar or directory."
  exit 1
fi

echo "Found the following items to process:"
for item in "${items[@]}"; do
  echo " - $item"
done
echo

source venv/bin/activate
python kcc-c2e.py \
  --profile KS \
  --format EPUB \
  --manga-style \
  --splitter 1 \
  --upscale \
  --forcecolor \
  --cropping 0 \
  --eraserainbow \
  "${items[@]}"
deactivate
