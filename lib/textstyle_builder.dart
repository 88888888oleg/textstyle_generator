import 'dart:async';
import 'dart:io';
import 'package:build/build.dart';

/// Builder for generating text styles based on font files in the project.
class TextStyleBuilder implements Builder {
  /// Options passed from build.yaml configuration.
  final BuilderOptions options;

  TextStyleBuilder(this.options);

  @override
  /// Maps input files to output files for the build step.
  Map<String, List<String>> get buildExtensions => const {
    r'lib/textstyle_generator_trigger.dart': [
      'lib/generated/text_styles.g.dart'
    ],
  };

  /// The default color if none is specified in the configuration.
  static const defaultColor = 'const Color(0xFF000000)';

  @override
  /// Main method to generate the output file.
  Future<void> build(BuildStep buildStep) async {
    /// Reading the configuration from build.yaml
    final config = options.config;

    /// Path to the fonts directory
    final fontPath = config['font_path'] as String? ?? 'assets/fonts/';
    /// Minimum font size to generate
    final min = config['min'] as int? ?? 8;
    /// Maximum font size to generate
    final max = config['max'] as int? ?? 64;
    /// Default text color to use
    final defaultColorSetting =
        config['default_palette'] as String? ?? defaultColor;

    /// Output file ID for the generated text styles
    final outputId =
    AssetId(buildStep.inputId.package, 'lib/generated/text_styles.g.dart');
    final fontsDir = Directory(fontPath);

    /// Check if the fonts directory exists
    if (!fontsDir.existsSync()) {
      await buildStep.writeAsString(outputId,
          _emptyGeneratedFile('Fonts directory "$fontPath" does not exist.'));
      log.severe(
          '[textstyle_generator] Fonts directory "$fontPath" does not exist.');
      return;
    }

    /// List of all .ttf and .otf font files
    final fontFiles = fontsDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.ttf') || f.path.endsWith('.otf'))
        .toList();

    /// Check if any fonts were found
    if (fontFiles.isEmpty) {
      await buildStep.writeAsString(
          outputId, _emptyGeneratedFile('No font files found at "$fontPath".'));
      log.severe('[textstyle_generator] No font files found in "$fontPath".');
      return;
    }

    /// Buffer for writing the Dart output file
    final buffer = StringBuffer();
    /// Set of already generated method names to avoid duplicates
    final generatedMethodNames = <String>{};

    /// Writing the file header
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// *****************************************************');
    buffer.writeln('//  textstyle_generator');
    buffer.writeln('// *****************************************************\n');
    buffer.writeln("part of '../textstyle_generator_trigger.dart';\n");

    /// Start of the TextStyles class
    buffer.writeln('class TextStyles {');
    buffer.writeln('  const TextStyles._();\n');

    /// Iterate over all font files
    for (var i = 0; i < fontFiles.length; i++) {
      final fontFile = fontFiles[i];
      final name = fontFile.uri.pathSegments.last.split('.').first;
      final familyParts = name.split('-');
      final baseFamily = familyParts.first;
      final fontLower = _normalizeFamilyName(baseFamily);
      final parsed = _parseFontDescriptor(
          familyParts.length > 1 ? familyParts[1] : 'Regular');

      /// Generate methods for each font size
      for (var size = min; size <= max; size++) {
        final methodName = '$fontLower${size}w${parsed.weight}${parsed.suffix}';

        if (generatedMethodNames.contains(methodName)) {
          continue;
        }
        generatedMethodNames.add(methodName);

        final fontFullName = name;

        /// Write a method for a specific text style
        buffer.writeln(
            '  static TextStyle $methodName({Color? c, double? h}) => TextStyle(');
        buffer.writeln("    fontFamily: '$fontFullName',");
        buffer.writeln('    fontSize: $size,');
        buffer.writeln('    fontWeight: FontWeight.w${parsed.weight},');
        buffer.writeln('    color: c ?? $defaultColorSetting,');
        buffer.writeln('    height: h,');
        buffer.writeln('  );\n');
      }
    }

    /// End of the TextStyles class
    buffer.writeln('}');

    /// Save the final output file
    await buildStep.writeAsString(outputId, buffer.toString());

    log.info(
        '[textstyle_generator] Successfully generated: lib/generated/text_styles.g.dart');
  }

  /// Normalize font family names into a valid Dart method naming format.
  String _normalizeFamilyName(String name) {
    final parts = name.split(RegExp(r'[^A-Za-z0-9]'));
    final filtered = parts.where((p) => p.isNotEmpty).toList();
    if (filtered.isEmpty) return name.toLowerCase();
    final first = filtered.first.toLowerCase();
    final rest = filtered
        .skip(1)
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join();
    return first + rest;
  }

  /// Parse font descriptor into weight and suffix.
  _FontParsed _parseFontDescriptor(String descriptor) {
    final desc = descriptor.toLowerCase();
    if (desc.contains('bolditalic')) return _FontParsed(700, 'bi');
    if (desc.contains('mediumitalic')) return _FontParsed(500, 'mi');
    if (desc.contains('lightitalic')) return _FontParsed(300, 'li');
    if (desc.contains('blackitalic')) return _FontParsed(900, 'bi');
    if (desc.contains('italic')) return _FontParsed(400, 'i');
    if (desc.contains('extrabold')) return _FontParsed(800, 'eb');
    if (desc.contains('extralight')) return _FontParsed(200, 'l');
    if (desc.contains('light')) return _FontParsed(300, 'l');
    if (desc.contains('medium')) return _FontParsed(500, 'm');
    if (desc.contains('semibold')) return _FontParsed(600, 'sb');
    if (desc.contains('bold')) return _FontParsed(700, 'b');
    if (desc.contains('black')) return _FontParsed(900, 'b');
    if (desc.contains('regular')) return _FontParsed(400, '');
    return _FontParsed(400, '');
  }

  /// Generate an empty output file if no fonts are found.
  String _emptyGeneratedFile(String message) {
    return '''
// GENERATED CODE - EMPTY
// Reason: $message
part of '../textstyle_generator_trigger.dart';
''';
  }
}

/// Class to hold parsed font weight and suffix information.
class _FontParsed {
  final int weight;
  final String suffix;

  String get original => _originalFromWeightSuffix();

  _FontParsed(this.weight, this.suffix);

  /// Converts suffix back to a readable font name.
  String _originalFromWeightSuffix() {
    switch (suffix) {
      case 'l':
        return 'Light';
      case 'li':
        return 'LightItalic';
      case 'm':
        return 'Medium';
      case 'mi':
        return 'MediumItalic';
      case 'sb':
        return 'SemiBold';
      case 'b':
        return 'Bold';
      case 'eb':
        return 'ExtraBold';
      case 'bi':
        return 'BoldItalic';
      case 'i':
        return 'Italic';
      default:
        return 'Regular';
    }
  }
}
