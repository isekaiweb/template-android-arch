#!/usr/bin/env bash

# Verify bash version (macOS ships Bash 3 by default)
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]
then
  echo "You need at least bash 4 to run this script."
  exit 1
fi

# Exit on any error
set -e

# Validate arguments
if [[ $# -lt 2 ]]; then
   echo "Usage: bash customizer.sh com.example.template MyNewDataModel [ApplicationName]" >&2
   exit 2
fi

NEW_PACKAGE=$1
DATAMODEL=$2
APPNAME=$3

OLD_PACKAGE="com.example.template"
OLD_PACKAGE_PATH="com/example/template"
NEW_PACKAGE_PATH=${NEW_PACKAGE//.//}
FOLDERNAME=${NEW_PACKAGE##*.} # last part of new package (e.g. myapp)

echo "Customizing project..."
echo "Old package: $OLD_PACKAGE"
echo "New package: $NEW_PACKAGE"
echo "New folder name: $FOLDERNAME"
echo "Data model: $DATAMODEL"
echo "Application name: ${APPNAME:-TemplateApp}"

# 1. Move source files into new package structure
for n in $(find . -type d \( -path '*/src/androidTest' -or -path '*/src/main' -or -path '*/src/test' \) )
do
  echo "Creating $n/java/$NEW_PACKAGE_PATH"
  mkdir -p "$n/java/$NEW_PACKAGE_PATH"
  echo "Moving files from $n/java/$OLD_PACKAGE_PATH to $n/java/$NEW_PACKAGE_PATH"
  mv "$n/java/$OLD_PACKAGE_PATH"/* "$n/java/$NEW_PACKAGE_PATH" 2>/dev/null || true
  echo "Removing old $n/java/$OLD_PACKAGE_PATH"
  rm -rf "$n/java/com/example"
done

# 2. Replace package/imports
echo "Replacing package and imports..."
find ./ -type f -name "*.kt" -exec sed -i.bak "s|$OLD_PACKAGE|$NEW_PACKAGE|g" {} \;

# 3. Replace in Gradle files
find ./ -type f -name "*.kts" -exec sed -i.bak "s|$OLD_PACKAGE|$NEW_PACKAGE|g" {} \;

# 4. Rename plugins (template → folder name)
echo "Renaming plugin IDs with 'template' to $FOLDERNAME"
find ./ -type f -name "*.kts" -exec sed -i.bak "s/template-/$FOLDERNAME-/g" {} \;
find ./ -type f -name "*.kts" -exec sed -i.bak "s/template\./$FOLDERNAME./g" {} \;

# 5. Rename model
echo "Renaming model to $DATAMODEL"
find ./ -type f -name "*.kt" -exec sed -i.bak "s/MyModel/${DATAMODEL^}/g" {} \;
find ./ -type f -name "*.kt" -exec sed -i.bak "s/myModel/${DATAMODEL,}/g" {} \;
find ./ -type f -name "*.kt*" -exec sed -i.bak "s/mymodel/${DATAMODEL,,}/g" {} \;

# 6. Rename files
echo "Renaming files to $DATAMODEL"
find ./ -name "*MyModel*.kt" | sed "p;s/MyModel/${DATAMODEL^}/" | tr '\n' '\0' | xargs -0 -n 2 mv

# 7. Rename modules and directories
if [[ -n $(find ./ -name "*-mymodel") ]]
then
  echo "Renaming modules to $DATAMODEL"
  find ./ -name "*-mymodel" -type d | sed "p;s/mymodel/${DATAMODEL,,}/" | tr '\n' '\0' | xargs -0 -n 2 mv
fi
echo "Renaming directories containing 'mymodel'"
find ./ -name "mymodel" -type d | sed "p;s/mymodel/${DATAMODEL,,}/" | tr '\n' '\0' | xargs -0 -n 2 mv

# 8. Rename application if given
if [[ -n $APPNAME && $APPNAME != TemplateApp ]]
then
    echo "Renaming app to $APPNAME"
    find ./ -type f \( -name "TemplateApp.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) \
      -exec sed -i.bak "s/TemplateApp/$APPNAME/g" {} \;
    find ./ -name "TemplateApp.kt" | sed "p;s/TemplateApp/$APPNAME/" | tr '\n' '\0' | xargs -0 -n 2 mv
fi

# 9. Cleanup
echo "Cleaning up..."
find . -name "*.bak" -type f -delete
rm -rf README.md customizer.sh .git/

echo "Done!"
