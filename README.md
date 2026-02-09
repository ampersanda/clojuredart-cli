# ClojureDart-CLI/CLJDS

[![pub package](https://img.shields.io/pub/v/cljds.svg)](https://pub.dev/packages/cljds)

A CLI tool for generating ClojureDart projects based on the official quick-start guides:

- [Dart quick-start](https://github.com/Tensegritics/ClojureDart/blob/main/doc/quick-start.md)
- [Flutter quick-start](https://github.com/Tensegritics/ClojureDart/blob/main/doc/flutter-quick-start.md)

## Installing

```shell
$ dart pub global activate cljds 2.1.0
```

## Prerequisites

- [Clojure CLI](https://clojure.org/guides/install_clojure) (`clj`)
- [Dart SDK](https://dart.dev/get-dart) (>=3.0.0)
- Git with SSH or HTTPS access to GitHub

## Usage

Interactive mode (prompts for project type and name):

```shell
$ cljds
```

Direct commands:

```shell
$ cljds dart project-name       # generate plain Dart project
$ cljds flutter project-name    # generate Flutter project
```

### Flags

```
-h, --help       Print usage information
    --version    Print the current version
-o, --output     Directory to create the project in
```

### Examples

```shell
$ cljds --help
$ cljds --version
$ cljds dart my_app
$ cljds flutter my_app -o /tmp
$ cljds dart                    # prompts for project name
```

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
