[private]
default:
    just --list

run:
    flutter run

generate-code:
    flutter pub run build_runner build --delete-conflicting-outputs
    flutter gen-l10n

generate-icons:
    flutter pub run flutter_launcher_icons