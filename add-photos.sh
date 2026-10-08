#!/bin/bash
# ============================================================================
# Add photos to the site (Mac only; uses built-in tools, nothing to install).
#
#   ./add-photos.sh ~/Desktop/photo1.HEIC ~/Desktop/photo2.jpg
#   ./add-photos.sh ~/Desktop/new-photos          (a whole folder)
#
# For each photo it:
#   1. converts it to .jpg (works with iPhone .HEIC, .png, .tif, .webp too)
#   2. shrinks it to at most 2000px on the long side so the site stays fast
#   3. notes the year and the city/country it was taken in (shown when someone
#      opens the photo; edit or delete them in photos.js if you like)
#   4. removes ALL hidden data: GPS location, date and time, phone/camera model
#   5. saves it into /images and adds it to the bottom of photos.js
#
# Edited a photo? Export it with the same file name and run this again: the
# photo on the site is replaced and its title, place, year and position are kept.
#
# Your original files are never changed. Afterwards, open photos.js to add
# titles, captions or categories, or to change the order.
# ============================================================================
set -euo pipefail

MAX_SIZE=2000   # longest side in pixels; 2000 looks sharp on most screens
QUALITY=82      # JPEG quality 1-100; 80-85 is a good balance

cd "$(dirname "$0")"
MARKER="add-photos.sh adds new photos just above this line"

if [ $# -eq 0 ]; then
  echo "Usage: ./add-photos.sh photo1.HEIC photo2.jpg ...   or   ./add-photos.sh /path/to/folder"
  exit 1
fi
if ! command -v python3 >/dev/null; then
  echo "python3 is needed to remove location data from photos. Nothing was added."
  echo "Install it by running:  xcode-select --install"
  exit 1
fi
if ! grep -q "$MARKER" photos.js; then
  echo "Couldn't find the line \"// $MARKER\" in photos.js. Please put it back at the end of the list."
  exit 1
fi

# Collect files (folders are expanded to the images inside them).
files=()
for arg in "$@"; do
  if [ -d "$arg" ]; then
    while IFS= read -r f; do files+=("$f"); done < <(
      find "$arg" -maxdepth 1 -type f \( -iname '*.heic' -o -iname '*.jpg' -o -iname '*.jpeg' \
        -o -iname '*.png' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.webp' \) | sort)
  else
    files+=("$arg")
  fi
done

# Build the year/place reader once and keep it in your Mac's cache folder
# (outside the website, so it's never uploaded). Takes a minute the first time.
INFO_BIN="$HOME/Library/Caches/portfolio-site/photo_info"
if [ ! -x "$INFO_BIN" ] || [ tools/photo_info.swift -nt "$INFO_BIN" ]; then
  echo "  Setting up the year/place reader (first run only, about a minute)…"
  mkdir -p "$(dirname "$INFO_BIN")"
  swiftc -O tools/photo_info.swift -o "$INFO_BIN" 2>/dev/null || INFO_BIN=""
  [ -z "$INFO_BIN" ] && echo "  (Couldn't set it up, so photos will be added without place and year.)"
fi

added=0
for src in "${files[@]}"; do
  # Make a web-friendly file name: "IMG 7185.HEIC" -> "img-7185.jpg"
  base=$(basename "$src"); base="${base%.*}"
  name=$(echo "$base" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g')
  out="images/$name.jpg"
  # Same file name as a photo already on the site? Treat it as an edited
  # version: replace the image, keep its title/caption/position in photos.js.
  replacing=false

  # Year and "City, Country", read before the metadata is removed.
  info=""; [ -n "$INFO_BIN" ] && info=$("$INFO_BIN" "$src" 2>/dev/null || true)
  place=$(printf '%s' "$info" | cut -f1 | tr -d '"\\')
  year=$(printf '%s' "$info" | cut -f2 | tr -d '"\\')
  grep -q "\"$out\"" photos.js && replacing=true
  tmp="images/.incoming-$name.jpg"

  # Only shrink, never enlarge.
  w=$(sips -g pixelWidth "$src" 2>/dev/null | awk '/pixelWidth/{print $2}')
  h=$(sips -g pixelHeight "$src" 2>/dev/null | awk '/pixelHeight/{print $2}')
  if [ -z "$w" ]; then echo "  Skipped $src (not an image sips can read)"; continue; fi
  resize=(); [ $(( w > h ? w : h )) -gt $MAX_SIZE ] && resize=(-Z "$MAX_SIZE")

  # Work on a temporary copy, so a failure never touches a photo already on the site.
  sips -s format jpeg -s formatOptions "$QUALITY" ${resize[@]+"${resize[@]}"} "$src" --out "$tmp" >/dev/null

  # Phones often store photos sideways with a hidden "rotate me" tag. That tag
  # gets removed with the rest of the metadata, so rotate the pixels for real first.
  case "$(python3 tools/strip_metadata.py --orientation "$tmp")" in
    2) sips -f horizontal "$tmp" >/dev/null ;;
    3) sips -r 180 "$tmp" >/dev/null ;;
    4) sips -f vertical "$tmp" >/dev/null ;;
    5) sips -r 90 "$tmp" >/dev/null; sips -f horizontal "$tmp" >/dev/null ;;
    6) sips -r 90 "$tmp" >/dev/null ;;
    7) sips -r 270 "$tmp" >/dev/null; sips -f horizontal "$tmp" >/dev/null ;;
    8) sips -r 270 "$tmp" >/dev/null ;;
  esac

  # Remove hidden metadata. If that fails for any reason, throw the copy away
  # rather than risk publishing a photo that still has location data in it.
  if ! python3 tools/strip_metadata.py "$tmp" >/dev/null; then
    rm -f "$tmp"
    echo "  Skipped $src (couldn't remove its metadata safely)"
    continue
  fi
  mv "$tmp" "$out"

  # Record the final size so the gallery can balance its columns.
  size="$(sips -g pixelWidth "$out" | awk '/pixelWidth/{print $2}')x$(sips -g pixelHeight "$out" | awk '/pixelHeight/{print $2}')"

  if $replacing; then
    # Update (or add) the size on this photo's existing line; keep everything else.
    # Update the size; fill in place/year only if the line doesn't have them yet,
    # so anything you've typed yourself is kept.
    awk -v src="\"$out\"" -v size="$size" -v place="$place" -v year="$year" '
      index($0, src) {
        if ($0 ~ /size: "[0-9]+x[0-9]+"/) sub(/size: "[0-9]+x[0-9]+"/, "size: \"" size "\"")
        else sub(src ",", src ", size: \"" size "\",")
        if (place != "" && $0 !~ /place:/) sub(/ *},? *$/, ", place: \"" place "\" },")
        if (year != "" && $0 !~ /year:/) sub(/ *},? *$/, ", year: \"" year "\" },")
      }
      { print }' photos.js > photos.js.tmp
    mv photos.js.tmp photos.js
    echo "  Updated $out (title, place, year and position kept)"
  else
    line="  { src: \"$out\", size: \"$size\", title: \"\", place: \"$place\", year: \"$year\" },"
    awk -v line="$line" -v marker="$MARKER" 'index($0, marker) { print line } { print }' photos.js > photos.js.tmp
    mv photos.js.tmp photos.js
    echo "  Added $out${place:+ ($place${year:+, $year})}"
  fi
  added=$((added+1))
done

echo ""
echo "Done: $added photo(s) added or updated, metadata removed."
[ "$added" -gt 0 ] && echo "Open photos.js to add titles or change places, then refresh the page."
exit 0
