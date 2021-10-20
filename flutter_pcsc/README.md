# flutter_pcsc

A Flutter plugin for using PCSC smartcard readers on Windows/macOS/Linux.

## Usage

### Pre-requisite

A PCSC smartcard reader.

On linux, `pcscd` & `libpcsclite1` needs to be installed.

### Example
``` dart
  int ctx = await Pcsc.establishContext(PcscSCope.user);
  List<String> readers = await Pcsc.listReaders(ctx);

  if (readers.isEmpty) {
    print('Could not detect any reader');
  } else {
    String reader = readers[0]; // let's use the first available reader

    CardStruct card = await Pcsc.cardConnect(ctx, reader, PcscShare.shared, PcscProtocol.any);
    var response = await Pcsc.transmit(card, [0xFF, 0xCA, 0x00, 0x00, 0x00]);
    print('Response: $response');
        
    await Pcsc.cardDisconnect(card.hCard, PcscDisposition.resetCard);
  }
  await Pcsc.releaseContext(ctx);

```

### Note on macOS apps

For macOS application to be able to use smartcard, the following entitlement should be set: `com.apple.security.smartcard` (in DebugProfile.entitlements & Release.entitlements files).
Please have a look at the example.

If not set correctly, the context won't be able to be established.
