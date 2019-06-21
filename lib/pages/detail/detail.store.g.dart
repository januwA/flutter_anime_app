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
    _$animeIdAtom.reportObserved();
    return super.animeId;
  }

  @override
  set animeId(String value) {
    _$animeIdAtom.context.checkIfStateModificationsAreAllowed(_$animeIdAtom);
    super.animeId = value;
    _$animeIdAtom.reportChanged();
  }

  final _$weekDataerrorAtom = Atom(name: '_DetailStore.weekDataerror');

  @override
  String get weekDataerror {
    _$weekDataerrorAtom.reportObserved();
    return super.weekDataerror;
  }

  @override
  set weekDataerror(String value) {
    _$weekDataerrorAtom.context
        .checkIfStateModificationsAreAllowed(_$weekDataerrorAtom);
    super.weekDataerror = value;
    _$weekDataerrorAtom.reportChanged();
  }

  final _$videoSrcerrorAtom = Atom(name: '_DetailStore.videoSrcerror');

  @override
  String get videoSrcerror {
    _$videoSrcerrorAtom.reportObserved();
    return super.videoSrcerror;
  }

  @override
  set videoSrcerror(String value) {
    _$videoSrcerrorAtom.context
        .checkIfStateModificationsAreAllowed(_$videoSrcerrorAtom);
    super.videoSrcerror = value;
    _$videoSrcerrorAtom.reportChanged();
  }

  final _$detailDataAtom = Atom(name: '_DetailStore.detailData');

  @override
  DetailData get detailData {
    _$detailDataAtom.reportObserved();
    return super.detailData;
  }

  @override
  set detailData(DetailData value) {
    _$detailDataAtom.context
        .checkIfStateModificationsAreAllowed(_$detailDataAtom);
    super.detailData = value;
    _$detailDataAtom.reportChanged();
  }

  final _$currentPlayIndexAtom = Atom(name: '_DetailStore.currentPlayIndex');

  @override
  int get currentPlayIndex {
    _$currentPlayIndexAtom.reportObserved();
    return super.currentPlayIndex;
  }

  @override
  set currentPlayIndex(int value) {
    _$currentPlayIndexAtom.context
        .checkIfStateModificationsAreAllowed(_$currentPlayIndexAtom);
    super.currentPlayIndex = value;
    _$currentPlayIndexAtom.reportChanged();
  }

  final _$srcAtom = Atom(name: '_DetailStore.src');

  @override
  String get src {
    _$srcAtom.reportObserved();
    return super.src;
  }

  @override
  set src(String value) {
    _$srcAtom.context.checkIfStateModificationsAreAllowed(_$srcAtom);
    super.src = value;
    _$srcAtom.reportChanged();
  }

  final _$isPageLoadingAtom = Atom(name: '_DetailStore.isPageLoading');

  @override
  bool get isPageLoading {
    _$isPageLoadingAtom.reportObserved();
    return super.isPageLoading;
  }

  @override
  set isPageLoading(bool value) {
    _$isPageLoadingAtom.context
        .checkIfStateModificationsAreAllowed(_$isPageLoadingAtom);
    super.isPageLoading = value;
    _$isPageLoadingAtom.reportChanged();
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
  Future<void> getVideoSrc(Function onErrorCb) {
    return _$getVideoSrcAsyncAction.run(() => super.getVideoSrc(onErrorCb));
  }

  final _$_DetailStoreActionController = ActionController(name: '_DetailStore');

  @override
  void setSrc(String s) {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.setSrc(s);
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }

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
