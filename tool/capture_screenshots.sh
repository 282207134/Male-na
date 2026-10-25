#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
DEVICE="${1:-emulator-5554}"
ADB="${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb"
flutter drive --driver=test_driver/screenshots.dart --target=integration_test/app_test.dart -d "$DEVICE" --keep-app-running
mkdir -p docs/screenshots
SCREEN_DIR=$("$ADB" -s "$DEVICE" shell run-as com.malena.malena find . -type d -name malena-screenshots | tr -d '\r' | head -n 1)
if [[ -z "$SCREEN_DIR" ]]; then
  echo "Screenshot directory not found" >&2
  exit 1
fi
"$ADB" -s "$DEVICE" exec-out run-as com.malena.malena tar -C "$SCREEN_DIR" -cf - . | tar -xf - -C docs/screenshots
