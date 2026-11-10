import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/product/domain/format_mmk_price.dart';

void main() {
  test('formats thousands with comma and Ks suffix', () {
    expect(formatMmkPrice(3200), '3,200 Ks');
    expect(formatMmkPrice(1200), '1,200 Ks');
  });
}
