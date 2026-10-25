#!/bin/bash
# vercel-build.sh - Builds Flutter Web on Vercel's build environment
set -e

if [ ! -d "_flutter" ]; then
  echo ">>> Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable _flutter
fi

export PATH="$PATH:$(pwd)/_flutter/bin"

echo ">>> Flutter version:"
flutter --version

echo ">>> Building Flutter Web in release mode..."
flutter build web --release

echo ">>> Build completed successfully! Output in build/web"
