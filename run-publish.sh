#!/bin/bash

clj -M -m cljd.build compile
dart pub publish
