import 'package:flutter_test/flutter_test.dart';
import 'package:krishios/shared/models/ai_engine_result.dart';
import 'package:krishios/shared/services/ai_engine.dart';
import 'package:krishios/shared/services/ai_engine_manager_mobile.dart';

class _FakeEngine implements AIEngine {
  _FakeEngine({required this.result});

  final AIEngineResult result;
  int calls = 0;

  @override
  Future<void> initialize() async {}

  @override
  bool get isReady => true;

  @override
  Future<AIEngineResult> processImage(dynamic imageFile) async {
    calls += 1;
    return result;
  }

  @override
  void dispose() {}
}

void main() {
  test('auto mode prefers cloud when reachable and cloud succeeds', () async {
    final local = _FakeEngine(
      result: AIEngineResult(prediction: 'local', confidence: 0.4),
    );
    final remote = _FakeEngine(
      result: AIEngineResult(prediction: 'remote', confidence: 0.9),
    );

    final manager = AIEngineManager(
      scanBaseUrl: 'http://localhost:8080',
      host: '127.0.0.1',
      localEngine: local,
      remoteEngine: remote,
      apiReachabilityCheck: () async => true,
    );

    final result = await manager.processImage(Object());

    expect(result.prediction, 'remote');
    expect(remote.calls, 1);
    expect(local.calls, 0);
  });

  test('auto mode falls back to local when cloud fails', () async {
    final local = _FakeEngine(
      result: AIEngineResult(prediction: 'local', confidence: 0.8),
    );
    final remote = _FakeEngine(
      result: AIEngineResult.failure('remote down'),
    );

    final manager = AIEngineManager(
      scanBaseUrl: 'http://localhost:8080',
      host: '127.0.0.1',
      localEngine: local,
      remoteEngine: remote,
      apiReachabilityCheck: () async => true,
    );

    final result = await manager.processImage(Object());

    expect(result.prediction, 'local');
    expect(remote.calls, 1);
    expect(local.calls, 1);
  });

  test('force local skips cloud reachability and cloud execution', () async {
    final local = _FakeEngine(
      result: AIEngineResult(prediction: 'local', confidence: 0.8),
    );
    final remote = _FakeEngine(
      result: AIEngineResult(prediction: 'remote', confidence: 0.9),
    );
    var reachabilityChecks = 0;

    final manager = AIEngineManager(
      scanBaseUrl: 'http://localhost:8080',
      host: '127.0.0.1',
      localEngine: local,
      remoteEngine: remote,
      apiReachabilityCheck: () async {
        reachabilityChecks += 1;
        return true;
      },
    )..setEngineMode(AIEngineMode.forceLocal);

    final result = await manager.processImage(Object());

    expect(result.prediction, 'local');
    expect(reachabilityChecks, 0);
    expect(remote.calls, 0);
    expect(local.calls, 1);
  });
}
