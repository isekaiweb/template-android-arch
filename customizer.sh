#!/usr/bin/env bash

# Verify bash version. macOS comes with bash 3 preinstalled.
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]
then
  echo "You need at least bash 4 to run this script."
  exit 1
fi

set -e

if [[ $# -lt 1 ]]; then
   echo "Usage: bash customizer.sh my.new.package [ApplicationName]" >&2
   exit 2
fi

PACKAGE=$1
APPNAME=$2
APPNAME_LOWER=${APPNAME,,}
SUBDIR=${PACKAGE//.//}

for n in $(find . -type d -path '*/src/main')
do
  echo "Creating $n/kotlin/$SUBDIR"
  mkdir -p "$n/kotlin/$SUBDIR"

  echo "Moving files to $n/kotlin/$SUBDIR"
  mv "$n/kotlin/com/example/template"/* "$n/kotlin/$SUBDIR"

  echo "Removing old $n/kotlin/com/example/template"
  rm -rf "$n/kotlin/android"
done

echo "Renaming packages to $PACKAGE"
find ./ -type f -name "*.kt" -exec sed -i.bak "s/package com.example.template/package $PACKAGE/g" {} \;
find ./ -type f -name "*.kt" -exec sed -i.bak "s/import com.example.template/import $PACKAGE/g" {} \;

find ./ -type f -name "*.kts" -exec sed -i.bak "s/com.example.template/$PACKAGE/g" {} \;

echo "Renaming template plugin keys/IDs in TOML files to $APPNAME_LOWER"
find ./ -type f -name "*.toml" -exec sed -i.bak "s/template-/$APPNAME_LOWER-/g" {} \;
find ./ -type f -name "*.toml" -exec sed -i.bak "s/template\./$APPNAME_LOWER./g" {} \;

echo "Cleaning up"
find . -name "*.bak" -type f -delete

if [[ $APPNAME != TemplateApp ]]
then
    echo "Renaming app to $APPNAME"
    find ./ -type f \( -name "TemplateApp.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) -exec sed -i.bak "s/TemplateApp/$APPNAME/g" {} \;
    find ./ -name "TemplateApp.kt" | sed "p;s/TemplateApp/$APPNAME/" | tr '\n' '\0' | xargs -0 -n 2 mv
    find . -name "*.bak" -type f -delete
fi

echo "Removing additional files"
rm -rf .google/
rm -rf .github/
rm -rf CONTRIBUTING.md LICENSE README.md customizer.sh
rm -rf .git/
echo "Done!"