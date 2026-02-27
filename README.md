# ClojureDart-CLI/CLJDS

[![pub package](https://img.shields.io/pub/v/cljds.svg)](https://pub.dev/packages/cljds)
[![Tests](https://github.com/ampersanda/clojuredart-cli/actions/workflows/test.yml/badge.svg)](https://github.com/ampersanda/clojuredart-cli/actions/workflows/test.yml)

A CLI tool for generating ClojureDart projects based on the official quick-start guides:

- [Dart quick-start](https://github.com/Tensegritics/ClojureDart/blob/main/doc/quick-start.md)
- [Flutter quick-start](https://github.com/Tensegritics/ClojureDart/blob/main/doc/flutter-quick-start.md)

## Installing

```shell
$ dart pub global activate cljds 2.2.0
```

## Prerequisites

- [Clojure CLI](https://clojure.org/guides/install_clojure) (`clj`)
- [Dart SDK](https://dart.dev/get-dart) (>=3.0.0)
- Git with SSH or HTTPS access to GitHub

## Usage

```
Usage: cljds <command> [arguments]

Available commands:
  dart       Generate a plain Dart ClojureDart project
  flutter    Generate a Flutter ClojureDart project

Global options:
  -h, --help       Print usage information
      --version    Print the current version

Command options:
  -o, --output     Directory to create the project in
      --sha        Specific ClojureDart SHA to use instead of fetching latest
```

### Interactive mode

Run with no arguments to be prompted for project type and name:

```shell
$ cljds
```

### Generate a project

```shell
$ cljds dart my_app                # plain Dart project
$ cljds flutter my_app             # Flutter project
$ cljds dart                       # prompts for project name
$ cljds flutter                    # prompts for project name
```

### Custom output directory

```shell
$ cljds dart my_app -o /tmp        # creates /tmp/my_app
$ cljds flutter my_app -o ~/projects
```

### Pin a specific ClojureDart version

By default, `cljds` fetches the latest ClojureDart SHA from GitHub. Use `--sha` to pin a specific commit:

```shell
$ cljds dart my_app --sha abcdef1234567890abcdef1234567890abcdef12
```

### Combine options

```shell
$ cljds dart my_app --sha abcdef1234567890abcdef1234567890abcdef12 -o /tmp
$ cljds flutter my_app -o ~/projects --sha abcdef1234567890abcdef1234567890abcdef12
```

### Other

```shell
$ cljds --help                     # print usage information
$ cljds --version                  # print current version
```

## Testing

Compile ClojureDart source first, then run tests:

```shell
$ clj -M:cljd compile
$ dart test
```

Tests are also run automatically on push and pull requests via GitHub Actions.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to set up the project and submit changes.

## Troubleshooting

- "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!" error

```shell
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the RSA key sent by the remote host is
SHA256:uNiVztksCsDhcc0u9e8BujQXVUpKZIDTMczCvj3tD2s.
Please contact your system administrator.
Add correct host key in ~/.ssh/known_hosts to get rid of this message.
Host key for github.com has changed and you have requested strict checking.
Host key verification failed.
```

To solve this, remove old key by running

```bash
$ ssh-keygen -R github.com
```

Read more: https://github.blog/2023-03-23-we-updated-our-rsa-ssh-host-key/
