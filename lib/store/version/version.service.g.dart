// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$VersionService on _VersionService, Store {
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

  final _$checkVersionAsyncAction = AsyncAction('checkVersion');

  @override
  Future<void> checkVersion(BuildContext context) {
    return _$checkVersionAsyncAction.run(() => super.checkVersion(context));
  }
}
