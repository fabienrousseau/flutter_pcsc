# flutter_pcsc

A Flutter plugin for using PCSC smartcard readers on Windows/macOS/Linux.

## Usage

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