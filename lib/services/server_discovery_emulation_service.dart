import 'dart:convert';
import 'dart:io';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

/// Used for discovering Jellyfin servers on the local network
/// https://jellyfin.org/docs/general/networking/#port-bindings
/// For some reason it's always being referred to as "client discovery" in the Jellyfin docs, even though we're actually discovering servers
class JellyfinServerDiscoveryEmulationService {
  static final _serverDiscoveryEmulationLogger = Logger("JellyfinServerDiscoveryEmulation");

  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  late RawDatagramSocket socket;
  bool isSharing = false;

  JellyfinServerDiscoveryEmulationService() {
    // listen for Finamp settings change and enable/disable server discovery emulation
    FinampSettingsHelper.finampSettingsListener.addListener(() {
      if (isSharing != FinampSettingsHelper.finampSettings.serverSharingEnabled) {
        if (FinampSettingsHelper.finampSettings.serverSharingEnabled) {
          advertiseServer();
        } else {
          dispose();
        }
      }
    });
  }

  void advertiseServer() async {
    isSharing = true;

    const discoveryMessage =
        "who is JellyfinServer?"; // doesn't seem to be case sensitive, but the Kotlin SDK uses this capitalization
    final broadcastAddress = InternetAddress("255.255.255.255"); // UDP broadcast address
    const discoveryPort = 7359; // Jellyfin client discovery port

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, discoveryPort);
    socket.broadcastEnabled = true; // important to allow sending to broadcast address
    socket.multicastHops = 5; // to account for weird network setups

    _serverDiscoveryEmulationLogger.fine("Advertising server on port $discoveryPort");

    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          _serverDiscoveryEmulationLogger.finest("Received datagram: ${utf8.decode(datagram.data)}");
          final requestMessage = utf8.decode(datagram.data);
          if (requestMessage.toLowerCase().contains(discoveryMessage.toLowerCase())) {
            _serverDiscoveryEmulationLogger.fine(
              "Received discovery message from ${datagram.address}:${datagram.port}",
            );
            // Respond with the server's information
            final response = ClientDiscoveryResponse(
              address: _finampUserHelper.currentUser?.baseUrl,
              endpointAddress: _finampUserHelper.currentUser?.baseUrl,
              id: _finampUserHelper.currentUser?.serverId,
              name: "Jellyfin Server (provided by Finamp)",
            );
            final responseMessage = jsonEncode(response);
            _serverDiscoveryEmulationLogger.finest("Sending discovery response: $responseMessage");
            socket.send(utf8.encode(responseMessage), datagram.address, datagram.port);
            _serverDiscoveryEmulationLogger.fine("Sent discovery response to ${datagram.address}:${datagram.port}");
          }
        }
      }
    });
  }

  void dispose() {
    isSharing = false;
    socket.close();
    _serverDiscoveryEmulationLogger.fine("Stopped advertising server");
  }
}
