# Flixage - Music streaming app

[Flutter](https://flutter.dev) frontend app for my [project](https://github.com/ZbutwialyPiernik/flixage).

## Building and running

After pulling project for first time you won't be able to compile, you need to generate files for first time using

```
flutter pub get
flutter pub run build_runner build
```

If you're using enumlator and you host api server on same machine, then everything is ready at start.

```
flutter run
```

However if you're not running app on emulator then you should define address for api server, because default value is http://10.0.0.2:8080/api and it won't work on normal android phone.

```
flutter run --dart-define FLIXAGE_API_SERVER=[HERE YOUR ADDRESS]
```

## TODO

- Refactor views and extract widgets to custom classes/methods to improve readability
- Internationalize strings in app ✅ (90% done)
- Benchmark app and improve performance

## Screenshots
