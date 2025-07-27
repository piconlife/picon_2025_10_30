part of 'view.dart';

class EditLayoutController extends LinearLayoutController {
  int initialCheckTime = 500;

  EditLayoutController fromEditLayout(EditLayout view) {
    super.fromLinearLayout(view);
    initialCheckTime = view.initialCheckTime;
    return this;
  }

  bool _initial = true;

  Iterable _items = const [];

  Set _checks = const {};

  bool get isValid => _validations.length == _items.length;

  Iterable get _validations {
    return _checks.where((i) {
      if (i is EditTextController) {
        return i.isValid && i.isChecked;
      } else if (i is EditLayoutController) {
        return i.isValid;
      }
      return false;
    });
  }

  void _config() {
    _items = children.where((e) {
      if (e is EditText) {
        return e.controller is EditTextController &&
            e.controller!.onValidator != null;
      } else if (e is EditLayout) {
        return e.controller is EditLayoutController;
      } else {
        return false;
      }
    });
    _checks = _items.map((e) {
      if (e is EditText) {
        return e.controller!;
      }
      if (e is EditLayout) {
        return e.controller!;
      }
    }).toSet();
    if (_initial && onValid != null) {
      Future.delayed(Duration(milliseconds: initialCheckTime)).whenComplete(() {
        _initial = false;
        return onValid!(isValid);
      });
    }
    for (var i in _items) {
      i.controller?.setOnValidListener((value) {
        _checks.add(i.controller!);
        if (onValid != null) onValid!(isValid);
      });
    }
  }
}
