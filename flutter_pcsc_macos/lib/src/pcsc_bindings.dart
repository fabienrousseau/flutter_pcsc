import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pcsc_macos/src/generated_bindings.dart';
import 'package:flutter_pcsc_platform_interface/flutter_pcsc_platform_interface.dart';

class PCSCBinding {
  static final _dylib = ffi.DynamicLibrary.open(
      "/System/Library/Frameworks/PCSC.framework/Versions/Current/PCSC");
  static final NativeLibraryWinscard _nlwinscard =
      NativeLibraryWinscard(_dylib);

  static final ffi.Pointer<Never> _nullptr = ffi.Pointer.fromAddress(0);

  final ffi.Pointer<SCARD_IO_REQUEST> _scardT0Pci = calloc<SCARD_IO_REQUEST>();
  final ffi.Pointer<SCARD_IO_REQUEST> _scardT1Pci = calloc<SCARD_IO_REQUEST>();

  PCSCBinding() {
    _scardT0Pci.ref.cbPciLength = _nlwinscard.g_rgSCardT0Pci.cbPciLength;
    _scardT0Pci.ref.dwProtocol = _nlwinscard.g_rgSCardT0Pci.dwProtocol;

    _scardT1Pci.ref.cbPciLength = _nlwinscard.g_rgSCardT1Pci.cbPciLength;
    _scardT1Pci.ref.dwProtocol = _nlwinscard.g_rgSCardT1Pci.dwProtocol;
  }

  /*
   * The clas PCSCBinding should only be instantiated once, so there is no absolute necessity for this method
   */
  close() {
    calloc.free(_scardT0Pci);
    calloc.free(_scardT1Pci);
  }

  Future<int> establishContext(int scope) {
    ffi.Pointer<SCARDCONTEXT> phContext = calloc<SCARDCONTEXT>();
    try {
      var res =
          _nlwinscard.SCardEstablishContext(0, _nullptr, _nullptr, phContext);
      _checkAndThrow(res, 'Error while establing context');
      return Future.value(phContext.value);
    } finally {
      calloc.free(phContext);
    }
  }

  void _checkAndThrow(int res, String prefix) {
    if (res != PcscConstants.SCARD_S_SUCCESS) {
      throw Exception(prefix + '. Reason: ${PcscConstants.errorToString(res)}');
    }
  }

  Future<List<String>> listReaders(int context) {
    final pcchReaders = calloc<DWORD>();
    try {
      var res = _nlwinscard.SCardListReaders(
          context, _nullptr, _nullptr, pcchReaders);

      // In that particular case, don't throw an error.
      if (res == PcscConstants.SCARD_E_NO_READERS_AVAILABLE) {
        return Future.value([]);
      }
      _checkAndThrow(res, 'Error while listing readers #1');

      final mszReaders = calloc<ffi.Int8>(pcchReaders.value);
      try {
        res = _nlwinscard.SCardListReaders(
            context, _nullptr, mszReaders, pcchReaders);
        _checkAndThrow(res, 'Error while listing readers #2');

        return Future.value(
            _decodemstr(_asInt8List(mszReaders, pcchReaders.value)));
      } finally {
        calloc.free(mszReaders);
      }
    } finally {
      calloc.free(pcchReaders);
    }
  }

  Future<Map> cardConnect(
      int context, String reader, int shareMode, int protocol) async {
    final ffi.Pointer<ffi.Int8> nativeReaderName =
        reader.toNativeUtf8(allocator: calloc).cast();
    final phCard = calloc<SCARDHANDLE>();
    final pdwActiveProtocol = calloc<DWORD>();

    try {
      var res = _nlwinscard.SCardConnect(context, nativeReaderName, shareMode,
          protocol, phCard, pdwActiveProtocol);
      _checkAndThrow(res, 'Error while connecting to card');

      Map result = {};
      result['h_card'] = phCard.value;
      result['active_protocol'] = pdwActiveProtocol.value;
      result['reader'] = reader;

      return result;
    } finally {
      calloc.free(nativeReaderName);
      calloc.free(phCard);
      calloc.free(pdwActiveProtocol);
    }
  }

  Future<Uint8List> transmit(
      int hCard, int activeProtocol, List<int> sendCommand,
      {bool newIsolate = false}) {
    if (newIsolate) {
      return _transmitInNewIsolate(hCard, activeProtocol, sendCommand);
    } else {
      return _transmitInSameIsolate(hCard, activeProtocol, sendCommand);
    }
  }

  Future<Map> cardGetStatusChange(int context, String readerName,
      {int currentState = PcscConstants.SCARD_STATE_UNAWARE}) async {
    ffi.Pointer<SCARD_READERSTATE> rgReaderStates = calloc<SCARD_READERSTATE>();

    rgReaderStates.ref.szReader = readerName.toNativeUtf8().cast();
    rgReaderStates.ref.dwCurrentState = currentState;

    try {
      var res = _nlwinscard.SCardGetStatusChange(
          context, PcscConstants.SCARD_INFINITE, rgReaderStates, 1);
      _checkAndThrow(res,
          'Error while waiting for status change (card insertion/removal)');

      return _buildMapData(rgReaderStates.ref);
    } finally {
      calloc.free(rgReaderStates.ref.szReader);
      calloc.free(rgReaderStates);
    }
  }

  Future<void> cardDisconnect(int hCard, int disposition) async {
    var res = _nlwinscard.SCardDisconnect(hCard, disposition);
    _checkAndThrow(res, 'Error while disconnecting card');
  }

  Future<void> releaseContext(int context) async {
    var res = _nlwinscard.SCardReleaseContext(context);
    _checkAndThrow(res, 'Error while releasing context');
  }

  Future<Map> waitForCardPresent(int context, String readerName) async {
    Map map = await cardGetStatusChange(context, readerName);
    int currentState = map['pcsc_tag']['event_state'];

    if (currentState & PcscConstants.SCARD_STATE_EMPTY != 0) {
      return await compute(_computeFunctionCardGetStatusChange, {
        'context': context,
        'reader_name': readerName,
        'current_state': currentState
      });
    } else {
      return map;
    }
  }

  Future<void> waitForCardRemoved(int context, String readerName) async {
    Map map = await cardGetStatusChange(context, readerName);
    int currentState = map['pcsc_tag']['event_state'];

    if (currentState & PcscConstants.SCARD_STATE_PRESENT != 0) {
      await compute(_computeFunctionCardGetStatusChange, {
        'context': context,
        'reader_name': readerName,
        'current_state': currentState
      });
    }
  }

  /*
   * This computeFunction allows to run a blocking C function in an Isolate
   */
  static Future<Uint8List> _computeFunctionTransmit(Map map) async {
    PCSCBinding binding = PCSCBinding();
    return binding.transmit(
        map['h_card'], map['active_protocol'], map['command'],
        newIsolate: false);
  }

  /*
   * This computeFunction allows to run a blocking C function in an Isolate
   */
  static Future<Map> _computeFunctionCardGetStatusChange(Map map) async {
    PCSCBinding binding = PCSCBinding();
    return binding.cardGetStatusChange(map['context'], map['reader_name'],
        currentState: map['current_state']);
  }

  Future<Uint8List> _transmitInNewIsolate(
      int hCard, int activeProtocol, List<int> sendCommand) {
    return compute(_computeFunctionTransmit, {
      'h_card': hCard,
      'active_protocol': activeProtocol,
      'command': sendCommand
    });
  }

  Future<Uint8List> _transmitInSameIsolate(
      int hCard, int activeProtocol, List<int> sendCommand) {
    var nativeSendCommand = _allocateNative(sendCommand);

    var pcbRecvLength = calloc<DWORD>();
    pcbRecvLength.value = PcscConstants.MAX_BUFFER_SIZE_EXTENDED;
    var pbRecvBuffer = calloc<ffi.Uint8>(pcbRecvLength.value);

    try {
      ffi.Pointer<SCARD_IO_REQUEST> pioSendPci = _getPCI(activeProtocol);

      var res = _nlwinscard.SCardTransmit(hCard, pioSendPci, nativeSendCommand,
          sendCommand.length, _nullptr, pbRecvBuffer, pcbRecvLength);
      _checkAndThrow(res, 'Error while transmitting to card');

      Uint8List response = _asUint8List(pbRecvBuffer, pcbRecvLength.value);

      return Future.value(response);
    } finally {
      calloc.free(nativeSendCommand);
      calloc.free(pcbRecvLength);
      calloc.free(pbRecvBuffer);
    }
  }

  Map _buildMapData(SCARD_READERSTATE readerState) {
    Map pcscData = {};
    Uint8List atr = Uint8List(readerState.cbAtr);
    for (int i = 0; i < readerState.cbAtr; i++) {
      atr[i] = readerState.rgbAtr[i];
    }
    pcscData['atr'] = atr;

    Map data = {};
    data['pcsc_tag'] = pcscData;

    return data;
  }

  List<String> _decodemstr(Int8List list) {
    List<String> result = List.empty(growable: true);
    int prevPos = 0;
    while (prevPos < list.length) {
      int pos = list.indexOf(0, prevPos);
      if (pos == -1) {
        pos = list.length;
      }
      if (prevPos != pos) {
        String s = String.fromCharCodes(
            Uint8List.fromList(list.sublist(prevPos, pos)));
        result.add(s);
      }
      prevPos = pos + 1;
    }
    return result;
  }

  ffi.Pointer<ffi.Uint8> _allocateNative(List<int> buffer) {
    var result = calloc<ffi.Uint8>(buffer.length);
    var bufferView = result.asTypedList(buffer.length);
    bufferView.setAll(0, buffer);

    return result;
  }

  ffi.Pointer<SCARD_IO_REQUEST> _getPCI(int activeProtocol) {
    ffi.Pointer<SCARD_IO_REQUEST> pioSendPci;

    if (activeProtocol == PcscConstants.SCARD_PROTOCOL_T0) {
      pioSendPci = _scardT0Pci;
    } else {
      pioSendPci = _scardT1Pci;
    }

    return pioSendPci;
  }

  Int8List _asInt8List(ffi.Pointer<ffi.Int8> p, int length) {
    Int8List result = Int8List(length);
    for (int i = 0; i < length; i++) {
      result[i] = p[i];
    }
    return result;
  }

  Uint8List _asUint8List(ffi.Pointer<ffi.Uint8> p, int length) {
    Uint8List result = Uint8List(length);
    for (int i = 0; i < length; i++) {
      result[i] = p[i];
    }
    return result;
  }
}
