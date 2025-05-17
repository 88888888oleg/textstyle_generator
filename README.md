# textstyle_generator

⚡️ A powerful and flexible Flutter code generator that automates creation of `TextStyle` helpers  
from your custom fonts — now with theming support and configurable class names via `build.yaml`!

---
## 🐌 Before

```dart
Text(
  'Hello World',
    style: TextStyle(
    fontFamily: 'SF-Pro-Display-BoldItalic',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    height: 1.2,
    letterSpacing: 0.5,
  ),
)
```

## 🚀 After

```dart
Text(
  'Hello World',
  style: TextStyles.sfProDisplay20w700bi(c: Colors.black, h: 1.2, l: 0.5),
)
```

## 🚀 And After with defaults

```dart
Text(
  'Hello World',
  style: TextStyles.sfProDisplay20w700bi(),
)
```

---

## ✨ Features

- Generates short, clear methods like `style16w400m({Color? c, double? h, double? l,})`
- Supports all font sizes (default from 8 to 64)
- Detects and maps font weight (400, 500, 700) automatically
- Detects suffixes based on font family names (e.g., `m`, `b`, `i`, `bi`)
- Allows overriding the default text color using your custom palette
- ✅ Supports Flutter theming by linking to your palette class
- ✅ `class_name` option allows renaming the generated class (default: `TextStyles`)
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

If no custom palette is provided, the default text color will be `const Color(0xFF000000)` (pure black).

---

## 🚀 Quick Start

### 1. Add dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  textstyle_generator: ^0.1.0
```

### 2. Place your fonts:

```text
assets/fonts/
├── Ubuntu-Regular.ttf
├── Ubuntu-Medium.ttf
├── Ubuntu-Bold.ttf
├── Ubuntu-BoldItalic.ttf
└── Ubuntu-Light.ttf
```

### 3. (Optional) Configure build.yaml

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
          output_dir: lib/generated_assets/
          class_name: MyTextStyles
```

```text
Default settings if omitted:
• font_path: assets/fonts/
• min: 8
• max: 64
• default_palette: const Color(0xFF000000) (pure black)
• output_dir: lib/generated/
• class_name: TextStyles
```

### 4. Run the generator

```sh
dart run build_runner build --delete-conflicting-outputs
```

This will create the file:  
`lib/generated/text_styles.g.dart`

---

### 5. Use it in your project

```dart
import 'package:your_project/textstyle_generator_trigger.dart';

/// You can use the generated text styles directly
Text('Hello world!', style: TextStyles.ubuntu18w400i()),

/// You can use text styles with parameters
Text(
  'Hello world!',
  style: TextStyles.style16w400m(c: Colors.blue, h: 1.5),
);

/// If there are not enough parameters, you can use copyWith()
Text(
  'Hello world!',
  style: TextStyles.ubuntu10w300l().copyWith(wordSpacing: 2),
),
```

```text
• c: — optional Color (overrides default palette color)
• h: — optional double height (line height adjustment)
• l: — optional double letter spacing
```

---

## 🔠 How font naming and suffixes work

The `textstyle_generator` parses font file names to automatically detect font weights and styles.

It expects your font files to follow this format:

```text
FamilyName-StyleName.ttf
```

For example:

```text
Ubuntu-Regular.ttf
Ubuntu-Bold.ttf
Ubuntu-Italic.ttf
Ubuntu-BoldItalic.ttf
Ubuntu-Light.ttf
Ubuntu-LightItalic.ttf
Ubuntu-Medium.ttf
Ubuntu-MediumItalic.ttf
```

### ✏️ Naming rules

```text
| Style keyword        | Weight | Suffix |
|:---------------------|:-------|:-------|
| Thin                 | 100    | t      |
| ThinItalic           | 100    | ti     |
| ExtraLight           | 200    | l      |
| ExtraLightItalic     | 200    | li     |
| Light                | 300    | l      |
| LightItalic          | 300    | li     |
| Regular              | 400    | (empty)|
| RegularItalic        | 400    | i      |
| Medium               | 500    | m      |
| MediumItalic         | 500    | mi     |
| SemiBold             | 600    | sb     |
| SemiBoldItalic       | 600    | sbi    |
| Bold                 | 700    | b      |
| BoldItalic           | 700    | bi     |
| ExtraBold            | 800    | eb     |
| ExtraBoldItalic      | 800    | ebi    |
| Black                | 900    | b      |
| BlackItalic          | 900    | bi     |
| Heavy                | 900    | h      |
| HeavyItalic          | 900    | hi     |
| Italic               | 400    | i      |
```

### 🧠 Method naming pattern:

```text
<baseName><fontSize>w<weight><suffix>()
```

Where:
- `baseName` — normalized font family name
- `fontSize` — font size
- `weight` — numeric weight (400, 500, etc.)
- `suffix` — style suffix (optional)

---

## 📋 Font file to generated method mapping

```text
| Font File                  | Example Size | Generated Method         | Meaning                               |
|:---------------------------|:-------------|:--------------------------|:--------------------------------------|
| Ubuntu-Regular.ttf         | 18           | ubuntu18w400()            | Regular font, weight 400              |
| Ubuntu-Italic.ttf          | 16           | ubuntu16w400i()           | Italic font, weight 400               |
| Ubuntu-Light.ttf           | 14           | ubuntu14w300l()           | Light font, weight 300                |
| Ubuntu-LightItalic.ttf     | 12           | ubuntu12w300li()          | Light + Italic font, weight 300       |
| Ubuntu-Medium.ttf          | 20           | ubuntu20w500m()           | Medium font, weight 500               |
| Ubuntu-MediumItalic.ttf    | 18           | ubuntu18w500mi()          | Medium + Italic font, weight 500      |
| Ubuntu-Bold.ttf            | 22           | ubuntu22w700b()           | Bold font, weight 700                 |
| Ubuntu-BoldItalic.ttf      | 24           | ubuntu24w700bi()          | Bold + Italic font, weight 700        |
| Ubuntu-ExtraBold.ttf       | 30           | ubuntu30w800eb()          | ExtraBold font, weight 800            |
| Ubuntu-Black.ttf           | 32           | ubuntu32w900b()           | Black font, weight 900                |
| Ubuntu-BlackItalic.ttf     | 28           | ubuntu28w900bi()          | Black + Italic font, weight 900       |
```

## ☕ Support

If you find this package useful, you can support the development by buying me a coffee!  
Your support helps keep this project active and maintained.

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/mobile_apps)