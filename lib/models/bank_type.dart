enum BankType {
  cbe,
  cbeBirr,
  boa,
  dashen,
  hibret,
  telebirr,
  amole,
  ebirr,
  mpesa,
  other
}

extension BankTypeExtension on BankType {
  String get name {
    switch (this) {
      case BankType.cbe:
        return 'CBE';
      case BankType.cbeBirr:
        return 'CBEBirr';
      case BankType.boa:
        return 'BOA';
      case BankType.dashen:
        return 'Dashen';
      case BankType.hibret:
        return 'Hibret';
      case BankType.telebirr:
        return 'TeleBirr';
      case BankType.amole:
        return 'Amole';
      case BankType.ebirr:
        return 'eBirr';
      case BankType.mpesa:
        return 'M-PESA';
      case BankType.other:
        return 'Other';
    }
  }
}
