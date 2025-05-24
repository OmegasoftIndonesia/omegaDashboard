import 'package:intl/intl.dart';

class FormatThousand {
  static String convertToThousand(dynamic number) {
    var formatter = NumberFormat('#,###');
    return formatter.format(int.parse(number)).replaceAll(',', '.');
  }
}
