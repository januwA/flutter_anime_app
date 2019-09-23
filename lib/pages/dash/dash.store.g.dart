// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dash.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DashStore on _DashStore, Store {
  final _$indexAtom = Atom(name: '_DashStore.index');

  @override
  int get index {
    _$indexAtom.context.enforceReadPolicy(_$indexAtom);
    _$indexAtom.reportObserved();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.context.conditionallyRunInAction(() {
      super.index = value;
      _$indexAtom.reportChanged();
    }, _$indexAtom, name: '${_$indexAtom.name}_set');
  }

  final _$_DashStoreActionController = ActionController(name: '_DashStore');

  @override
  void onPageChanged(int x) {
    final _$actionInfo = _$_DashStoreActionController.startAction();
    try {
      return super.onPageChanged(x);
    } finally {
      _$_DashStoreActionController.endAction(_$actionInfo);
    }
  }
}
