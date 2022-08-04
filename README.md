# CLJDS

ClojureDart Project Generation made using ClojureDart

to make executable

```shell
$ clj -M -m cljd.build compile && dart compile exe -o cljds bin/cljds.dart && dart pub global activate --source path .
```

and run (from anywhere)

```shell
$ cljds projectname
```
