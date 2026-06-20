#!/usr/bin/env bash
# Build release APK and copy to public/downloads for web home page.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_HOST="${1:-https://mc-campaign-manager.vercel.app}"

cd "$ROOT/mobiledevelopment"
./scripts/build_apk.sh "$API_HOST"

mkdir -p "$ROOT/public/downloads"
cp build/app/outputs/flutter-apk/app-release.apk "$ROOT/public/downloads/campaign-manager.apk"

echo ""
echo "APK copied to public/downloads/campaign-manager.apk"
ls -lh "$ROOT/public/downloads/campaign-manager.apk"
