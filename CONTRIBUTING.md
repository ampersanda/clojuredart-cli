# Contributing to CLJDS

Thank you for your interest in contributing to CLJDS! This guide will help you get set up and ready to submit changes.

## Prerequisites

- **Clojure CLI** (`clj`)
- **Dart SDK** (>=2.18.0)
- **Flutter SDK** (for testing Flutter project generation)

## Getting Started

1. Fork the repository and clone your fork:
   ```sh
   git clone git@github.com:ampersanda/clojuredart-cli.git
   cd clojuredart-cli
   ```

2. Verify your setup by compiling and running the CLI:
   ```sh
   clj -M:cljd compile
   dart run bin/cljds.dart
   ```

## Development Workflow

- Source files live in `src/cljds/` as `.cljd` (ClojureDart) files.
- **Compile** ClojureDart to Dart:
  ```sh
  clj -M:cljd compile
  ```
- **Watch** for changes during development:
  ```sh
  clj -M:cljd watch
  ```
- **Run locally** (after compile):
  ```sh
  dart run bin/cljds.dart              # interactive mode
  dart run bin/cljds.dart dart name    # generate Dart project
  dart run bin/cljds.dart flutter name # generate Flutter project
  ```
- `lib/` and `bin/` are compiled output (gitignored) — do not edit these directly.

## Project Structure

| Path | Description |
|---|---|
| `src/cljds/core.cljd` | Entry point. Parses CLI arguments or prompts interactively. |
| `src/cljds/generators/` | Project generators for Dart and Flutter. |
| `src/cljds/templates.cljd` | String templates for `deps.edn` and main source files. |
| `src/cljds/consts.cljd` | URLs and constants. |
| `src/cljds/utils/` | Helpers for I/O, logging, name normalization, and shell commands. |

## Submitting Changes

1. Create a branch for your changes:
   ```sh
   git checkout -b my-feature
   ```
2. Make your changes in `src/cljds/`.
3. Compile and test both Dart and Flutter project generation:
   ```sh
   clj -M:cljd compile
   dart run bin/cljds.dart dart test-project
   dart run bin/cljds.dart flutter test-project
   ```
4. Open a pull request against the `main` branch with a clear description of your changes.
