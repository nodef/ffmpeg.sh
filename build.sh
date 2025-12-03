#!/usr/bin/env bash
URL_WIN="https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"
URL_LNX="https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl-shared.tar.xz"

setup() {
OS="$1"
URL="$2"
ZIP="${URL##*/}"
if [[ "$OS" == "windows" ]]; then
  DIR="${ZIP%.zip}"
else
  DIR="${ZIP%.tar.xz}"
fi
mkdir -p .build
cd .build

# Download the release
if [ ! -f "$ZIP" ]; then
  echo "Downloading $ZIP from $URL ..."
  curl -L "$URL" -o "$ZIP"
  echo ""
fi

# Unzip the release
if [ ! -d "$DIR" ]; then
  echo "Unzipping $ZIP to .build/$DIR ..."
  if [[ "$OS" == "windows" ]]; then
    cp "$ZIP" "$ZIP.bak"
    unzip -q "$ZIP"
    rm "$ZIP"
    mv "$ZIP.bak" "$ZIP"
  else
    tar -xf "$ZIP"
  fi
fi

# Copy the files to the main directory
echo "Copying libs to main directory ..."
mv "$DIR" ../ffmpeg
cd ..
}


# Publish
rm -rf ffmpeg/
if [[ "$1" == "windows" ]]; then
  echo "Publishing for Windows ..."
  node build.js "windows"
  setup "windows" "$URL_WIN"
else
  echo "Publishing for Linux ..."
  setup "linux" "$URL_LNX"
  npm publish
fi
echo ""
