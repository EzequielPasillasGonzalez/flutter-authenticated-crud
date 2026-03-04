import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();

    //  Estar escuchando el Stream del BLoC
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(), // Por cada estado nuevo, notificar
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
