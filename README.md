# McDonald Order Management App
A simple automated cooking bots app to reduce workforce and increase their efficiency. 
Written in Flutter and designed using BLoC architecture design pattern.

## Feature
- Order Management (Page that display all pending and completed order, allow add and remove bot to process for the order)

## Getting Started

**Step 1:**
Clone the repo with the link below by using git:
```
git clone https://github.com/KuroXII/se-flutter-feedme.git
```

**Step 2:**
Current project is using flutter **Version 3.29.0**. Ensure using the appropriate flutter version before running.

**Step 3:**
Go to project root and execute the following command in console to get the required dependencies:
```
flutter pub get 
```

### Libraries & Tools Used
- [X] [Flutter BLoC](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc)
- [x] [Equatable](https://github.com/felangel/equatable.git)
- [x] [GetIt](https://github.com/fluttercommunity/get_it)
- [X] [Json Annotation](https://github.com/google/json_serializable.dart/tree/master/json_annotation)
- [x] [Build Runner](https://github.com/dart-lang/build/tree/master/build_runner)
- [x] [BLoC Test](https://github.com/felangel/bloc/tree/master/packages/bloc_test)
- [x] [Mockito](https://github.com/dart-lang/mockito)

### Folder Structure
Here is the core folder structure flutter provides.
```
flutter-feedme/
|- android
|- build
|- ios
|- lib
|- linux
|- macos
|- test
|- web
|- windows
```

Here is the folder structure using in this project
```
lib/
|- blocs/
|- constants/
|- extensions/
|- model/
|- network/
|- repositories/
|- routes/
|- ui/
|- utils/
|- widgets/
|- app_provider.dart
|- main.dart
```
#### Blocs
Blocs basically handling all kinds of business logic and provides the data for a specific UI component using events and states.

#### Model
Contains the data layer of your project.
Model consists of all the data classes required for the project.

#### UI
Contains all the layout required for the applications. E.g. screen

#### Widgets
Contain all common widgets that shared across multiple screens for the application

#### App Provider
Act as dependency injection (DI) so that instance of a Bloc/Cubit can be provided to multiple widgets within a subtree

#### Main
Starting point of the application. All application level configurations are defined in this file
E.g. theme, routes, title, home screen and etc

## Test
Here is the folder structure using for unit and widget testing in this project
```
test
|- blocs
|- mock
|- ui
|- widget
```

#### Mock
Contains mock data required to perform testing

#### How to execute testing
Go to project root and execute the following command in console to run for unit testing:
```
fvm flutter test
```
