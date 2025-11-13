import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(
    () {
      GoogleFonts.config.allowRuntimeFetching = false;
    },
  );

  group('Constants Tests', () {
    // Test BASE_IMAGE_URL
    test('BASE_IMAGE_URL should be defined correctly', () {
      expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
      expect(BASE_IMAGE_URL, isNotEmpty);
    });

    // Test Color Constants
    group('Color Constants', () {
      test('kRichBlack should be defined', () {
        expect(kRichBlack, const Color(0xFF000814));
        expect(kRichBlack.value, 0xFF000814);
      });

      test('kOxfordBlue should be defined', () {
        expect(kOxfordBlue, const Color(0xFF001D3D));
        expect(kOxfordBlue.value, 0xFF001D3D);
      });

      test('kPrussianBlue should be defined', () {
        expect(kPrussianBlue, const Color(0xFF003566));
        expect(kPrussianBlue.value, 0xFF003566);
      });

      test('kMikadoYellow should be defined', () {
        expect(kMikadoYellow, const Color(0xFFffc300));
        expect(kMikadoYellow.value, 0xFFffc300);
      });

      test('kDavysGrey should be defined', () {
        expect(kDavysGrey, const Color(0xFF4B5358));
        expect(kDavysGrey.value, 0xFF4B5358);
      });

      test('kGrey should be defined', () {
        expect(kGrey, const Color(0xFF303030));
        expect(kGrey.value, 0xFF303030);
      });
    });

    // Test Text Styles
    group('Text Styles', () {
      test('kHeading5 should have correct properties', () {
        expect(kHeading5, isNotNull);
        expect(kHeading5.fontSize, 23);
        expect(kHeading5.fontWeight, FontWeight.w400);
        expect(kHeading5.fontFamily, contains('Poppins'));
      });

      test('kHeading6 should have correct properties', () {
        expect(kHeading6, isNotNull);
        expect(kHeading6.fontSize, 19);
        expect(kHeading6.fontWeight, FontWeight.w500);
        expect(kHeading6.letterSpacing, 0.15);
        expect(kHeading6.fontFamily, contains('Poppins'));
      });

      test('kSubtitle should have correct properties', () {
        expect(kSubtitle, isNotNull);
        expect(kSubtitle.fontSize, 15);
        expect(kSubtitle.fontWeight, FontWeight.w400);
        expect(kSubtitle.letterSpacing, 0.15);
        expect(kSubtitle.fontFamily, contains('Poppins'));
      });

      test('kBodyText should have correct properties', () {
        expect(kBodyText, isNotNull);
        expect(kBodyText.fontSize, 13);
        expect(kBodyText.fontWeight, FontWeight.w400);
        expect(kBodyText.letterSpacing, 0.25);
        expect(kBodyText.fontFamily, contains('Poppins'));
      });
    });

    // Test Text Theme
    group('Text Theme', () {
      test('kTextTheme should be defined correctly', () {
        expect(kTextTheme, isNotNull);
        expect(kTextTheme.headlineMedium, isNotNull);
        expect(kTextTheme.headlineSmall, isNotNull);
        expect(kTextTheme.labelMedium, isNotNull);
        expect(kTextTheme.bodyMedium, isNotNull);
      });

      test('kTextTheme headlineMedium should match kHeading5', () {
        expect(kTextTheme.headlineMedium, kHeading5);
        expect(kTextTheme.headlineMedium?.fontSize, 23);
      });

      test('kTextTheme headlineSmall should match kHeading6', () {
        expect(kTextTheme.headlineSmall, kHeading6);
        expect(kTextTheme.headlineSmall?.fontSize, 19);
      });

      test('kTextTheme labelMedium should match kSubtitle', () {
        expect(kTextTheme.labelMedium, kSubtitle);
        expect(kTextTheme.labelMedium?.fontSize, 15);
      });

      test('kTextTheme bodyMedium should match kBodyText', () {
        expect(kTextTheme.bodyMedium, kBodyText);
        expect(kTextTheme.bodyMedium?.fontSize, 13);
      });
    });

    // Test Drawer Theme
    group('Drawer Theme', () {
      test('kDrawerTheme should be defined', () {
        expect(kDrawerTheme, isNotNull);
        expect(kDrawerTheme.backgroundColor, isNotNull);
      });

      test('kDrawerTheme backgroundColor should be grey shade 700', () {
        expect(kDrawerTheme.backgroundColor, Colors.grey.shade700);
      });
    });

    // Test Color Scheme
    group('Color Scheme', () {
      test('kColorScheme should be defined', () {
        expect(kColorScheme, isNotNull);
        expect(kColorScheme.brightness, Brightness.dark);
      });

      test('kColorScheme primary should be kMikadoYellow', () {
        expect(kColorScheme.primary, kMikadoYellow);
      });

      test('kColorScheme secondary should be kPrussianBlue', () {
        expect(kColorScheme.secondary, kPrussianBlue);
      });

      test('kColorScheme secondaryContainer should be kPrussianBlue', () {
        expect(kColorScheme.secondaryContainer, kPrussianBlue);
      });

      test('kColorScheme surface should be kRichBlack', () {
        expect(kColorScheme.surface, kRichBlack);
      });

      test('kColorScheme error should be Colors.red', () {
        expect(kColorScheme.error, Colors.red);
      });

      test('kColorScheme onPrimary should be kRichBlack', () {
        expect(kColorScheme.onPrimary, kRichBlack);
      });

      test('kColorScheme onSecondary should be white', () {
        expect(kColorScheme.onSecondary, Colors.white);
      });

      test('kColorScheme onSurface should be white', () {
        expect(kColorScheme.onSurface, Colors.white);
      });

      test('kColorScheme onError should be white', () {
        expect(kColorScheme.onError, Colors.white);
      });
    });
  });
}
