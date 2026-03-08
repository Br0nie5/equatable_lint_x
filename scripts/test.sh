#!/usr/bin/env bash
set -euo pipefail

CI=false
COVERAGE=false
THRESHOLD=100

# --- Parse arguments ---
for arg in "$@"; do
  case "$arg" in
    --ci) CI=true ;;
    --coverage) COVERAGE=true ;;
    *) echo "Unknown argument: $arg" && exit 1 ;;
  esac
done

# --- Build base dart test command ---
DART_CMD="dart test --test-randomize-ordering-seed random"
if [ "$COVERAGE" = true ]; then
  DART_CMD="$DART_CMD --coverage-path=coverage/lcov.info"
fi

set +e  # temporarily disable "exit on error"

echo ""
echo "🚀 Running: $DART_CMD"
echo ""

$DART_CMD
EXIT_CODE=$?

set -e  # re-enable

# --- Handle coverage post-processing ---
if [ "$COVERAGE" = true ]; then
  echo "📊 Generating coverage report..."
  echo ""
  lcov --ignore-errors unused,unused \
    --remove coverage/lcov.info '*.g.dart' '*.gen.dart' '*.gicons.dart' '*.glocalizations.dart' \
    -o coverage/lcov.info

  if [ "$CI" = false ]; then
    genhtml coverage/lcov.info -q -o coverage
  fi

  echo ""
  echo "📉 Checking coverage threshold..."
  echo ""
  COVERAGE_VALUE=$(lcov --summary coverage/lcov.info 2>/dev/null \
    | grep "lines" \
    | sed "s/.*: \([0-9.]*\)%.*/\1/")

  echo "Coverage: ${COVERAGE_VALUE:-0}% (minimum required: $THRESHOLD%)"
  COVERAGE_INT=${COVERAGE_VALUE%.*} # take integer part only
  if [ "$COVERAGE_INT" -lt "$THRESHOLD" ]; then
    echo "❌ Coverage below threshold!"
    EXIT_CODE=1
  else
    echo "✅ Coverage OK"
  fi
else
    echo "⚠️ No coverage file generated."
fi

exit $EXIT_CODE
