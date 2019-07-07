// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_types.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$AnimeTypesStore on _AnimeTypesStore, Store {
  Computed<String> _$typeComputed;

  @override
  String get type =>
      (_$typeComputed ??= Computed<String>(() => super.type)).value;
  Computed<String> _$areaComputed;

  @override
  String get area =>
      (_$areaComputed ??= Computed<String>(() => super.area)).value;
  Computed<String> _$eraComputed;

  @override
  String get era => (_$eraComputed ??= Computed<String>(() => super.era)).value;
  Computed<String> _$cifyComputed;

  @override
  String get cify =>
      (_$cifyComputed ??= Computed<String>(() => super.cify)).value;
  Computed<String> _$pageUrlComputed;

  @override
  String get pageUrl =>
      (_$pageUrlComputed ??= Computed<String>(() => super.pageUrl)).value;
  Computed<String> _$urlComputed;

  @override
  String get url => (_$urlComputed ??= Computed<String>(() => super.url)).value;

  final _$loadingAtom = Atom(name: '_AnimeTypesStore.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$animeDataAtom = Atom(name: '_AnimeTypesStore.animeData');

  @override
  ObservableList<LiData> get animeData {
    _$animeDataAtom.context.enforceReadPolicy(_$animeDataAtom);
    _$animeDataAtom.reportObserved();
    return super.animeData;
  }

  @override
  set animeData(ObservableList<LiData> value) {
    _$animeDataAtom.context.conditionallyRunInAction(() {
      super.animeData = value;
      _$animeDataAtom.reportChanged();
    }, _$animeDataAtom, name: '${_$animeDataAtom.name}_set');
  }

  final _$erasCurrentAtom = Atom(name: '_AnimeTypesStore.erasCurrent');

  @override
  int get erasCurrent {
    _$erasCurrentAtom.context.enforceReadPolicy(_$erasCurrentAtom);
    _$erasCurrentAtom.reportObserved();
    return super.erasCurrent;
  }

  @override
  set erasCurrent(int value) {
    _$erasCurrentAtom.context.conditionallyRunInAction(() {
      super.erasCurrent = value;
      _$erasCurrentAtom.reportChanged();
    }, _$erasCurrentAtom, name: '${_$erasCurrentAtom.name}_set');
  }

  final _$areasCurrentAtom = Atom(name: '_AnimeTypesStore.areasCurrent');

  @override
  int get areasCurrent {
    _$areasCurrentAtom.context.enforceReadPolicy(_$areasCurrentAtom);
    _$areasCurrentAtom.reportObserved();
    return super.areasCurrent;
  }

  @override
  set areasCurrent(int value) {
    _$areasCurrentAtom.context.conditionallyRunInAction(() {
      super.areasCurrent = value;
      _$areasCurrentAtom.reportChanged();
    }, _$areasCurrentAtom, name: '${_$areasCurrentAtom.name}_set');
  }

  final _$typesCurrentAtom = Atom(name: '_AnimeTypesStore.typesCurrent');

  @override
  int get typesCurrent {
    _$typesCurrentAtom.context.enforceReadPolicy(_$typesCurrentAtom);
    _$typesCurrentAtom.reportObserved();
    return super.typesCurrent;
  }

  @override
  set typesCurrent(int value) {
    _$typesCurrentAtom.context.conditionallyRunInAction(() {
      super.typesCurrent = value;
      _$typesCurrentAtom.reportChanged();
    }, _$typesCurrentAtom, name: '${_$typesCurrentAtom.name}_set');
  }

  final _$classifyCurrentAtom = Atom(name: '_AnimeTypesStore.classifyCurrent');

  @override
  int get classifyCurrent {
    _$classifyCurrentAtom.context.enforceReadPolicy(_$classifyCurrentAtom);
    _$classifyCurrentAtom.reportObserved();
    return super.classifyCurrent;
  }

  @override
  set classifyCurrent(int value) {
    _$classifyCurrentAtom.context.conditionallyRunInAction(() {
      super.classifyCurrent = value;
      _$classifyCurrentAtom.reportChanged();
    }, _$classifyCurrentAtom, name: '${_$classifyCurrentAtom.name}_set');
  }

  final _$pageCountAtom = Atom(name: '_AnimeTypesStore.pageCount');

  @override
  int get pageCount {
    _$pageCountAtom.context.enforceReadPolicy(_$pageCountAtom);
    _$pageCountAtom.reportObserved();
    return super.pageCount;
  }

  @override
  set pageCount(int value) {
    _$pageCountAtom.context.conditionallyRunInAction(() {
      super.pageCount = value;
      _$pageCountAtom.reportChanged();
    }, _$pageCountAtom, name: '${_$pageCountAtom.name}_set');
  }

  final _$getDataAsyncAction = AsyncAction('getData');

  @override
  Future getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  final _$_AnimeTypesStoreActionController =
      ActionController(name: '_AnimeTypesStore');

  @override
  dynamic setPageCount(int page) {
    final _$actionInfo = _$_AnimeTypesStoreActionController.startAction();
    try {
      return super.setPageCount(page);
    } finally {
      _$_AnimeTypesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAreasCurrent(int index) {
    final _$actionInfo = _$_AnimeTypesStoreActionController.startAction();
    try {
      return super.setAreasCurrent(index);
    } finally {
      _$_AnimeTypesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTypesCurrent(int index) {
    final _$actionInfo = _$_AnimeTypesStoreActionController.startAction();
    try {
      return super.setTypesCurrent(index);
    } finally {
      _$_AnimeTypesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setErasCurrent(int index) {
    final _$actionInfo = _$_AnimeTypesStoreActionController.startAction();
    try {
      return super.setErasCurrent(index);
    } finally {
      _$_AnimeTypesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setClassifyCurrent(int index) {
    final _$actionInfo = _$_AnimeTypesStoreActionController.startAction();
    try {
      return super.setClassifyCurrent(index);
    } finally {
      _$_AnimeTypesStoreActionController.endAction(_$actionInfo);
    }
  }
}
