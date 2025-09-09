# Verify bash version. macOS comes with bash 3 preinstalled.
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]
then
  echo "You need at least bash 4 to run this script."
  exit 1
fi

# exit when any command fails
set -e

if [[ $# -lt 1 ]]; then
   echo "Usage: bash customizer.sh my.new.package [ApplicationName]" >&2
   exit 2
fi

PACKAGE=$1
APPNAME=$2
APPNAME_LOWER=${APPNAME,,} # lowercase app name
SUBDIR=${PACKAGE//.//} # Replaces . with /

for n in $(find . -type d \( -path '*/src/androidTest' -or -path '*/src/main' -or -path '*/src/test' \) )
do
  echo "Creating $n/java/$SUBDIR"
  mkdir -p $n/java/$SUBDIR
  echo "Moving files to $n/java/$SUBDIR"
  mv $n/java/android/template/* $n/java/$SUBDIR
  echo "Removing old $n/java/android/template"
  rm -rf mv $n/java/android
done

# Rename package and imports
echo "Renaming packages to $PACKAGE"
find ./ -type f -name "*.kt" -exec sed -i.bak "s/package android.template/package $PACKAGE/g" {} \;
find ./ -type f -name "*.kt" -exec sed -i.bak "s/import android.template/import $PACKAGE/g" {} \;

# Gradle files
find ./ -type f -name "*.kts" -exec sed -i.bak "s/android.template/$PACKAGE/g" {} \;

# Rename plugin IDs and keys in TOML files (template → app name lowercase)


echo "Renaming template plugin keys/IDs in TOML files to $APPNAME_LOWER"
find ./ -type f -name "*.toml" -exec sed -i.bak "s/template-/$APPNAME_LOWER-/g" {} \;
find ./ -type f -name "*.toml" -exec sed -i.bak "s/template\./$APPNAME_LOWER./g" {} \;

echo "Cleaning up"
find . -name "*.bak" -type f -delete

# Rename files
echo "Renaming files to $DATAMODEL"
find ./ -name "*MyModel*.kt" | sed "p;s/MyModel/${DATAMODEL^}/" | tr '\n' '\0' | xargs -0 -n 2 mv
# module names
if [[ -n $(find ./ -name "*-mymodel") ]]
then
  echo "Renaming modules to $DATAMODEL"
  find ./ -name "*-mymodel" -type d  | sed "p;s/mymodel/${DATAMODEL,,}/" |  tr '\n' '\0' | xargs -0 -n 2 mv
fi
# directories
echo "Renaming directories to $DATAMODEL"
find ./ -name "mymodel" -type d  | sed "p;s/mymodel/${DATAMODEL,,}/" |  tr '\n' '\0' | xargs -0 -n 2 mv

# Rename app
if [[ $APPNAME != MyApplication ]]
then
    echo "Renaming app to $APPNAME"
    find ./ -type f \( -name "MyApplication.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) -exec sed -i.bak "s/MyApplication/$APPNAME/g" {} \;
    find ./ -name "MyApplication.kt" | sed "p;s/MyApplication/$APPNAME/" | tr '\n' '\0' | xargs -0 -n 2 mv
    find . -name "*.bak" -type f -delete
fi

# Remove additional files
echo "Removing additional files"
rm -rf .google/
rm -rf .github/
rm -rf CONTRIBUTING.md LICENSE README.md customizer.sh
rm -rf .git/
echo "Done!"