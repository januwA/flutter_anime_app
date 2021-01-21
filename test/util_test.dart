import 'package:flutter_test/flutter_test.dart';
import 'package:anime_app/utils/get_extraction_code.dart';

void main() {
  group('util Test', () {
    test('getExtractionCode Test', () {
      expect(getExtractionCode('更新至01集,提取码:cx7z'), 'cx7z');
      expect(getExtractionCode('更新至01集,提取码：cx7z'), 'cx7z');
    });
  });
}
