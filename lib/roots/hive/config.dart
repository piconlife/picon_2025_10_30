abstract class HiveConfigure {
  Future<void> registerAdapter();

  Future<void> openBox();

  Future<void> call() async {
    await registerAdapter();
    await openBox();
  }
}
