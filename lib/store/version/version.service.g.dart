// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$VersionService on _VersionService, Store {
  Computed<Future<Map<String, dynamic>>> _$latestDataComputed;

  @override
  Future<Map<String, dynamic>> get latestData => (_$latestDataComputed ??=
          Computed<Future<Map<String, dynamic>>>(() => super.latestData))
      .value;

  final _$permissisonReadyAtom = Atom(name: '_VersionService.permissisonReady');

  @override
  bool get permissisonReady {
    _$permissisonReadyAtom.context.enforceReadPolicy(_$permissisonReadyAtom);
    _$permissisonReadyAtom.reportObserved();
    return super.permissisonReady;
  }

  @override
  set permissisonReady(bool value) {
    _$permissisonReadyAtom.context.conditionallyRunInAction(() {
      super.permissisonReady = value;
      _$permissisonReadyAtom.reportChanged();
    }, _$permissisonReadyAtom, name: '${_$permissisonReadyAtom.name}_set');
  }

  final _$_latestDataAtom = Atom(name: '_VersionService._latestData');

  @override
  Map<String, dynamic> get _latestData {
    _$_latestDataAtom.context.enforceReadPolicy(_$_latestDataAtom);
    _$_latestDataAtom.reportObserved();
    return super._latestData;
  }

  @override
  set _latestData(Map<String, dynamic> value) {
    _$_latestDataAtom.context.conditionallyRunInAction(() {
      super._latestData = value;
      _$_latestDataAtom.reportChanged();
    }, _$_latestDataAtom, name: '${_$_latestDataAtom.name}_set');
  }

  final _$checkVersionAsyncAction = AsyncAction('checkVersion');

  @override
  Future<void> checkVersion(BuildContext context) {
    return _$checkVersionAsyncAction.run(() => super.checkVersion(context));
  }

  final _$_VersionServiceActionController =
      ActionController(name: '_VersionService');

  @override
  dynamic setLatestData(Map<String, dynamic> data) {
    final _$actionInfo = _$_VersionServiceActionController.startAction();
    try {
      return super.setLatestData(data);
    } finally {
      _$_VersionServiceActionController.endAction(_$actionInfo);
    }
  }
}
