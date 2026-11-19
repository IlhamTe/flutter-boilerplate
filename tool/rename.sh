#!/usr/bin/env bash
# Renames the app name, the bundle id and/or the Dart package. Only the values you give change.
#
# Interactive: `make rename` asks for each value. Press Enter to keep the current one.
# Non-interactive (CI): set APP_NAME, BUNDLE_ID and/or PACKAGE_NAME, e.g. `make rename BUNDLE_ID=com.company.app`.
#
# The current values are read from the project, so the script can run more than once.
set -euo pipefail
cd "$(dirname "$0")/.."

GRADLE=android/app/build.gradle.kts
MANIFEST=android/app/src/main/AndroidManifest.xml
PBXPROJ=ios/Runner.xcodeproj/project.pbxproj
PLIST=ios/Runner/Info.plist
KOTLIN_ROOT=android/app/src/main/kotlin

OLD_ANDROID_ID=$(sed -nE 's/.*applicationId = "([^"]+)".*/\1/p' "$GRADLE")
OLD_IOS_ID=$(sed -nE 's/.*PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);.*/\1/p' "$PBXPROJ" | grep -v RunnerTests | head -1)
OLD_PACKAGE=$(sed -nE 's/^name: (.+)$/\1/p' pubspec.yaml)
OLD_APP_NAME=$(perl -0ne 'print $1 if /<key>CFBundleDisplayName<\/key>\s*<string>([^<]*)/' "$PLIST" |
  perl -pe 's/&quot;/"/g; s/&lt;/</g; s/&gt;/>/g; s/&amp;/&/g')

APP_NAME="${APP_NAME:-}"
BUNDLE_ID="${BUNDLE_ID:-}"
PACKAGE_NAME="${PACKAGE_NAME:-}"

# Android applicationId rules (the stricter of the two platforms).
BUNDLE_ID_RULE='lowercase segments like com.company.my_app'
valid_bundle_id() { [[ "$1" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]]; }
PACKAGE_RULE='lowercase letters, digits and _, starting with a letter'
valid_package() { [[ "$1" =~ ^[a-z][a-z0-9_]*$ ]]; }
valid_any() { true; }

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }

# ask <var> <label> <current> <validator> <rule>: an empty answer keeps the current value.
ask() {
  local answer
  while true; do
    read -r -p "$2 [$3]: " answer || answer=''
    answer=$(trim "$answer")
    if [[ -z "$answer" ]] || "$4" "$answer"; then break; fi
    echo "  Not valid: use $5. Press Enter to keep the current value." >&2
  done
  printf -v "$1" '%s' "$answer"
}

INTERACTIVE=false
if [[ -z "$APP_NAME$BUNDLE_ID$PACKAGE_NAME" && -t 0 ]]; then
  INTERACTIVE=true
  echo 'Rename the app. Every question is optional: press Enter to keep the current value.'
  ask APP_NAME 'App name' "$OLD_APP_NAME" valid_any ''
  ask BUNDLE_ID 'Bundle ID' "$OLD_ANDROID_ID" valid_bundle_id "$BUNDLE_ID_RULE"
  ask PACKAGE_NAME 'Dart package name' "$OLD_PACKAGE" valid_package "$PACKAGE_RULE"
else
  if [[ -n "$BUNDLE_ID" ]] && ! valid_bundle_id "$BUNDLE_ID"; then
    echo "BUNDLE_ID '$BUNDLE_ID' is not valid: use $BUNDLE_ID_RULE" >&2
    exit 1
  fi
  if [[ -n "$PACKAGE_NAME" ]] && ! valid_package "$PACKAGE_NAME"; then
    echo "PACKAGE_NAME '$PACKAGE_NAME' is not valid: use $PACKAGE_RULE" >&2
    exit 1
  fi
fi

# A value equal to the current one is no change.
[[ "$APP_NAME" == "$OLD_APP_NAME" ]] && APP_NAME=''
[[ "$BUNDLE_ID" == "$OLD_ANDROID_ID" ]] && BUNDLE_ID=''
[[ "$PACKAGE_NAME" == "$OLD_PACKAGE" ]] && PACKAGE_NAME=''

if [[ -z "$APP_NAME$BUNDLE_ID$PACKAGE_NAME" ]]; then
  echo 'Nothing to change.'
  exit 0
fi

# iOS bundle ids allow letters, digits, '-' and '.', not '_'.
IOS_BUNDLE_ID="${BUNDLE_ID//_/-}"

echo
echo 'Changes:'
[[ -n "$APP_NAME" ]] && echo "  App name:          $OLD_APP_NAME -> $APP_NAME"
[[ -n "$BUNDLE_ID" ]] && echo "  Bundle ID:         Android $OLD_ANDROID_ID -> $BUNDLE_ID, iOS $OLD_IOS_ID -> $IOS_BUNDLE_ID"
[[ -n "$PACKAGE_NAME" ]] && echo "  Dart package name: $OLD_PACKAGE -> $PACKAGE_NAME"
if $INTERACTIVE; then
  read -r -p 'Apply? [y/N]: ' confirm || confirm=''
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo 'Cancelled. Nothing changed.'
    exit 0
  fi
fi

# Replace literal text (no regex) in files. Values go through env vars, so quotes in them are safe.
replace() { # replace <old> <new> <file>...
  OLD="$1" NEW="$2" perl -pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' "${@:3}"
}
set_plist() { # set_plist <key> <xml-escaped value>
  KEY="$1" VALUE="$2" perl -0pi -e 's/(<key>\Q$ENV{KEY}\E<\/key>\s*<string>)[^<]*/$1$ENV{VALUE}/' "$PLIST"
}
# Escape with perl: in bash 5.2+ an '&' in ${var//x/y} inserts the matched text.
xml_escape() { printf '%s' "$1" | perl -pe 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g; s/"/&quot;/g'; }
json_escape() { printf '%s' "$1" | perl -pe 's/\\/\\\\/g; s/"/\\"/g'; }

if [[ -n "$APP_NAME" ]]; then
  APP_NAME_XML=$(xml_escape "$APP_NAME")
  VALUE="$APP_NAME_XML" perl -pi -e 's/android:label="[^"]*"/android:label="$ENV{VALUE}"/' "$MANIFEST"
  set_plist CFBundleDisplayName "$APP_NAME_XML"
  APP_NAME_JSON=$(json_escape "$APP_NAME")
  for f in lib/i18n/*.i18n.json; do
    VALUE="$APP_NAME_JSON" perl -pi -e 's/("appName":\s*)"(?:[^"\\]|\\.)*"/$1"$ENV{VALUE}"/' "$f"
  done
fi

if [[ -n "$BUNDLE_ID" ]]; then
  replace "\"$OLD_ANDROID_ID\"" "\"$BUNDLE_ID\"" "$GRADLE"
  # Move MainActivity to the folder of the new package.
  OLD_DIR="$KOTLIN_ROOT/${OLD_ANDROID_ID//.//}"
  NEW_DIR="$KOTLIN_ROOT/${BUNDLE_ID//.//}"
  mkdir -p "$NEW_DIR"
  mv "$OLD_DIR"/* "$NEW_DIR"/
  find "$KOTLIN_ROOT" -type d -empty -delete
  replace "package $OLD_ANDROID_ID" "package $BUNDLE_ID" "$NEW_DIR"/*.kt
  # Also renames RunnerTests (<id>.RunnerTests).
  replace "= $OLD_IOS_ID" "= $IOS_BUNDLE_ID" "$PBXPROJ"
fi

if [[ -n "$PACKAGE_NAME" ]]; then
  replace "name: $OLD_PACKAGE" "name: $PACKAGE_NAME" pubspec.yaml
  grep -rl --include='*.dart' "package:$OLD_PACKAGE/" lib test 2>/dev/null | while read -r f; do
    replace "package:$OLD_PACKAGE/" "package:$PACKAGE_NAME/" "$f"
  done
  set_plist CFBundleName "$PACKAGE_NAME"
fi

echo
echo 'Done. Next: make generate'
