#!/bin/bash

clj -M -m cljd.build compile
dart run bin/cljds.dart dart quickstart
