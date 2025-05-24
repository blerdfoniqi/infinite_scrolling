# Infinite Scrolling

A Flutter application demonstrating an infinite scrolling list view fetching data from an API, a pull-to-refresh mechanism, custom image caching, and comprehensive widget and unit tests.

## Features

- **Infinite Scrolling**: Automatically fetches and loads the next page of users when the list is scrolled to the bottom.
- **Pull-to-Refresh**: Allows users to refresh the list and start over from the first page by dragging down from the top.
- **Custom Image Cache**: Efficiently caches fetched images for seamless scrolling and performance.
- **Clean Architecture**: Separates models, services, and UI components into easy-to-manage subdirectories.
- **Robust Testing**: Comprehensive test coverage including `WidgetTester` tests for scrolling and interactions.

## Project Structure

- `lib/models/`: Contains the data models used by the API (like `User`).
- `lib/services/`: Services such as `ApiService` and `CustomImageCache` to handle data fetching and resource caching.
- `lib/ui/screens/`: Main standalone screens of the application (`UserListScreen`).
- `lib/ui/widgets/`: Reusable, atomic widgets across the app (`UserListItem`).
- `test/`: Contains corresponding tests for UI components, navigation scenarios, and data parsing logic.

## Running the App

1. Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2. Clone this repository locally or run within your IDE.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the project:
   ```bash
   flutter run
   ```

## Running Tests

Execute the testing suite to check functionality and regression tests:
```bash
flutter test
```
