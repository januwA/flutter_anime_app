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
    _$isLoadingAtom.context.enforceReadPolicy(_$isLoadingAtom);
    _$isLoadingAtom.reportObserved();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.context.conditionallyRunInAction(() {
      super.isLoading = value;
      _$isLoadingAtom.reportChanged();
    }, _$isLoadingAtom, name: '${_$isLoadingAtom.name}_set');
  }

  final _$initialIndexAtom = Atom(name: '_HomeStore.initialIndex');

  @override
  int get initialIndex {
    _$initialIndexAtom.context.enforceReadPolicy(_$initialIndexAtom);
    _$initialIndexAtom.reportObserved();
    return super.initialIndex;
  }

  @override
  set initialIndex(int value) {
    _$initialIndexAtom.context.conditionallyRunInAction(() {
      super.initialIndex = value;
      _$initialIndexAtom.reportChanged();
    }, _$initialIndexAtom, name: '${_$initialIndexAtom.name}_set');
  }

  final _$weekDataAtom = Atom(name: '_HomeStore.weekData');

  @override
  List<WeekData> get weekData {
    _$weekDataAtom.context.enforceReadPolicy(_$weekDataAtom);
    _$weekDataAtom.reportObserved();
    return super.weekData;
  }

  @override
  set weekData(List<WeekData> value) {
    _$weekDataAtom.context.conditionallyRunInAction(() {
      super.weekData = value;
      _$weekDataAtom.reportChanged();
    }, _$weekDataAtom, name: '${_$weekDataAtom.name}_set');
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$_getWeekDataAsyncAction = AsyncAction('_getWeekData');

  @override
  Future<void> _getWeekData() {
    return _$_getWeekDataAsyncAction.run(() => super._getWeekData());
  }
}
