import '../di/injection_container.dart' as di;

final sl = di.sl;

Future<void> initServiceLocator() async {
  await di.init();
}
