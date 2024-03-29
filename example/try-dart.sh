#!/bin/bash

rm -rf quickstart

cd ..
clj -M:cljd compile

cd example || exit

dart run ../bin/cljds.dart dart quickstart

cd quickstart || exit

clj -M:cljd compile && dart run bin/quickstart.dart
