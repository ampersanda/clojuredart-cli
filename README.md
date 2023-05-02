# ClojureDart-CLI/CLJDS

[![pub package](https://img.shields.io/pub/v/cljds.svg)](https://pub.dev/packages/cljds)

ClojureDart Project Generation made using ClojureDart, based on steps from 

Dart
> https://github.com/Tensegritics/ClojureDart/blob/main/doc/quick-start.md.

Flutter
> https://github.com/Tensegritics/ClojureDart/blob/main/doc/flutter-quick-start.md

## Installing

```shell
$ dart pub global activate cljds
```

## Usage

TLDR; (with selection and input)

```shell
$ cljds
```

You can also use arguments to create project 

```shell
$ cljds dart project-name # for plain Dart project
$ cljds flutter project-name # for Flutter project
```

## Troubleshooting
- Got "Cannot rename file to" error

```shell
Warming up `.clojuredart/libs-info.edn` (helps us emit better code)

Adding dev dependencies
Resolving dependencies... 
< _fe_analyzer_shared 38.0.0 (was 44.0.0) (44.0.0 available)
< analyzer 3.4.1 (was 4.4.0) (4.4.0 available)
Changed 2 dependencies!

Fetching dependencies
Resolving dependencies... 
  _fe_analyzer_shared 38.0.0 (44.0.0 available)
  analyzer 3.4.1 (4.4.0 available)
Got dependencies!

Dumping type information (it may take a while)
Cannot rename file to './.dart_tool/pub/bin/quickstart/analyzer.dart-2.18.0-edge.572f24882f2c344f9f95b14091a7ac2cb142f9de.snapshot', path = './.dart_tool/pub/incremental/quickstart/tmpLbc3EN/analyzer.dart.incremental.dill.incremental.dill' (OS Error: No such file or directory, errno = 2)
```

To solve this, replace `sdk` inside `pubspec.yaml` to

```yaml
sdk: '>=2.17.3 <3.0.0'
```

---

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
