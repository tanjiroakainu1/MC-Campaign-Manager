#!/usr/bin/env bash
# Build release APK with online Prisma API URL baked in.
# Usage:
#   ./scripts/build_apk.sh https://your-deployed-api.com
#   ./scripts/build_apk.sh http://192.168.0.101:3001

set -euo pipefail
cd "$(dirname "$0")/.."

API_HOST="${1:-${API_BASE:-}}"
API_HOST="${API_HOST%/api}"
API_HOST="${API_HOST%/}"

if [ -z "$API_HOST" ]; then
  echo "Usage: ./scripts/build_apk.sh <API_SERVER_URL>"
  echo "Example: ./scripts/build_apk.sh https://api.myserver.com"
  echo "Example: ./scripts/build_apk.sh http://192.168.0.101:3001"
  echo ""
  echo "LAN tip: ipconfig getifaddr en0  &&  npm run server  (HOST=0.0.0.0 in .env)"
  exit 1
fi

mkdir -p assets/config
echo "$API_HOST" > assets/config/api_base.txt

echo "Building APK with API_BASE=${API_HOST}/api"
flutter pub get
export JAVA_HOME="${JAVA_HOME:-/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
flutter build apk --release --dart-define="API_BASE=${API_HOST}/api"

echo ""
echo "APK ready: build/app/outputs/flutter-apk/app-release.apk"
echo "Install on Android (same Wi‑Fi as API) — syncs Prisma via ${API_HOST}/api"
