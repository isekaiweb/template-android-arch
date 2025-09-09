#!/usr/bin/env bash

# Check for minimum bash version
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
APPNAME=${2:-TemplateApp}
APPNAME_LOWER=${APPNAME,,}
SUBDIR=${PACKAGE//.//}

echo "Starting project customization..."
echo "Target package: $PACKAGE"
echo "Application name: $APPNAME"

# Move Kotlin source files to new package directory
for n in $(find . -type d -path '*/src/main'); do
  if [ -d "$n/kotlin/com/example/template" ]; then
    echo "Renaming $n/kotlin/com/example/template to $n/kotlin/$SUBDIR"
    mv "$n/kotlin/com/example/template" "$n/kotlin/$SUBDIR"
    # Remove empty parent directories
    rmdir --ignore-fail-on-non-empty "$n/kotlin/com/example" 2>/dev/null || true
    rmdir --ignore-fail-on-non-empty "$n/kotlin/com" 2>/dev/null || true
  fi
done

# Update package and import statements in Kotlin files
echo "Updating package and import statements in .kt files..."
find . -type f -name "*.kt" -exec sed -i.bak \
  -e "s/package com\.example\.template/package $PACKAGE/g" \
  -e "s/import com\.example\.template/import $PACKAGE/g" {} \;

# Update plugin application in Kotlin files
echo "Updating plugin application in .kt files..."
find . -type f -name "*.kt" -exec sed -i.bak \
  -e "s/apply(plugin = \"template\.android\.lint\")/apply(plugin = \"${APPNAME_LOWER}.android.lint\")/g" {} \;

# Update references in Gradle scripts
echo "Updating references in .kts files..."
find . -type f -name "*.kts" -exec sed -i.bak \
  -e "s/com\.example\.template/$PACKAGE/g" \
  -e "s/libs\.plugins\.template/libs.plugins.$APPNAME_LOWER/g" \
  -e "s/apply(plugin = \"template\./apply(plugin = \"${APPNAME_LOWER}./g" {} \;

# Update plugin keys/IDs in TOML files
echo "Updating plugin keys/IDs in .toml files..."
find . -type f -name "*.toml" -exec sed -i.bak \
  -e "s/template-/$APPNAME_LOWER-/g" \
  -e "s/template\./$APPNAME_LOWER./g" {} \;

# Rename app references if needed
if [[ $APPNAME != TemplateApp ]]; then
  echo "Renaming app references from TemplateApp to ${APPNAME}App..."
  find . -type f \( -name "TemplateApp.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) \
    -exec sed -i.bak "s/TemplateApp/${APPNAME}App/g" {} \;
  find . -name "TemplateApp.kt" -exec bash -c 'mv "$0" "${0/TemplateApp/${1}App}"' {} "$APPNAME" \; 2>/dev/null || true
fi

# Clean up backup files
echo "Cleaning up backup files..."
find . -name "*.bak" -type f -delete

# Remove template and meta files
echo "Removing template and meta files..."
rm -rf README.md customizer.sh .git/

echo "Project customization complete!"
