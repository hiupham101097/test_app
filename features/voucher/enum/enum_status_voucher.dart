enum StatusVoucherEnum {
  active,
  comingSoon,
  history;

  String getLabel() {
    switch (this) {
      case StatusVoucherEnum.active:
        return 'Đang diễn ra';
      case StatusVoucherEnum.comingSoon:
        return 'Sắp diễn ra';
      case StatusVoucherEnum.history:
        return 'Lịch sử';
    }
  }
}
