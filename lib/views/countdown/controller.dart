part of 'view.dart';

class CountdownViewController extends ViewController {
  Duration targetTime = const Duration(minutes: 2);
  Duration decrementTime = const Duration(seconds: 1);
  Duration periodicTime = const Duration(seconds: 1);
  bool initialStartMode = true;
  OnCountdownCompleteListener? _onComplete;
  OnCountdownRemainingListener? _onRemaining;

  late Duration _rt = targetTime;
  Timer? _timer;
  bool _isRunning = false;

  CountdownViewController fromCountdownView(CountdownView view) {
    super.fromView(view);
    targetTime = view.target;
    decrementTime = view.decrement;
    periodicTime = view.periodic;
    initialStartMode = view.initialStartMode;
    _onComplete = view.onComplete;
    _onRemaining = view.onRemaining;
    return this;
  }

  void _cancel() {
    if (_timer != null) _timer!.cancel();
    _isRunning = false;
  }

  void clear() {
    _cancel();
    _rt = const Duration();
    onNotify();
  }

  void _continue() {
    if (!_isRunning) {
      if (_onComplete != null) _onComplete?.call(false);
      _timer = Timer.periodic(periodicTime, (ticker) {
        if (_rt.inSeconds <= 0) {
          _complete(ticker);
        } else {
          _rt = _rt - decrementTime;
          _remaining(_rt);
        }
        onNotify();
      });
    }
    _isRunning = true;
  }

  void _complete(Timer? ticker) {
    if (ticker != null) ticker.cancel();
    if (_timer != null) _timer?.cancel();
    if (_onComplete != null) _onComplete?.call(true);
  }

  void _dispose() => _cancel();

  void _remaining(Duration value) {
    if (_onRemaining != null) _onRemaining?.call(value);
  }

  void restart() {
    _cancel();
    _rt = targetTime;
    onNotify();
    _continue();
  }

  void start() => _continue();

  void stop() => _cancel();

  void setOnCompleteListener(OnCountdownCompleteListener? listener) {
    _onComplete = listener;
  }

  void setOnRemainingListener(OnCountdownRemainingListener? listener) {
    _onRemaining = listener;
  }
}
