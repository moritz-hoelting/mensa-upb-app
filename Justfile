[private]
default:
    just --list

run:
    flutter run

generate-code:
    dart run build_runner build --delete-conflicting-outputs
    flutter gen-l10n

generate-icons:
    dart run flutter_launcher_icons