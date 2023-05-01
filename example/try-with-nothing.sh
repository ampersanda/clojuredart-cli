#!/bin/bash

rm -rf quickstart-flutter

cd ..
clj -M:cljd compile

cd example || exit

dart run ../bin/cljds.dart

