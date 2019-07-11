// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$VersionService on _VersionService, Store {
  Computed<Future<GithubReleasesDto>> _$latestDataComputed;

  @override
  Future<GithubReleasesDto> get latestData => (_$latestDataComputed ??=
          Computed<Future<GithubReleasesDto>>(() => super.latestData))
      .value;

  final _$apkTypeAtom = Atom(name: '_VersionService.apkType');

  @override
  ApkTypes get apkType {
    _$apkTypeAtom.context.enforceReadPolicy(_$apkTypeAtom);
    _$apkTypeAtom.reportObserved();
    return super.apkType;
  }

  @override
  set apkType(ApkTypes value) {
    _$apkTypeAtom.context.conditionallyRunInAction(() {
      super.apkType = value;
      _$apkTypeAtom.reportChanged();
    }, _$apkTypeAtom, name: '${_$apkTypeAtom.name}_set');
  }

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
  GithubReleasesDto get _latestData {
    _$_latestDataAtom.context.enforceReadPolicy(_$_latestDataAtom);
    _$_latestDataAtom.reportObserved();
    return super._latestData;
  }

  @override
  set _latestData(GithubReleasesDto value) {
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

  final _$_setDownloadApkTypeAsyncAction = AsyncAction('_setDownloadApkType');

  @override
  Future<void> _setDownloadApkType() {
    return _$_setDownloadApkTypeAsyncAction
        .run(() => super._setDownloadApkType());
  }

  final _$_VersionServiceActionController =
      ActionController(name: '_VersionService');

  @override
  dynamic setLatestData(GithubReleasesDto data) {
    final _$actionInfo = _$_VersionServiceActionController.startAction();
    try {
      return super.setLatestData(data);
    } finally {
      _$_VersionServiceActionController.endAction(_$actionInfo);
    }
  }
}
