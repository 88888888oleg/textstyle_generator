# textstyle_generator

⚡️ A Flutter code generator to automatically create `TextStyle` helpers for your project from your custom fonts!

---

## ✨ Features

- Generates short, clear methods like `style16w400m({Color? c, double? h})`
- Supports all font sizes (default from 8 to 64)
- Detects and maps font weight (400, 500, 700) automatically
- Detects suffixes based on font family names (e.g., `m`, `b`, `i`, `bi`)
- Allows overriding the default text color using your custom palette
- Highly configurable via `build.yaml`
- No need for manually writing hundreds of `TextStyle` constructors
- Works perfectly with Flutter's `build_runner`

---

## 📋 Requirements

You must create a trigger file at `lib/textstyle_generator_trigger.dart`.

The trigger file must contain at least:
- An import for `package:flutter/material.dart`.
- An import for your palette file if you want to override the default text color.
- A `part 'generated/text_styles.g.dart';` statement.


Example trigger file:

```dart
import 'package:flutter/material.dart';
/// Imports the palette file that defines your default text color.
import 'palette.dart';

part 'generated/text_styles.g.dart';
```
If no custom palette is provided, the default text color will be const Color(0xFF000000) (pure black).


## 🚀 Quick Start

### 1. Add dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  textstyle_generator: ^0.1.0
```

### 2.	Place your fonts:
```text
assets/fonts/
├── Ubuntu-Regular.ttf
├── Ubuntu-Medium.ttf
├── Ubuntu-Bold.ttf
├── Ubuntu-BoldItalic.ttf
└── Ubuntu-Light.ttf
```

###	3. (Optional) Configure build.yaml

```yaml
targets:
  $default:
    builders:
      textstyle_generator|textstyle_builder:
        options:
          font_path: assets/fonts/
          min: 10
          max: 24
          default_palette: Palette().black()
```
```text
Default settings if omitted:
•	font_path: assets/fonts/
•	min: 8
•	max: 64
•	default_palette: const Color(0xFF000000) (pure black)
```

###	4. Run the generator

Use this command to generate your TextStyles:

```sh
dart run build_runner build --delete-conflicting-outputs
```

This will create the file:
lib/generated/text_styles.g.dart

###	5. Use it in your project

```dart
import 'package:your_project/textstyle_generator_trigger.dart';

Text(
  "Hello world!",
  style: TextStyles.style16w400m(c: Colors.blue, h: 1.5),
);
```

•	c: — optional Color (overrides default palette color)
•	h: — optional double height (line height adjustment)

🛠 How font naming and suffixes work

The textstyle_generator parses font file names to automatically detect font weights and styles.
It expects your font files to follow a clear naming convention, typically in the format:

```text
FamilyName-StyleName.ttf
```

For example:
```text
•	Ubuntu-Regular.ttf
•	Ubuntu-Bold.ttf
•	Ubuntu-Italic.ttf
•	Ubuntu-BoldItalic.ttf
•	Ubuntu-Light.ttf
•	Ubuntu-LightItalic.ttf
•	Ubuntu-Medium.ttf
•	Ubuntu-MediumItalic.ttf
```
The generator analyzes the StyleName (part after the hyphen -) and assigns the correct font weight and suffix.

### ✏️ Naming rules

```text
| Style keyword     | Weight  | Suffix |
|:------------------|:--------|:-------|
| Regular           | 400     | (empty) |
| Italic            | 400     | i |
| Light             | 300     | l |
| LightItalic       | 300     | li |
| Medium            | 500     | m |
| MediumItalic      | 500     | mi |
| SemiBold          | 600     | sb |
| Bold              | 700     | b |
| BoldItalic        | 700     | bi |
| ExtraBold         | 800     | eb |
| Black             | 900     | b |
| BlackItalic       | 900     | bi |
| ExtraLight        | 200     | l |
```
🛠 How method names are generated:

The generated method name pattern is:

```text
<baseName><fontSize>w<weight><suffix>()
```
Where:
```text
•	baseName — the normalized family name (e.g., ubuntu)
•	fontSize — the font size
•	weight — the font weight
•	suffix — the style suffix (if any)
```
📋 Example

If you have a font file Ubuntu-BoldItalic.ttf,
and your generator is configured for font size 18,
the generated method will be:

```dart
TextStyles.ubuntu18w700bi()
```

## 📋 Font file to generated method mapping

```text
| Font File                  | Example Size | Generated Method         | Meaning                               |
|:----------------------------|:-------------|:--------------------------|:-------------------------------------|
| Ubuntu-Regular.ttf          | 18           | ubuntu18w400()             | Regular font, weight 400             |
| Ubuntu-Italic.ttf           | 16           | ubuntu16w400i()            | Italic font, weight 400              |
| Ubuntu-Light.ttf            | 14           | ubuntu14w300l()            | Light font, weight 300               |
| Ubuntu-LightItalic.ttf      | 12           | ubuntu12w300li()           | Light + Italic font, weight 300      |
| Ubuntu-Medium.ttf           | 20           | ubuntu20w500m()            | Medium font, weight 500              |
| Ubuntu-MediumItalic.ttf     | 18           | ubuntu18w500mi()           | Medium + Italic font, weight 500     |
| Ubuntu-Bold.ttf             | 22           | ubuntu22w700b()            | Bold font, weight 700                |
| Ubuntu-BoldItalic.ttf       | 24           | ubuntu24w700bi()           | Bold + Italic font, weight 700       |
| Ubuntu-ExtraBold.ttf        | 30           | ubuntu30w800eb()           | ExtraBold font, weight 800           |
| Ubuntu-Black.ttf            | 32           | ubuntu32w900b()            | Black font, weight 900               |
| Ubuntu-BlackItalic.ttf      | 28           | ubuntu28w900bi()           | Black + Italic font, weight 900      |
```

## ☕ Support

If you find this package useful, you can support the development by buying me a coffee!  
Your support helps keep this project active and maintained.

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/mobile_apps)