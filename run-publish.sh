#!/bin/bash

# remove lib folder to avoid removed files to be still included
rm -rf lib
rm -rf example/quickstart
rm -rf example/quickstart_flutter
rm -rf example/hello_world

# compile cljd to dart
clj -M:cljd compile

# uncomment to reset ignores
sed -i '' 's|#lib|lib|g' .gitignore
sed -i '' 's|#bin|bin|g' .gitignore

# comment lib and folder so it be included on publish
sed -i '' 's|lib|#lib|g' .gitignore
sed -i '' 's|bin|#bin|g' .gitignore

# publish to https://pub.dev/packages/cljds
dart pub publish

if [ $? -eq 65 ]
then
  # uncomment to ignore files once more
  sed -i '' 's|#lib|lib|g' .gitignore
  sed -i '' 's|#bin|bin|g' .gitignore
else
  # uncomment to ignore files once more
  sed -i '' 's|#lib|lib|g' .gitignore
  sed -i '' 's|#bin|bin|g' .gitignore
fi
