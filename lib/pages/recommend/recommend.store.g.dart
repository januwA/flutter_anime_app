// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$RecommendStore on _RecommendStore, Store {
  final _$animeListAtom = Atom(name: '_RecommendStore.animeList');

  @override
  BuiltList<LiData> get animeList {
    _$animeListAtom.context.enforceReadPolicy(_$animeListAtom);
    _$animeListAtom.reportObserved();
    return super.animeList;
  }

  @override
  set animeList(BuiltList<LiData> value) {
    _$animeListAtom.context.conditionallyRunInAction(() {
      super.animeList = value;
      _$animeListAtom.reportChanged();
    }, _$animeListAtom, name: '${_$animeListAtom.name}_set');
  }

  final _$getDataAsyncAction = AsyncAction('getData');

  @override
  Future<void> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }
}
