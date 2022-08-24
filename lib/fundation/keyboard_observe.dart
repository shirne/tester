import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class KeyboardObserve extends ChangeNotifier
    implements ValueListenable<double> {
  double _value = 0;
  double _storeValue = 0;

  late final Ticker _ticker;
  late final State state;

  KeyboardObserve({
    required TickerProviderStateMixin vsync,
    bool autoStart = true,
    double? defaultValue,
  }) : _storeValue = defaultValue ?? 0 {
    _init(vsync.createTicker(_tick), vsync, autoStart);
  }
  KeyboardObserve.fromSingle({
    required SingleTickerProviderStateMixin vsync,
    bool autoStart = true,
    double? defaultValue,
  }) : _storeValue = defaultValue ?? 0 {
    _init(vsync.createTicker(_tick), vsync, autoStart);
  }

  void _init(Ticker ticker, State state, bool autoStart) {
    _ticker = ticker;
    this.state = state;
    if (autoStart) {
      start();
    }
  }

  void start() {
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
  }

  void _tick(Duration duration) {
    if (!state.mounted) {
      return;
    }
    final mediaData = MediaQuery.of(state.context);
    if (mediaData.viewInsets.bottom != _value) {
      print('${mediaData.viewInsets.bottom} - ${_value}');
      _value = mediaData.viewInsets.bottom;
      if (_value > 0) {
        _storeValue = _value;
      }
      notifyListeners();
    }
  }

  @override
  double get value => _value;

  double get storeValue => _storeValue;

  bool get keyboardShown => _value > 0;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
