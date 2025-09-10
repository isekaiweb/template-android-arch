#!/usr/bin/env bash

set -e

# Bash 4+ check
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
  echo "You need at least bash 4 to run this script."
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: bash customizer.sh my.new.package [ApplicationName]" >&2
  exit 2
fi

PACKAGE=$1
APPNAME=${2:-Template}
APPNAME_LOWER=${APPNAME,,}
SUBDIR=${PACKAGE//.//}
BACKUP_DIR=".customizer_backup_$(date +%s)"

echo "Creating backup at $BACKUP_DIR..."
mkdir "$BACKUP_DIR"
cp -a . "$BACKUP_DIR"

restore_backup() {
  echo "Restoring backup..."
  rm -rf ./* ./.??*
  cp -a "$BACKUP_DIR"/. .
  rm -rf "$BACKUP_DIR"
  echo "Reverted to original state."
  exit 99
}

trap restore_backup ERR

echo "Step 1: Move and restructure source folders..."
for n in $(find . -type d -path '*/src/main'); do
  mkdir -p "$n/kotlin/$SUBDIR"
  if [ -d "$n/kotlin/com/example/template" ]; then
    mv "$n/kotlin/com/example/template"/* "$n/kotlin/$SUBDIR"
    rm -rf "$n/kotlin/com"
  fi
done

echo "Step 2: Replace package and import statements in Kotlin files..."
find . -type f -name "*.kt" -exec sed -i.bak \
  -e "s/package com\.example\.template/package $PACKAGE/g" \
  -e "s/import com\.example\.template/import $PACKAGE/g" \
  -e "s/apply(plugin = \"template\.android\.lint\")/apply(plugin = \"${APPNAME_LOWER}.android.lint\")/g" \
  -e "s/Template/${APPNAME}/g" \
  -e "s/template/${APPNAME_LOWER}/g" \
  {} +

echo "Step 3: Replace references in Gradle scripts..."
find . -type f -name "*.kts" -exec sed -i.bak \
  -e "s/com\.example\.template/$PACKAGE/g" \
  -e "s/libs\.plugins\.template/libs.plugins.$APPNAME_LOWER/g" \
  -e "s/Template/${APPNAME}/g" \
  -e "s/template/${APPNAME_LOWER}/g" \
  {} +

echo "Step 4: Replace plugin keys/IDs in TOML files..."
find . -type f -name "*.toml" -exec sed -i.bak \
  -e "s/template-/$APPNAME_LOWER-/g" \
  -e "s/template\./$APPNAME_LOWER./g" \
  -e "s/Template/${APPNAME}/g" \
  -e "s/template/${APPNAME_LOWER}/g" \
  {} +

echo "Step 5: Rename files and folders containing 'Template' or 'template'..."
find . -depth \( -name '*Template*' -o -name '*template*' \) -print0 | while IFS= read -r -d '' path; do
  new="$(dirname "$path")/$(basename "$path" | sed "s/Template/${APPNAME}/g;s/template/${APPNAME_LOWER}/g")"
  if [[ "$path" != "$new" && -e "$path" ]]; then
    mv "$path" "$new"
  fi
done

echo "Step 6: Rename rootProject.name in settings.gradle.kts..."
sed -i.bak "s/rootProject\.name = \".*\"/rootProject.name = \"${APPNAME}\"/g" settings.gradle.kts

echo "Step 7: Rename app class and references if needed..."
if [[ $APPNAME != TemplateApp ]]; then
  find . -type f \( -name "TemplateApp.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) -exec sed -i.bak "s/TemplateApp/${APPNAME}App/g" {} +
  find . -name "TemplateApp.kt" -print0 | while IFS= read -r -d '' file; do
    newfile="$(dirname "$file")/${APPNAME}App.kt"
    if [[ "$file" != "$newfile" && -e "$file" ]]; then
      mv "$file" "$newfile"
    fi
  done
fi

echo "Step 8: Cleanup backup files..."
find . -name "*.bak" -type f -delete

echo "Step 9: Remove README, script, and .git directory..."
rm -rf README.md customizer.sh .git/

rm -rf "$BACKUP_DIR"
echo "All done! Your project has been customized."
