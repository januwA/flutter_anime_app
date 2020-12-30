## how run the app?
  1. `git clone https://github.com/januwA/flutter_anime_app.git`
  2. Comment "generate: true" in "pubspec.yaml"
  3. `flutter pub get`
  4. `flutter packages pub run build_runner watch --delete-conflicting-outputs`
  5. `flutter pub get`
  6. `flutter run`

## mobx build
```
find ./lib/ -iname *.g.dart | xargs rm -rf  // delete all *.g.dart file

flutter packages pub run build_runner build   // 执行一次build命令
flutter packages pub run build_runner watch  // 文件更改自动打包
flutter packages pub run build_runner watch --delete-conflicting-outputs  // 删除旧文件在打包
```

## [go to generator built_value data](https://januwa.github.io/p5_object_2_builtvalue/index.html)


## build apk
```
$ flutter build apk --split-per-abi
```

## Test
```sh
λ flutter test ./test/util_test.dart
```

![](https://i.loli.net/2019/12/22/UOCmgeYS5pyWsHD.png)
![](https://i.loli.net/2019/12/22/kAxULFrcEHSVW9d.png)