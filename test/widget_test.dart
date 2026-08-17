import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rede_social/main.dart';

class FakeFirebaseAppPlatform extends FirebaseAppPlatform {
  FakeFirebaseAppPlatform()
      : super(
          '[DEFAULT]',
          const FirebaseOptions(
            apiKey: 'fake-api-key',
            appId: 'fake-app-id',
            messagingSenderId: 'fake-sender-id',
            projectId: 'fake-project-id',
          ),
        );
}

class FakeFirebasePlatform extends FirebasePlatform {
  final _app = FakeFirebaseAppPlatform();

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) => _app;

  @override
  List<FirebaseAppPlatform> get apps => [_app];

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _app;
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    FirebasePlatform.instance = FakeFirebasePlatform();
  });

  testWidgets('App inicializa sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());
    await tester.pump();
  });
}