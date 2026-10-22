import 'package:flutter_test/flutter_test.dart';
import 'package:hava_durumu/utils/text_utils.dart';

void main() {
  group('capitalizeTr', () {
    test('ilk harfi büyütür', () {
      expect(capitalizeTr('parçalı bulutlu'), 'Parçalı bulutlu');
    });

    test('Türkçe i harfini İ yapar', () {
      expect(capitalizeTr('iyi hava'), 'İyi hava');
    });

    test('boş metinde hata vermez', () {
      expect(capitalizeTr(''), '');
    });
  });
}
