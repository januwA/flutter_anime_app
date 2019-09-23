// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

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

  final _$_getDataAsyncAction = AsyncAction('_getData');

  @override
  Future<void> _getData() {
    return _$_getDataAsyncAction.run(() => super._getData());
  }

  final _$refreshAsyncAction = AsyncAction('refresh');

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }
}
