# Changelog

## 0.1.0

- Initial release of textstyle_generator.
- Generate TextStyle helper methods for all font sizes and weights.
- Supports multiple font families.
- Supports default text color palette customization.
- Fully configurable via build.yaml.
- Works with build_runner.e color configuration

## 0.1.1

- Fix some fonts.

## 0.1.2

- Added support for dynamic output directory configuration via the output_dir option in build.yaml.
- You can now control where the generated text_styles.g.dart file is placed without modifying the builder code.
- Defaults to lib/generated/ if output_dir is not specified.
- Added letterSpacing.
