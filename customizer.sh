#!/usr/bin/env bash

# Check for Bash version 4 or higher
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
  echo "You need at least bash 4 to run this script."
  exit 1
fi

set -e

# Check for required arguments
if [[ $# -lt 1 ]]; then
  echo "Usage: bash customizer.sh my.new.package [ApplicationName]" >&2
  exit 2
fi

PACKAGE=$1
APPNAME=${2:-Template}
APPNAME_LOWER=${APPNAME,,}
SUBDIR=${PACKAGE//.//}

echo "Step 1: Moving and restructuring source folders..."
for n in $(find . -type d -path '*/src/main'); do
  echo "Creating directory: $n/kotlin/$SUBDIR"
  mkdir -p "$n/kotlin/$SUBDIR"

  if [ -d "$n/kotlin/com/example/template" ]; then
    echo "Moving all files and folders from $n/kotlin/com/example/template to $n/kotlin/$SUBDIR"
    mv "$n/kotlin/com/example/template"/* "$n/kotlin/$SUBDIR"
    echo "Removing old template directory: $n/kotlin/com"
    rm -rf "$n/kotlin/com"
  fi
done

echo "Step 2: Renaming package declarations in Kotlin files..."
find ./ -type f -name "*.kt" -exec sed -i.bak "s/package com\.example\.template/package $PACKAGE/g" {} \;
find ./ -type f -name "*.kt" -exec sed -i.bak "s/import com\.example\.template/import $PACKAGE/g" {} \;

echo "Step 3: Updating package references in Gradle scripts..."
find ./ -type f -name "*.kts" -exec sed -i.bak "s/com\.example\.template/$PACKAGE/g" {} \;

echo "Step 4: Renaming template plugin keys/IDs in TOML files..."
find ./ -type f -name "*.toml" -exec sed -i.bak "s/template-/$APPNAME_LOWER-/g" {} \;
find ./ -type f -name "*.toml" -exec sed -i.bak "s/template\./$APPNAME_LOWER./g" {} \;

echo "Step 5: Updating plugin references from 'template' to '$APPNAME_LOWER'..."
find ./ -type f -name "*.kts" -exec sed -i.bak "s/libs\.plugins\.template/libs.plugins.$APPNAME_LOWER/g" {} \;
find ./ -type f -name "*.kt" -exec sed -i.bak "s/apply(plugin = \"template\.android\.lint\")/apply(plugin = \"${APPNAME_LOWER}.android.lint\")/g" {} \;

echo "Step 6: Replacing 'Template' and 'template' in all files..."
find ./ -type f -exec sed -i.bak "s/Template/${APPNAME}/g" {} \;
find ./ -type f -exec sed -i.bak "s/template/${APPNAME_LOWER}/g" {} \;

echo "Step 6b: Renaming files and folders containing 'Template' or 'template'..."
find . -depth -name '*Template*' -exec bash -c '
  for path; do
    new="$(dirname "$path")/$(basename "$path" | sed "s/Template/'"${APPNAME}"'/g")"
    if [[ -n "$new" && "$path" != "$new" && -e "$path" ]]; then
      echo "Renaming $path to $new"
      mv "$path" "$new"
    fi
  done
' bash {} +

find . -depth -name '*template*' -exec bash -c '
  for path; do
    new="$(dirname "$path")/$(basename "$path" | sed "s/template/'"${APPNAME_LOWER}"'/g")"
    if [[ -n "$new" && "$path" != "$new" && -e "$path" ]]; then
      echo "Renaming $path to $new"
      mv "$path" "$new"
    fi
  done
' bash {} +

echo "Step 7: Renaming rootProject.name in settings.gradle.kts..."
sed -i.bak "s/rootProject\.name = \".*\"/rootProject.name = \"${APPNAME}\"/g" settings.gradle.kts

echo "Step 8: Cleaning up backup files..."
find . -name "*.bak" -type f -delete

if [[ $APPNAME != TemplateApp ]]; then
  echo "Step 9: Renaming app class and references to $APPNAME"
  find ./ -type f \( -name "TemplateApp.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) -exec sed -i.bak "s/TemplateApp/${APPNAME}App/g" {} \;
  find ./ -name "TemplateApp.kt" | sed "p;s/TemplateApp/${APPNAME}App/" | tr '\n' '\0' | xargs -0 -n 2 mv
  find . -name "*.bak" -type f -delete
fi

echo "Step 10: Removing README, script, and .git directory..."
rm -rf README.md customizer.sh
rm -rf .git/

echo "All done! Your project has been customized."
