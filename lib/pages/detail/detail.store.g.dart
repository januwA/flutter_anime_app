// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DetailStore on _DetailStore, Store {
  Computed<bool> _$hasNextPlayComputed;

  @override
  bool get hasNextPlay =>
      (_$hasNextPlayComputed ??= Computed<bool>(() => super.hasNextPlay)).value;
  Computed<bool> _$hasPrevPlayComputed;

  @override
  bool get hasPrevPlay =>
      (_$hasPrevPlayComputed ??= Computed<bool>(() => super.hasPrevPlay)).value;

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

  final _$loadingAtom = Atom(name: '_DetailStore.loading');

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

  final _$detailAtom = Atom(name: '_DetailStore.detail');

  @override
  DetailDto get detail {
    _$detailAtom.context.enforceReadPolicy(_$detailAtom);
    _$detailAtom.reportObserved();
    return super.detail;
  }

  @override
  set detail(DetailDto value) {
    _$detailAtom.context.conditionallyRunInAction(() {
      super.detail = value;
      _$detailAtom.reportChanged();
    }, _$detailAtom, name: '${_$detailAtom.name}_set');
  }

  final _$vcAtom = Atom(name: '_DetailStore.vc');

  @override
  VideoController get vc {
    _$vcAtom.context.enforceReadPolicy(_$vcAtom);
    _$vcAtom.reportObserved();
    return super.vc;
  }

  @override
  set vc(VideoController value) {
    _$vcAtom.context.conditionallyRunInAction(() {
      super.vc = value;
      _$vcAtom.reportChanged();
    }, _$vcAtom, name: '${_$vcAtom.name}_set');
  }

  final _$tabControllerAtom = Atom(name: '_DetailStore.tabController');

  @override
  TabController get tabController {
    _$tabControllerAtom.context.enforceReadPolicy(_$tabControllerAtom);
    _$tabControllerAtom.reportObserved();
    return super.tabController;
  }

  @override
  set tabController(TabController value) {
    _$tabControllerAtom.context.conditionallyRunInAction(() {
      super.tabController = value;
      _$tabControllerAtom.reportChanged();
    }, _$tabControllerAtom, name: '${_$tabControllerAtom.name}_set');
  }

  final _$currentPlayVideoAtom = Atom(name: '_DetailStore.currentPlayVideo');

  @override
  TabsValueDto get currentPlayVideo {
    _$currentPlayVideoAtom.context.enforceReadPolicy(_$currentPlayVideoAtom);
    _$currentPlayVideoAtom.reportObserved();
    return super.currentPlayVideo;
  }

  @override
  set currentPlayVideo(TabsValueDto value) {
    _$currentPlayVideoAtom.context.conditionallyRunInAction(() {
      super.currentPlayVideo = value;
      _$currentPlayVideoAtom.reportChanged();
    }, _$currentPlayVideoAtom, name: '${_$currentPlayVideoAtom.name}_set');
  }

  final _$animeVideoTypeAtom = Atom(name: '_DetailStore.animeVideoType');

  @override
  AnimeVideoType get animeVideoType {
    _$animeVideoTypeAtom.context.enforceReadPolicy(_$animeVideoTypeAtom);
    _$animeVideoTypeAtom.reportObserved();
    return super.animeVideoType;
  }

  @override
  set animeVideoType(AnimeVideoType value) {
    _$animeVideoTypeAtom.context.conditionallyRunInAction(() {
      super.animeVideoType = value;
      _$animeVideoTypeAtom.reportChanged();
    }, _$animeVideoTypeAtom, name: '${_$animeVideoTypeAtom.name}_set');
  }

  final _$isCollectionsAtom = Atom(name: '_DetailStore.isCollections');

  @override
  bool get isCollections {
    _$isCollectionsAtom.context.enforceReadPolicy(_$isCollectionsAtom);
    _$isCollectionsAtom.reportObserved();
    return super.isCollections;
  }

  @override
  set isCollections(bool value) {
    _$isCollectionsAtom.context.conditionallyRunInAction(() {
      super.isCollections = value;
      _$isCollectionsAtom.reportChanged();
    }, _$isCollectionsAtom, name: '${_$isCollectionsAtom.name}_set');
  }

  final _$initStateAsyncAction = AsyncAction('initState');

  @override
  Future<void> initState(
      TickerProvider ctx, BuildContext context, String animeId) {
    return _$initStateAsyncAction
        .run(() => super.initState(ctx, context, animeId));
  }

  final _$tabClickAsyncAction = AsyncAction('tabClick');

  @override
  Future<void> tabClick(TabsValueDto t, BuildContext context) {
    return _$tabClickAsyncAction.run(() => super.tabClick(t, context));
  }

  final _$_idGetSrcAsyncAction = AsyncAction('_idGetSrc');

  @override
  Future<String> _idGetSrc(String id) {
    return _$_idGetSrcAsyncAction.run(() => super._idGetSrc(id));
  }

  final _$collectionsAsyncAction = AsyncAction('collections');

  @override
  Future<void> collections(BuildContext context) {
    return _$collectionsAsyncAction.run(() => super.collections(context));
  }

  final _$_DetailStoreActionController = ActionController(name: '_DetailStore');

  @override
  dynamic nextPlay(BuildContext context) {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.nextPlay(context);
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic prevPlay(BuildContext context) {
    final _$actionInfo = _$_DetailStoreActionController.startAction();
    try {
      return super.prevPlay(context);
    } finally {
      _$_DetailStoreActionController.endAction(_$actionInfo);
    }
  }
}
