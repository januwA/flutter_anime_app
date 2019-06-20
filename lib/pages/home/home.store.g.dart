// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$HomeStore on _HomeStore, Store {
  final _$isLoadingAtom = Atom(name: '_HomeStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportObserved();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.context
        .checkIfStateModificationsAreAllowed(_$isLoadingAtom);
    super.isLoading = value;
    _$isLoadingAtom.reportChanged();
  }

  final _$initialIndexAtom = Atom(name: '_HomeStore.initialIndex');

  @override
  int get initialIndex {
    _$initialIndexAtom.reportObserved();
    return super.initialIndex;
  }

  @override
  set initialIndex(int value) {
    _$initialIndexAtom.context
        .checkIfStateModificationsAreAllowed(_$initialIndexAtom);
    super.initialIndex = value;
    _$initialIndexAtom.reportChanged();
  }

  final _$weekDataAtom = Atom(name: '_HomeStore.weekData');

  @override
  BuiltList<WeekData> get weekData {
    _$weekDataAtom.reportObserved();
    return super.weekData;
  }

  @override
  set weekData(BuiltList<WeekData> value) {
    _$weekDataAtom.context.checkIfStateModificationsAreAllowed(_$weekDataAtom);
    super.weekData = value;
    _$weekDataAtom.reportChanged();
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$getWeekDataAsyncAction = AsyncAction('getWeekData');

  @override
  Future<void> getWeekData() {
    return _$getWeekDataAsyncAction.run(() => super.getWeekData());
  }

  final _$_HomeStoreActionController = ActionController(name: '_HomeStore');

  @override
  void setInitialIndex(int i) {
    final _$actionInfo = _$_HomeStoreActionController.startAction();
    try {
      return super.setInitialIndex(i);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }
}
