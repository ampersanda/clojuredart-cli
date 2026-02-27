## 2.2.2
- Fix CI: create bin entrypoint for integration tests (`bin/` is gitignored)

## 2.2.1
- Fix CI: use `clojure` instead of `clj` (rlwrap not available in CI)
- Expand README usage section with all CLI commands and examples

## 2.2.0
- Add `--sha` flag to pin a specific ClojureDart SHA instead of fetching latest
- Add GitHub Actions CI workflow for automated testing
- Add unit and integration tests for `--sha` flag

## 2.1.0
- Robust rollback on project creation failure: delete existing directory before recreation on overwrite, warn instead of crashing if cleanup fails

## 2.0.2
- Bump generated `deps.edn` Clojure version from 1.10.1 to 1.12.0 (latest ClojureDart requires 1.11+)

## 2.0.1
- Fix `clj -M:cljd init` failure not detected: exit code is now checked and errors are properly reported with cleanup

## 2.0.0
- **Breaking**: Requires Dart SDK >=3.0.0
- Add `--help` / `-h` flag
- Add `--version` flag
- Add `-o` / `--output` option for custom output directory
- Add prerequisite checks (verifies `clj` is on PATH before generation)
- Add directory overwrite confirmation prompt
- Add version update check (non-blocking, runs after generation)
- Redesign template system with `{{placeholder}}` syntax and validation
- Switch generated `deps.edn` to use HTTPS git URL by default
- Improve project name validation: allow digits, length constraints, reserved word checks, specific error messages
- Refactor generators into unified `generate-project` with error recovery and cleanup
- Improve SHA fetch failure UX with `.fail` progress indicator
- Add argument parsing via Dart `args` package
- Handle partial CLI args gracefully (e.g., `cljds dart` prompts for name)
- Update `http` to ^1.2.0, `mason_logger` to ^0.3.0, `lints` to ^3.0.0, `test` to ^1.25.0

## 1.3.0
- Upgrade ClojureDart to `8d5916c0dc87146dc2e8921aaa7fd5dc3c6c3401` to support Dart 3 and Flutter 3.10.0

## 1.2.2
- Upgrade ClojureDart to `81dd5f73285b06fa8904076e3299ee8feff101df`
- Update example to use `f/run` instead of `m/runApp` to activate hot reload for project starter

## 1.2.1
- Refactor logger, Process.run, use keywords for types and re-indent code
- Change `README.md`. Add troubleshooting for github ssh key changes 

## 1.2.0

- Using `mason_logger`
- Migrate `dart` and `flutter` command
