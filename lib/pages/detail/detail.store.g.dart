// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$DetailStore on _DetailStore, Store {
  final _$animeIdAtom = Atom(name: '_DetailStore.animeId');

  @override
  String get animeId {
    _$animeIdAtom.context.enforceReadPolicy(_$animeIdAtom);
    _$animeIdAtom.reportObserved();
    return super.animeId;
  }

  @override
  set animeId(String value) {
    _$animeIdAtom.context.conditionallyRunInAction(() {
      super.animeId = value;
      _$animeIdAtom.reportChanged();
    }, _$animeIdAtom, name: '${_$animeIdAtom.name}_set');
  }

  final _$videoAtom = Atom(name: '_DetailStore.video');

  @override
  Video get video {
    _$videoAtom.context.enforceReadPolicy(_$videoAtom);
    _$videoAtom.reportObserved();
    return super.video;
  }

  @override
  set video(Video value) {
    _$videoAtom.context.conditionallyRunInAction(() {
      super.video = value;
      _$videoAtom.reportChanged();
    }, _$videoAtom, name: '${_$videoAtom.name}_set');
  }

  final _$detailDataAtom = Atom(name: '_DetailStore.detailData');

  @override
  DetailData get detailData {
    _$detailDataAtom.context.enforceReadPolicy(_$detailDataAtom);
    _$detailDataAtom.reportObserved();
    return super.detailData;
  }

  @override
  set detailData(DetailData value) {
    _$detailDataAtom.context.conditionallyRunInAction(() {
      super.detailData = value;
      _$detailDataAtom.reportChanged();
    }, _$detailDataAtom, name: '${_$detailDataAtom.name}_set');
  }

  final _$currentPlayIndexAtom = Atom(name: '_DetailStore.currentPlayIndex');

  @override
  int get currentPlayIndex {
    _$currentPlayIndexAtom.context.enforceReadPolicy(_$currentPlayIndexAtom);
    _$currentPlayIndexAtom.reportObserved();
    return super.currentPlayIndex;
  }

  @override
  set currentPlayIndex(int value) {
    _$currentPlayIndexAtom.context.conditionallyRunInAction(() {
      super.currentPlayIndex = value;
      _$currentPlayIndexAtom.reportChanged();
    }, _$currentPlayIndexAtom, name: '${_$currentPlayIndexAtom.name}_set');
  }

  final _$isPageLoadingAtom = Atom(name: '_DetailStore.isPageLoading');

  @override
  bool get isPageLoading {
    _$isPageLoadingAtom.context.enforceReadPolicy(_$isPageLoadingAtom);
    _$isPageLoadingAtom.reportObserved();
    return super.isPageLoading;
  }

  @override
  set isPageLoading(bool value) {
    _$isPageLoadingAtom.context.conditionallyRunInAction(() {
      super.isPageLoading = value;
      _$isPageLoadingAtom.reportChanged();
    }, _$isPageLoadingAtom, name: '${_$isPageLoadingAtom.name}_set');
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$getDetailDataAsyncAction = AsyncAction('getDetailData');

  @override
  Future<void> getDetailData() {
    return _$getDetailDataAsyncAction.run(() => super.getDetailData());
  }

  final _$getVideoSrcAsyncAction = AsyncAction('getVideoSrc');

  @override
  Future<void> getVideoSrc({BuildContext context, String id}) {
    return _$getVideoSrcAsyncAction
        .run(() => super.getVideoSrc(context: context, id: id));
  }

  final _$_DetailStoreActionController = ActionController(name: '_DetailStore');

  @override
  void setCurrentPlayIndex(int i) {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.setCurrentPlayIndex(i);
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$ErrorState on _ErrorState, Store {
  final _$detailAtom = Atom(name: '_ErrorState.detail');

  @override
  String get detail {
    _$detailAtom.context.enforceReadPolicy(_$detailAtom);
    _$detailAtom.reportObserved();
    return super.detail;
  }

  @override
  set detail(String value) {
    _$detailAtom.context.conditionallyRunInAction(() {
      super.detail = value;
      _$detailAtom.reportChanged();
    }, _$detailAtom, name: '${_$detailAtom.name}_set');
  }

  final _$srcAtom = Atom(name: '_ErrorState.src');

  @override
  String get src {
    _$srcAtom.context.enforceReadPolicy(_$srcAtom);
    _$srcAtom.reportObserved();
    return super.src;
  }

  @override
  set src(String value) {
    _$srcAtom.context.conditionallyRunInAction(() {
      super.src = value;
      _$srcAtom.reportChanged();
    }, _$srcAtom, name: '${_$srcAtom.name}_set');
  }
}
