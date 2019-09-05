## how run the app?
```
$ git clone https://github.com/januwA/flutter_anime_app.git
$ flutter pub get
$ flutter packages pub run build_runner watch --delete-conflicting-outputs 
$ flutter run
```

## mobx build
```
find ./lib/ -iname *.g.dart | xargs rm -rf  // delete all *.g.dart file

flutter packages pub run build_runner build   // 执行一次build命令
flutter packages pub run build_runner watch  // 文件更改自动打包
flutter packages pub run build_runner watch --delete-conflicting-outputs  // 删除旧文件在打包
```

## [go to generator built_value data](https://januwa.github.io/p5-jsObj-builtValue/index.html)


## build apk
```
$ flutter build apk
$ flutter build apk --split-per-abi
```