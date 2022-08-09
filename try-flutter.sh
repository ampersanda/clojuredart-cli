#!/bin/bash

rm -rf quickstart-flutter
clj -M -m cljd.build compile
dart run bin/cljds.dart flutter quickstart-flutter

