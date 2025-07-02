[private]
default:
    just --list

run:
    flutter run

generate-code:
    dart run build_runner build --delete-conflicting-outputs