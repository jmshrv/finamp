import 'package:audio_service/audio_service.dart';

/// audio_service will disconnect itself during stuff like album changes.
/// This function checks if audio_service is connected and reconnects if needed.
void connectIfDisconnected() {
  if (!AudioService.connected) {
    print("Audio service disconnected, reconnecting");
    AudioService.connect();
  }
}
