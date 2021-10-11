class PcscConstants {
  // Limits
  static const int PCSCLITE_MAX_READERS_CONTEXTS = 16;
  static const int MAX_READERNAME = 128;
  static const int MAX_BUFFER_SIZE = 264;

  static const int MAX_BUFFER_SIZE_EXTENDED = 65548;

  // Scope
  static const int CARD_SCOPE_USER = 0x0000;
  static const int CARD_SCOPE_TERMINAL = 0x0001;
  static const int CARD_SCOPE_SYSTEM = 0x0002;
  // Limits
  static const int MAX_ATR_SIZE = 33;
  static const int MAX_ATR_SIZE_PADDING = 3;
  // States (Internal)
  static const int SCARD_UNKNOWN = 0x0001;
  static const int SCARD_ABSENT = 0x0002;
  static const int SCARD_PRESENT = 0x0004;
  static const int SCARD_SWALLOWED = 0x0008;
  static const int SCARD_POWERED = 0x0010;
  static const int SCARD_NEGOTIABLE = 0x0020;
  static const int SCARD_SPECIFIC = 0x0040;
  // States (GetStatusChange)
  static const int SCARD_STATE_UNAWARE = 0x0000;
  static const int SCARD_STATE_IGNORE = 0x0001;
  static const int SCARD_STATE_CHANGED = 0x0002;
  static const int SCARD_STATE_UNKNOWN = 0x0004;
  static const int SCARD_STATE_UNAVAILABLE = 0x0008;
  static const int SCARD_STATE_EMPTY = 0x0010;
  static const int SCARD_STATE_PRESENT = 0x0020;
  static const int SCARD_STATE_ATRMATCH = 0x0040;
  static const int SCARD_STATE_EXCLUSIVE = 0x0080;
  static const int SCARD_STATE_INUSE = 0x0100;
  static const int SCARD_STATE_MUTE = 0x0200;
  static const int SCARD_STATE_UNPOWERED = 0x0400;
  // Protocols
  static const int SCARD_PROTOCOL_UNDEFINED = 0x0000;
  static const int SCARD_PROTOCOL_T0 = 0x0001;
  static const int SCARD_PROTOCOL_T1 = 0x0002;
  static const int SCARD_PROTOCOL_RAW = 0x0004;
  static const int SCARD_PROTOCOL_T15 = 0x0008;
  static const int SCARD_PROTOCOL_ANY = (SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1);
  // Sharing
  static const int SCARD_SHARE_EXCLUSIVE = 0x0001;
  static const int SCARD_SHARE_SHARED = 0x0002;
  static const int SCARD_SHARE_DIRECT = 0x0003;
  // Disconnect
  static const int SCARD_LEAVE_CARD = 0x0000;
  static const int SCARD_RESET_CARD = 0x0001;
  static const int SCARD_UNPOWER_CARD = 0x0002;
  static const int SCARD_EJECT_CARD = 0x0003;
  // Errors
  static const int SCARD_S_SUCCESS = 0x00000000;
  static const int SCARD_F_INTERNAL_ERROR = 0x80100001;
  static const int SCARD_E_CANCELLED = 0x80100002;
  static const int SCARD_E_INVALID_HANDLE = 0x80100003;
  static const int SCARD_E_INVALID_PARAMETER = 0x80100004;
  static const int SCARD_E_INVALID_TARGET = 0x80100005;
  static const int SCARD_E_NO_MEMORY = 0x80100006;
  static const int SCARD_F_WAITED_TOO_LONG = 0x80100007;
  static const int SCARD_E_INSUFFICIENT_BUFFER = 0x80100008;
  static const int SCARD_E_UNKNOWN_READER = 0x80100009;
  static const int SCARD_E_TIMEOUT = 0x8010000A;
  static const int SCARD_E_SHARING_VIOLATION = 0x8010000B;
  static const int SCARD_E_NO_SMARTCARD = 0x8010000C;
  static const int SCARD_E_UNKNOWN_CARD = 0x8010000D;
  static const int SCARD_E_CANT_DISPOSE = 0x8010000E;
  static const int SCARD_E_PROTO_MISMATCH = 0x8010000F;
  static const int SCARD_E_NOT_READY = 0x80100010;
  static const int SCARD_E_INVALID_VALUE = 0x80100011;
  static const int SCARD_E_SYSTEM_CANCELLED = 0x80100012;
  static const int SCARD_F_COMM_ERROR = 0x80100013;
  static const int SCARD_F_UNKNOWN_ERROR = 0x80100014;
  static const int SCARD_E_INVALID_ATR = 0x80100015;
  static const int SCARD_E_NOT_TRANSACTED = 0x80100016;
  static const int SCARD_E_READER_UNAVAILABLE = 0x80100017;
  static const int SCARD_P_SHUTDOWN = 0x80100018;
  static const int SCARD_E_PCI_TOO_SMALL = 0x80100019;
  static const int SCARD_E_READER_UNSUPPORTED = 0x8010001A;
  static const int SCARD_E_DUPLICATE_READER = 0x8010001B;
  static const int SCARD_E_CARD_UNSUPPORTED = 0x8010001C;
  static const int SCARD_E_NO_SERVICE = 0x8010001D;
  static const int SCARD_E_SERVICE_STOPPED = 0x8010001E;
  static const int SCARD_E_UNEXPECTED = 0x8010001F;
  static const int SCARD_E_ICC_INSTALLATION = 0x80100020;
  static const int SCARD_E_ICC_CREATEORDER = 0x80100021;
  static const int SCARD_E_UNSUPPORTED_FEATURE = 0x80100022;
  static const int SCARD_E_DIR_NOT_FOUND = 0x80100023;
  static const int SCARD_E_FILE_NOT_FOUND = 0x80100024;
  static const int SCARD_E_NO_DIR = 0x80100025;
  static const int SCARD_E_NO_FILE = 0x80100026;
  static const int SCARD_E_NO_ACCESS = 0x80100027;
  static const int SCARD_E_WRITE_TOO_MANY = 0x80100028;
  static const int SCARD_E_BAD_SEEK = 0x80100029;
  static const int SCARD_E_INVALID_CHV = 0x8010002A;
  static const int SCARD_E_UNKNOWN_RES_MNG = 0x8010002B;
  static const int SCARD_E_NO_SUCH_CERTIFICATE = 0x8010002C;
  static const int SCARD_E_CERTIFICATE_UNAVAILABLE = 0x8010002D;
  static const int SCARD_E_NO_READERS_AVAILABLE = 0x8010002E;
  static const int SCARD_E_COMM_DATA_LOST = 0x8010002F;
  static const int SCARD_E_NO_KEY_CONTAINER = 0x80100030;
  static const int SCARD_E_SERVER_TOO_BUSY = 0x80100031;
  static const int SCARD_W_UNSUPPORTED_CARD = 0x80100065;
  static const int SCARD_W_UNRESPONSIVE_CARD = 0x80100066;
  static const int SCARD_W_UNPOWERED_CARD = 0x80100067;
  static const int SCARD_W_RESET_CARD = 0x80100068;
  static const int SCARD_W_REMOVED_CARD = 0x80100069;
  static const int SCARD_W_SECURITY_VIOLATION = 0x8010006A;
  static const int SCARD_W_WRONG_CHV = 0x8010006B;
  static const int SCARD_W_CHV_BLOCKED = 0x8010006C;
  static const int SCARD_W_EOF = 0x8010006D;
  static const int SCARD_W_CANCELLED_BY_USER = 0x8010006E;
  static const int SCARD_W_CARD_NOT_AUTHENTICATED = 0x8010006F;
  // Others
  static const int SCARD_INFINITE = 0xFFFFFFFF;
  // Attributes
  static const int SCARD_CLASS_ICC_STATE = 9;
  static const int SCARD_ATTR_ATR_STRING =
      (SCARD_CLASS_ICC_STATE << 16 | 0x0303);

  static String errorToString(int code) {
    switch (code.toUnsigned(32)) {
      case SCARD_S_SUCCESS:
        return 'SCARD_S_SUCCESS';
      case SCARD_F_INTERNAL_ERROR:
        return 'SCARD_F_INTERNAL_ERROR';
      case SCARD_E_CANCELLED:
        return 'SCARD_E_CANCELLED';
      case SCARD_E_INVALID_HANDLE:
        return 'SCARD_E_INVALID_HANDLE';
      case SCARD_E_INVALID_PARAMETER:
        return 'SCARD_E_INVALID_PARAMETER';
      case SCARD_E_INVALID_TARGET:
        return 'SCARD_E_INVALID_TARGET';
      case SCARD_E_NO_MEMORY:
        return 'SCARD_E_NO_MEMORY';
      case SCARD_F_WAITED_TOO_LONG:
        return 'SCARD_F_WAITED_TOO_LONG';
      case SCARD_E_INSUFFICIENT_BUFFER:
        return 'SCARD_E_INSUFFICIENT_BUFFER';
      case SCARD_E_UNKNOWN_READER:
        return 'SCARD_E_UNKNOWN_READER';
      case SCARD_E_TIMEOUT:
        return 'SCARD_E_TIMEOUT';
      case SCARD_E_SHARING_VIOLATION:
        return 'SCARD_E_SHARING_VIOLATION';
      case SCARD_E_NO_SMARTCARD:
        return 'SCARD_E_NO_SMARTCARD';
      case SCARD_E_UNKNOWN_CARD:
        return 'SCARD_E_UNKNOWN_CARD';
      case SCARD_E_CANT_DISPOSE:
        return 'SCARD_E_CANT_DISPOSE';
      case SCARD_E_PROTO_MISMATCH:
        return 'SCARD_E_PROTO_MISMATCH';
      case SCARD_E_NOT_READY:
        return 'SCARD_E_NOT_READY';
      case SCARD_E_INVALID_VALUE:
        return 'SCARD_E_INVALID_VALUE';
      case SCARD_E_SYSTEM_CANCELLED:
        return 'SCARD_E_SYSTEM_CANCELLED';
      case SCARD_F_COMM_ERROR:
        return 'SCARD_F_COMM_ERROR';
      case SCARD_F_UNKNOWN_ERROR:
        return 'SCARD_F_UNKNOWN_ERROR';
      case SCARD_E_INVALID_ATR:
        return 'SCARD_E_INVALID_ATR';
      case SCARD_E_NOT_TRANSACTED:
        return 'SCARD_E_NOT_TRANSACTED';
      case SCARD_E_READER_UNAVAILABLE:
        return 'SCARD_E_READER_UNAVAILABLE';
      case SCARD_P_SHUTDOWN:
        return 'SCARD_P_SHUTDOWN';
      case SCARD_E_PCI_TOO_SMALL:
        return 'SCARD_E_PCI_TOO_SMALL';
      case SCARD_E_READER_UNSUPPORTED:
        return 'SCARD_E_READER_UNSUPPORTED';
      case SCARD_E_DUPLICATE_READER:
        return 'SCARD_E_DUPLICATE_READER';
      case SCARD_E_CARD_UNSUPPORTED:
        return 'SCARD_E_CARD_UNSUPPORTED';
      case SCARD_E_NO_SERVICE:
        return 'SCARD_E_NO_SERVICE';
      case SCARD_E_SERVICE_STOPPED:
        return 'SCARD_E_SERVICE_STOPPED';
      case SCARD_E_UNEXPECTED:
        return 'SCARD_E_UNEXPECTED';
      case SCARD_E_ICC_INSTALLATION:
        return 'SCARD_E_ICC_INSTALLATION';
      case SCARD_E_ICC_CREATEORDER:
        return 'SCARD_E_ICC_CREATEORDER';
      case SCARD_E_UNSUPPORTED_FEATURE:
        return 'SCARD_E_UNSUPPORTED_FEATURE';
      case SCARD_E_DIR_NOT_FOUND:
        return 'SCARD_E_DIR_NOT_FOUND';
      case SCARD_E_FILE_NOT_FOUND:
        return 'SCARD_E_FILE_NOT_FOUND';
      case SCARD_E_NO_DIR:
        return 'SCARD_E_NO_DIR';
      case SCARD_E_NO_FILE:
        return 'SCARD_E_NO_FILE';
      case SCARD_E_NO_ACCESS:
        return 'SCARD_E_NO_ACCESS';
      case SCARD_E_WRITE_TOO_MANY:
        return 'SCARD_E_WRITE_TOO_MANY';
      case SCARD_E_BAD_SEEK:
        return 'SCARD_E_BAD_SEEK';
      case SCARD_E_INVALID_CHV:
        return 'SCARD_E_INVALID_CHV';
      case SCARD_E_UNKNOWN_RES_MNG:
        return 'SCARD_E_UNKNOWN_RES_MNG';
      case SCARD_E_NO_SUCH_CERTIFICATE:
        return 'SCARD_E_NO_SUCH_CERTIFICATE';
      case SCARD_E_CERTIFICATE_UNAVAILABLE:
        return 'SCARD_E_CERTIFICATE_UNAVAILABLE';
      case SCARD_E_NO_READERS_AVAILABLE:
        return 'SCARD_E_NO_READERS_AVAILABLE';
      case SCARD_E_COMM_DATA_LOST:
        return 'SCARD_E_COMM_DATA_LOST';
      case SCARD_E_NO_KEY_CONTAINER:
        return 'SCARD_E_NO_KEY_CONTAINER';
      case SCARD_E_SERVER_TOO_BUSY:
        return 'SCARD_E_SERVER_TOO_BUSY';
      case SCARD_W_UNSUPPORTED_CARD:
        return 'SCARD_W_UNSUPPORTED_CARD';
      case SCARD_W_UNRESPONSIVE_CARD:
        return 'SCARD_W_UNRESPONSIVE_CARD';
      case SCARD_W_UNPOWERED_CARD:
        return 'SCARD_W_UNPOWERED_CARD';
      case SCARD_W_RESET_CARD:
        return 'SCARD_W_RESET_CARD';
      case SCARD_W_REMOVED_CARD:
        return 'SCARD_W_REMOVED_CARD';
      case SCARD_W_SECURITY_VIOLATION:
        return 'SCARD_W_SECURITY_VIOLATION';
      case SCARD_W_WRONG_CHV:
        return 'SCARD_W_WRONG_CHV';
      case SCARD_W_CHV_BLOCKED:
        return 'SCARD_W_CHV_BLOCKED';
      case SCARD_W_EOF:
        return 'SCARD_W_EOF';
      case SCARD_W_CANCELLED_BY_USER:
        return 'SCARD_W_CANCELLED_BY_USER';
      case SCARD_W_CARD_NOT_AUTHENTICATED:
        return 'SCARD_W_CARD_NOT_AUTHENTICATED';

      default:
        return 'Unknown error $code';
    }
  }
}
