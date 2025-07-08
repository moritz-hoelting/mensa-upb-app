# Mensa@UPB App

Cross-platform application to view the menu of the canteens of the Paderborn University.

## Development

### Requirements

Install instructions for flutter and all required dependencies can be found at https://docs.flutter.dev/get-started/install.

### Commands

- Use `flutter pub get` to install dependencies
- Use `just generate-code generate-icons` for code- and icon-generation
- Use `just run` to start the app
- Use `flutter build ...` to build the app

### Configuration

Local configuration has to be done using a `.env` file in the root directory. The following keys are required

- `MENSA_API_URL`: The URL to an instance of the Mensa API.

Optional options are

- `FUNDING_URL`: A URL for supporting app development
- `APP_AUTHOR`: The name displayed as app author
- `REPOSITORY_URL`: The URL to the git repository