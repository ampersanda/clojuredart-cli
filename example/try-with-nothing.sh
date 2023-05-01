#!/bin/bash

rm -rf quickstart-flutter

cd ..
clj -M -m cljd.build compile

cd example || exit

dart run ../bin/cljds.dart

