part of 'view.dart';

extension MaterialStateExtension<T> on MaterialStateProperty<T?>? {
  MaterialStateProperty<T?> get use =>
      this ?? const MaterialStatePropertyAll(null);

  T? call([MaterialState? state]) => use.resolve({if (state != null) state});

  T? property(MaterialState state) => use(state);

  T? get none => use();
}
