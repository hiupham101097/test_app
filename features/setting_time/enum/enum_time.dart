enum EnumTime {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY;

  String getNamEn(EnumTime enumTime) {
    switch (enumTime) {
      case EnumTime.MONDAY:
        return "MONDAY";
      case EnumTime.TUESDAY:
        return "TUESDAY";
      case EnumTime.WEDNESDAY:
        return "WEDNESDAY";
      case EnumTime.THURSDAY:
        return "THURSDAY";
      case EnumTime.FRIDAY:
        return "FRIDAY";
      case EnumTime.SATURDAY:
        return "SATURDAY";
      case EnumTime.SUNDAY:
        return "SUNDAY";
    }
  }

  String getNamVi(EnumTime enumTime) {
    switch (enumTime) {
      case EnumTime.MONDAY:
        return "Thứ hai";
      case EnumTime.TUESDAY:
        return "Thứ ba";
      case EnumTime.WEDNESDAY:
        return "Thứ tư";
      case EnumTime.THURSDAY:
        return "Thứ năm";
      case EnumTime.FRIDAY:
        return "Thứ sáu";
      case EnumTime.SATURDAY:
        return "Thứ bảy";
      case EnumTime.SUNDAY:
        return "Chủ nhật";
    }
  }
}
