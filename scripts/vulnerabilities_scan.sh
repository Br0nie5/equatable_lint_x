#!/usr/bin/env bash
set -euo pipefail

LOCKFILE="pubspec.lock"

if ! command -v osv-scanner >/dev/null 2>&1; then
  echo "❌ osv-scanner is not installed. See https://google.github.io/osv-scanner/installation/"
  exit 1
fi

if [ ! -f "$LOCKFILE" ]; then
  echo "📦 $LOCKFILE not found, running dart pub get..."
  dart pub get
fi

echo ""
echo "🔍 Scanning dependencies for known vulnerabilities..."
echo ""

if osv-scanner scan source --lockfile "$LOCKFILE"; then
  echo "✅ No known vulnerabilities found"
else
  echo "❌ Vulnerabilities found (or scan failed)!"
  exit 1
fi
