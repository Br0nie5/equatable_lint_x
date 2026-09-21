# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`equatable_lint_x` is a Dart analyzer plugin (built on `analysis_server_plugin`, not `custom_lint`) that lints classes using `Equatable` (via `extends` or `with`). It is published to pub.dev; users enable it under `plugins:` in their `analysis_options.yaml`. Rule docs and user-facing setup live in [README.md](README.md); update it (and [CHANGELOG.md](CHANGELOG.md)) when adding or changing rules, fixes or assists.

## Commands

- Install deps: `dart pub get`
- Run all tests: `dart test` (the pre-commit hook uses `./scripts/test.sh --coverage`, which randomizes test order and **requires 100% line coverage** via `lcov`)
- Run one test file: `dart test test/src/lints/missing_field_in_equatable_props/missing_field_in_equatable_props_field_cases_test.dart`
- Run one test case: `dart test <file> -n test_case_1`
- Analyze: `dart analyze --fatal-infos lib test`
- Format check: `dart format --set-exit-if-changed .`
- Pre-commit (lefthook.yml) runs format, analyze and tests in parallel. Flutter/Dart versions are pinned via FVM (`.fvmrc`); CI uses Dart 3.12.2.

## Architecture

- [lib/main.dart](lib/main.dart) is the plugin entry point (declared under `plugin:` in `pubspec.yaml`). `register()` is the single place where every rule, quick fix and assist is wired up. New ones must be registered there.
- `lib/src/lints/<rule_name>/` holds one rule per folder: `<rule_name>.dart` (the `AnalysisRule` + its `LintCode` as a static `code`) and `fixes/` (quick fixes registered against `Rule.code`). Two rules exist: `missing_field_in_equatable_props` and `always_call_super_props_when_overriding_equatable_props`.
- `lib/src/assists/make_class_use_equatable.dart` holds the assists (`MakeClassExtendEquatable`, `MakeClassWithEquatable`), which are independent of any lint.
- `lib/src/utils/` holds shared analysis helpers (finding the `props` node/elements, walking ancestors and mixins for Equatable, collecting non-Equatable fields). Both rules and their fixes depend on these; `props` may be declared as a getter or as a field (`late final List<Object?> props = ...`), and both forms must be handled.
- `lib/src/constants/` holds the Equatable and package name constants.

## Testing

- Tests use `analyzer_testing` with `test_reflective_loader`: test classes extend a per-rule `*_analysis_rule.dart` base (which sets `rule` and calls `setEquatablePackageMock()` from [test/utils/mocks.dart](test/utils/mocks.dart) — a stub `equatable` package, since the real one is not resolved).
- Test methods are named `test_case_N`, grouped by files per scenario (`field_cases`, `getter_cases`, `super_class_cases`, `exception_cases`). Diagnostics are asserted by source **offset and length** (e.g. `customLint(142, 5, variableName: 'field')`), so editing the inline Dart snippet shifts offsets.
- Each test file has its own `main()` calling `defineReflectiveSuite`, so a new test class must be added there.
- [example/](example/) is a separate Flutter-style sample package used to try the lints/assists manually in an IDE; it is not part of the tests.
