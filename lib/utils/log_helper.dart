import "dart:developer";

// void myDebugPrint(String text, {String? headerText}) {
//   final RegExp pattern = RegExp(".{1,800}"); // 800 is the size of each chunk
//   pattern
//       .allMatches(text)
//       .forEach((RegExpMatch match) => debugPrint(match.group(0)));
//   if (headerText != null) {
//     printHeader(headerText);
//   }
// }

void printHeader(String title) {
  log("---------------------------$title---------------------------------");
}
