import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class KeyboardObserve extends ValueListenable<double> {
  double _value = 0;
  final callbacks = <VoidCallback>{};

  late final Ticker _ticker;
  late final State state;

  KeyboardObserve(
      {required TickerProviderStateMixin vsync, bool autoStart = true}) {
    _init(vsync.createTicker(_tick), vsync, autoStart);
  }
  KeyboardObserve.fromSingle(
      {required SingleTickerProviderStateMixin vsync, bool autoStart = true}) {
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
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$runtimeType use a unmounted State $state.'),
        ErrorDescription(
            'A $runtimeType must be dispose when it\'s sync state disposed.'),
      ]);
    }
    final mediaData = MediaQuery.of(state.context);
    if (mediaData.viewInsets.bottom != _value) {
      _value = mediaData.viewInsets.bottom;
      callbacks.lookup((e) => e.call());
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (!callbacks.contains(listener)) {
      callbacks.add(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (callbacks.contains(listener)) {
      callbacks.remove(callbacks);
    }
  }

  @override
  double get value => _value;

  bool get keyboardShown => _value > 0;

  void dispose() {
    callbacks.clear();
    _ticker.dispose();
  }
}
