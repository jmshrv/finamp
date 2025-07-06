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
class ServerDiscoveryEmulationService {
  static final _serverDiscoveryEmulationLogger = Logger("JellyfinServerDiscoveryEmulation");

  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  late RawDatagramSocket socket;
  bool isSharing = false;

  ServerDiscoveryEmulationService();

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
            final responseActiveOrPublicAddress = ClientDiscoveryResponse(
              address: _finampUserHelper.currentUser?.publicAddress ?? _finampUserHelper.currentUser?.baseURL,
              endpointAddress: _finampUserHelper.currentUser?.publicAddress ?? _finampUserHelper.currentUser?.baseURL,
              id: _finampUserHelper.currentUser?.serverId,
              name: "Shared by Finamp",
            );
            final responseMessageActiveOrPublicAddress = jsonEncode(responseActiveOrPublicAddress);
            _serverDiscoveryEmulationLogger.finest("Sending discovery response: $responseMessageActiveOrPublicAddress");
            socket.send(utf8.encode(responseMessageActiveOrPublicAddress), datagram.address, datagram.port);
            _serverDiscoveryEmulationLogger.fine("Sent discovery response to ${datagram.address}:${datagram.port}");

            if (_finampUserHelper.currentUser?.localAddress != null) {
              final responseLocalAddress = ClientDiscoveryResponse(
                address: _finampUserHelper.currentUser?.localAddress,
                endpointAddress: _finampUserHelper.currentUser?.localAddress,
                id: _finampUserHelper.currentUser?.serverId,
                name: "Shared by Finamp",
              );
              final responseMessageLocalAddress = jsonEncode(responseLocalAddress);
              _serverDiscoveryEmulationLogger.finest(
                "Sending discovery response for local address: $responseMessageLocalAddress",
              );
              socket.send(utf8.encode(responseMessageLocalAddress), datagram.address, datagram.port);
              _serverDiscoveryEmulationLogger.fine("Sent discovery response to ${datagram.address}:${datagram.port}");
            }
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
