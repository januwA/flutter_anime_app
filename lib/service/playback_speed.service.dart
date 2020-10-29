import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackSpeedService {
  static final String _key = 'playbackSpeed';
  SharedPreferences _prefs;

  /// 视频播放速度 service
  PlaybackSpeedService() {
    SharedPreferences.getInstance().then((value) {
      _prefs ??= value;
      _speed = _prefs.getDouble(PlaybackSpeedService._key) ?? 1.0;
      _speedSink.add(_speed);
    });
  }

  Stream<double> get speed$ => _speedSubject.stream;
  Sink<double> get _speedSink => _speedSubject.sink;
  final _speedSubject = BehaviorSubject<double>.seeded(1.0);
  double _speed = 1.0;

  setPlaybackSpeed([double value]) {
    if (value != null) _speed = value;
    _speedSink.add(_speed);
    _prefs.setDouble(PlaybackSpeedService._key, value);
  }

  dispose() {
    _speedSubject.close();
  }
}
