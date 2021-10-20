import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_pcsc_linux/flutter_pcsc_linux.dart';
import 'package:flutter_pcsc_macos/flutter_pcsc_macos.dart';
import 'package:flutter_pcsc_platform_interface/flutter_pcsc_platform_interface.dart';
import 'package:flutter_pcsc_windows/flutter_pcsc_windows.dart';

/// The main class to use to deal with PCSC.
class Pcsc {
  /// Establishes a PCSC context.
  static Future<int> establishContext(PcscSCope scope) {
    return _platform.establishContext(scopeToInt(scope));
  }

  /// Lists available readers for this context.
  static Future<List<String>> listReaders(int context) {
    return _platform.listReaders(context);
  }

  /// Connects to the card using the specified reader.
  static Future<CardStruct> cardConnect(int context, String reader,
      PcscShare share, PcscProtocol protocol) async {
    return CardStruct.fromMap(await _platform.cardConnect(
        context, reader, shareToInt(share), protocolToInt(protocol)));
  }

  /// Transmits an APDU to the card.
  static Future<List<int>> transmit(CardStruct card, List<int> commandBytes,
      {bool newIsolate = false}) {
    return _platform.transmit(
        card.hCard, protocolToInt(card.activeProtocol), commandBytes,
        newIsolate: newIsolate);
  }

  /// Disconnects from the card.
  static Future<void> cardDisconnect(int hCard, PcscDisposition disposition) {
    return _platform.cardDisconnect(hCard, dispositionToInt(disposition));
  }

  /// Releases the PCSC context.
  static Future<void> releaseContext(int context) {
    return _platform.releaseContext(context);
  }

  /// Waits for a card to be present on the specified reader.
  ///
  /// If a card is already present, it does not wait.
  static Future<Map> waitForCardPresent(int context, String readerName) {
    return _platform.waitForCardPresent(context, readerName);
  }

  /// Waits for a card to be removed on the specified reader.
  ///
  /// If a card is already removed, it does not wait.
  static Future<void> waitForCardRemoved(int context, String readerName) {
    return _platform.waitForCardRemoved(context, readerName);
  }

  /// Converts a scope to its corresponding identifier.
  static int scopeToInt(PcscSCope scope) {
    switch (scope) {
      case PcscSCope.user:
        return PcscConstants.CARD_SCOPE_USER;
      case PcscSCope.terminal:
        return PcscConstants.CARD_SCOPE_TERMINAL;
      case PcscSCope.system:
        return PcscConstants.CARD_SCOPE_SYSTEM;
    }
  }

  /// Converts a protocol to its corresponding identifier.
  static int protocolToInt(PcscProtocol protocol) {
    switch (protocol) {
      case PcscProtocol.undefined:
        return PcscConstants.SCARD_PROTOCOL_UNDEFINED;
      case PcscProtocol.t0:
        return PcscConstants.SCARD_PROTOCOL_T0;
      case PcscProtocol.t1:
        return PcscConstants.SCARD_PROTOCOL_T1;
      case PcscProtocol.raw:
        return PcscConstants.SCARD_PROTOCOL_RAW;
      case PcscProtocol.t15:
        return PcscConstants.SCARD_PROTOCOL_T15;
      case PcscProtocol.any:
        return PcscConstants.SCARD_PROTOCOL_ANY;
    }
  }

  /// Converts a protocol identifier to its corresponding enum.
  static PcscProtocol intToProtocol(int protocol) {
    switch (protocol) {
      case PcscConstants.SCARD_PROTOCOL_UNDEFINED:
        return PcscProtocol.undefined;
      case PcscConstants.SCARD_PROTOCOL_T0:
        return PcscProtocol.t0;
      case PcscConstants.SCARD_PROTOCOL_T1:
        return PcscProtocol.t1;
      case PcscConstants.SCARD_PROTOCOL_RAW:
        return PcscProtocol.raw;
      case PcscConstants.SCARD_PROTOCOL_T15:
        return PcscProtocol.t15;
      case PcscConstants.SCARD_PROTOCOL_ANY:
        return PcscProtocol.any;
      default:
        throw Exception('Unknown protocol: $protocol');
    }
  }

  /// Converts a share mode to its corresponding identifier.
  static int shareToInt(PcscShare share) {
    switch (share) {
      case PcscShare.exclusive:
        return PcscConstants.SCARD_SHARE_EXCLUSIVE;
      case PcscShare.shared:
        return PcscConstants.SCARD_SHARE_SHARED;
      case PcscShare.direct:
        return PcscConstants.SCARD_SHARE_DIRECT;
    }
  }

  /// Converts a disposition method to its corresponding identifier.
  static int dispositionToInt(PcscDisposition disposition) {
    switch (disposition) {
      case PcscDisposition.leaveCard:
        return PcscConstants.SCARD_LEAVE_CARD;
      case PcscDisposition.resetCard:
        return PcscConstants.SCARD_RESET_CARD;
      case PcscDisposition.unpowerCard:
        return PcscConstants.SCARD_UNPOWER_CARD;
      case PcscDisposition.ejectCard:
        return PcscConstants.SCARD_EJECT_CARD;
    }
  }
}

/// Represents a card.
class CardStruct {
  /// The card handle.
  final int hCard;

  /// The active protocol (T=0 or T=1 for example).
  final PcscProtocol activeProtocol;

  /// The name of the smartcard reader.
  final String readerName;

  CardStruct(this.hCard, this.activeProtocol, this.readerName);

  static CardStruct fromMap(Map map) {
    return CardStruct(map['h_card'], Pcsc.intToProtocol(map['active_protocol']),
        map['reader']);
  }
}

/// Represents the different PCSC scopes.
enum PcscSCope { user, terminal, system }

/// Represents the different PCSC protocols
enum PcscProtocol { undefined, t0, t1, raw, t15, any }

/// Represents the different PCSC share modes.
enum PcscShare { exclusive, shared, direct }

/// Represents the different disposition methods.
enum PcscDisposition { leaveCard, resetCard, unpowerCard, ejectCard }

// issue 81421
bool _manualDartRegistrationNeeded = true;

PcscPlatform get _platform {
  if (_manualDartRegistrationNeeded) {
    if (!kIsWeb && PcscPlatform.instance is DummyPcscPlatform) {
      if (Platform.isLinux) {
        PcscPlatform.instance = PcscLinux();
      } else if (Platform.isWindows) {
        PcscPlatform.instance = PcscWindows();
      } else if (Platform.isMacOS) {
        PcscPlatform.instance = PcscMacOS();
      }
    }
    _manualDartRegistrationNeeded = false;
  }

  return PcscPlatform.instance;
}
