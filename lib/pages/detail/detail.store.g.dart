// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$DetailStore on _DetailStore, Store {
  Computed<PlayUrlTab> _$currentPlayVideoComputed;

  @override
  PlayUrlTab get currentPlayVideo => (_$currentPlayVideoComputed ??=
          Computed<PlayUrlTab>(() => super.currentPlayVideo))
      .value;
  Computed<String> _$durationTextComputed;

  @override
  String get durationText =>
      (_$durationTextComputed ??= Computed<String>(() => super.durationText))
          .value;
  Computed<String> _$positionTextComputed;

  @override
  String get positionText =>
      (_$positionTextComputed ??= Computed<String>(() => super.positionText))
          .value;
  Computed<double> _$sliderValueComputed;

  @override
  double get sliderValue =>
      (_$sliderValueComputed ??= Computed<double>(() => super.sliderValue))
          .value;

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

  final _$videoCtrlAtom = Atom(name: '_DetailStore.videoCtrl');

  @override
  VideoPlayerController get videoCtrl {
    _$videoCtrlAtom.reportObserved();
    return super.videoCtrl;
  }

  @override
  set videoCtrl(VideoPlayerController value) {
    _$videoCtrlAtom.context
        .checkIfStateModificationsAreAllowed(_$videoCtrlAtom);
    super.videoCtrl = value;
    _$videoCtrlAtom.reportChanged();
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

  final _$isVideoLoadingAtom = Atom(name: '_DetailStore.isVideoLoading');

  @override
  bool get isVideoLoading {
    _$isVideoLoadingAtom.reportObserved();
    return super.isVideoLoading;
  }

  @override
  set isVideoLoading(bool value) {
    _$isVideoLoadingAtom.context
        .checkIfStateModificationsAreAllowed(_$isVideoLoadingAtom);
    super.isVideoLoading = value;
    _$isVideoLoadingAtom.reportChanged();
  }

  final _$positionAtom = Atom(name: '_DetailStore.position');

  @override
  Duration get position {
    _$positionAtom.reportObserved();
    return super.position;
  }

  @override
  set position(Duration value) {
    _$positionAtom.context.checkIfStateModificationsAreAllowed(_$positionAtom);
    super.position = value;
    _$positionAtom.reportChanged();
  }

  final _$durationAtom = Atom(name: '_DetailStore.duration');

  @override
  Duration get duration {
    _$durationAtom.reportObserved();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.context.checkIfStateModificationsAreAllowed(_$durationAtom);
    super.duration = value;
    _$durationAtom.reportChanged();
  }

  final _$isShowVideoCtrlAtom = Atom(name: '_DetailStore.isShowVideoCtrl');

  @override
  bool get isShowVideoCtrl {
    _$isShowVideoCtrlAtom.reportObserved();
    return super.isShowVideoCtrl;
  }

  @override
  set isShowVideoCtrl(bool value) {
    _$isShowVideoCtrlAtom.context
        .checkIfStateModificationsAreAllowed(_$isShowVideoCtrlAtom);
    super.isShowVideoCtrl = value;
    _$isShowVideoCtrlAtom.reportChanged();
  }

  final _$isFullScreenAtom = Atom(name: '_DetailStore.isFullScreen');

  @override
  bool get isFullScreen {
    _$isFullScreenAtom.reportObserved();
    return super.isFullScreen;
  }

  @override
  set isFullScreen(bool value) {
    _$isFullScreenAtom.context
        .checkIfStateModificationsAreAllowed(_$isFullScreenAtom);
    super.isFullScreen = value;
    _$isFullScreenAtom.reportChanged();
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

  final _$initVideoPlaerAsyncAction = AsyncAction('initVideoPlaer');

  @override
  Future<void> initVideoPlaer([String src]) {
    return _$initVideoPlaerAsyncAction.run(() => super.initVideoPlaer(src));
  }

  final _$getVideoSrcAsyncAction = AsyncAction('getVideoSrc');

  @override
  Future<void> getVideoSrc(Function onErrorCb) {
    return _$getVideoSrcAsyncAction.run(() => super.getVideoSrc(onErrorCb));
  }

  final _$_DetailStoreActionController = ActionController(name: '_DetailStore');

  @override
  void videoListenner() {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.videoListenner();
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showVideoCtrl(bool show) {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.showVideoCtrl(show);
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePlay() {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.togglePlay();
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

  @override
  void setIsFullScreen(bool full) {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.setIsFullScreen(full);
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLandscape() {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.setLandscape();
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPortrait() {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.setPortrait();
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }
}
