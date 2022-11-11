String formatDate(String data, bool porExtenso, bool returnTime) {
  final Map _months = {
    1: "janeiro",
    2: "fevereiro",
    3: "março",
    4: "abril",
    5: "maio",
    6: "junho",
    7: "julho",
    8: "agosto",
    9: "setembro",
    10: "outubro",
    11: "novembro",
    12: "dezembro"
  };

  DateTime date = DateTime.parse(data);

  String dateFormat = """${date.day.toString().padLeft(2,'0')}${porExtenso ? ' de ' : '/'}${porExtenso ? _months[date.month] : date.month.toString().padLeft(2, '0')}${porExtenso ? ' de ' : '/'}${date.year}""";

  if (returnTime) {
    String timeFormat = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    dateFormat += " $timeFormat";
  }

  return dateFormat.replaceAll("\n", "").replaceAll("\r\n", "").replaceAll("\r", "");
}