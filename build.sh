#!/usr/bin/env bash

# Exit on error
set -e

echo "=== Downloading Flutter SDK ==="
git clone https://github.com/flutter/flutter.git -b stable --depth 1

echo "=== Adding Flutter to PATH ==="
export PATH="$PATH:$(pwd)/flutter/bin"

echo "=== Pre-caching Web dependencies ==="
flutter precache --web

echo "=== Building Flutter Web in Release Mode ==="
flutter build web --release --no-tree-shake-icons

echo "=== Build completed successfully ==="
