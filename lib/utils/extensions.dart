extension DateTimeExtensions on DateTime {
  String format() {
    return "$day, ${months[month - 1]}";
  }
}

List<String> months = [
  "Yanvar",
  "Fevral",
  "Mart",
  "Aprel",
  "May",
  "Iyun",
  "Iyul",
  "Avgust",
  "Sentabr",
  "Oktabr",
  "Noyabr",
  "Dekabr",
];
