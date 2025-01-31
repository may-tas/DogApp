# TOT APP - Dog Information and Live Location Tracking

TOT APP is a Flutter application that provides users with information about dogs fetched from the [FreeTestAPI for Dogs](https://freetestapi.com/apis/dogs) and allows them to track their live location during journeys. The app features dog details, location tracking with source and destination markers, local database storage, and a user-friendly interface.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [How to Run](#how-to-run)
- [Code Structure](#code-structure)
- [Screenshots](#screenshots)
- [API-KEY](#api-key)

## Overview

TOT APP combines two main functionalities: fetching and displaying dog information from a public API and providing live location tracking capabilities. Users can browse dog details, save their favorites, and record their journeys with source and destination markers displayed on a map. The app utilizes local storage to persist saved dog information and journey history.

## Features

- **Dog API Integration:** Fetches dog data (name, breed, image, etc.) from the Dog API and displays it in a list. Detailed information is available on a separate screen.
- **Local Database:** Uses sqflite to store favorite dog details and journey history for offline access.
- **Live Location Tracking:** Tracks the user's location in real-time, displaying their movement on a map. Records the source and destination of the journey.
- **Search Functionality:** Allows users to search the dog list by name or breed.
- **User-Friendly Interface:** A clean and intuitive UI makes it easy to navigate between features.
- **State Management:** Employs Cubit for efficient state management.

## Folder Structure
```
lib/
├── cubit/
│ ├── dog_cubit.dart
│ ├── dog_state.dart
│ ├── history_cubit.dart
│ ├── history_state.dart
│ ├── tracking_cubit.dart
│ └── tracking_state.dart
├── models/
│ ├── dog_model.dart
│ └── journey_model.dart
├── services/
│ ├── database_service.dart
│ ├── dog_api_service.dart
│ └── location_service.dart
├── views/
│ ├── screens/
│ │ ├── dog_detail_screen.dart
│ │ ├── dog_list_screen.dart
│ │ ├── history_screen.dart
│ │ ├── home_screen.dart
│ │ └── tracking_screen.dart
│ └── widgets/
│ ├── dog_detail_screen/
│ │ ├── dog_details.dart
│ │ └── favourite_button.dart
│ └── history_screen/
│ ├── empty_state_widget.dart
│ └── error_state_widget.dart
├── main.dart
```

## Dependencies

```yaml
dependencies:
  cupertino_icons: ^1.0.8
  http: ^1.3.0
  sqflite: ^2.4.1
  path: ^1.9.0
  google_maps_flutter: ^2.10.0
  permission_handler: ^11.3.1
  geolocator: ^13.0.2
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7
  intl: ^0.20.2
```

## Installation

1. Ensure you have Flutter installed on your machine.
2. Clone this repository.
3. Navigate to the project directory in your terminal.
4. Run `flutter pub get` to install the dependencies.

## How to Run

- Connect a physical device or start an emulator.
- Run `flutter run` to launch the application.

## Code Structure

- `cubit`: Contains Cubit classes for state management of dog data, journey history, and location tracking.
- `models`: Defines data models for Dog and Journey.
- `services`: Houses services for database interaction, API calls, and location handling.
- `views`: Contains the UI components, including screens and widgets.
- `screens`: Individual screens of the application (e.g., dog list, details, tracking).
- `widgets`: Reusable UI components.
- `main.dart`: Entry point of the application.

## Screenshots
<div style="display: flex; gap: 10px; flex-wrap: wrap;">
    <img src="https://github.com/user-attachments/assets/aca32df7-e983-4785-94a5-a7ffaf73b567" style="width: 150px; height: auto;">
    <img src="https://github.com/user-attachments/assets/67e530e4-7ce2-4408-9058-1a5aa3ba53ab" style="width: 150px; height: auto;">
    <img src="https://github.com/user-attachments/assets/05a8f2bf-6f44-4d91-be14-f1ec3f1754c5" style="width: 150px; height: auto;">
    <img src="https://github.com/user-attachments/assets/b88f873d-998d-4fa7-a3ad-5fb88e0b737c" style="width: 150px; height: auto;">
    <img src="https://github.com/user-attachments/assets/98be7f73-5e3c-4e3e-999a-aaea11983563" style="width: 150px; height: auto;">
    <img src="https://github.com/user-attachments/assets/e3f14fba-56ac-415f-81e7-b42ce63cb25d" style="width: 150px; height: auto;">
    <img src="https://github.com/user-attachments/assets/6ddb543f-0785-4c53-8550-f02d6f083bb9" style="width: 150px; height: auto;">
</div>

## API-KEY: 
- Replace the API key with your own in `AndroidManifest.xml` and `AppDelegate.swift` .







