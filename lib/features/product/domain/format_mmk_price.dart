import 'package:intl/intl.dart';

final _mmk = NumberFormat('#,###');

String formatMmkPrice(int amountMmk) => '${_mmk.format(amountMmk)} Ks';
