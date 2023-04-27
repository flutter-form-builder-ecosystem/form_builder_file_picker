# Form Builder File Picker

File Picker Field for [flutter_form_builder](https://pub.dev/packages/flutter_form_builder) package

[![Pub Version](https://img.shields.io/pub/v/form_builder_file_picker?logo=flutter&style=for-the-badge)](https://pub.dev/packages/form_builder_file_picker)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/flutter-form-builder-ecosystem/form_builder_file_picker/base.yaml?branch=main&logo=github&style=for-the-badge)](https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/actions/workflows/base.yaml)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/flutter-form-builder-ecosystem/form_builder_file_picker?logo=codefactor&style=for-the-badge)](https://www.codefactor.io/repository/github/flutter-form-builder-ecosystem/form_builder_file_picker)
[![Codecov](https://img.shields.io/codecov/c/github/flutter-form-builder-ecosystem/form_builder_file_picker?logo=codecov&style=for-the-badge)](https://codecov.io/gh/flutter-form-builder-ecosystem/form_builder_file_picker/)
___

- [Features](#features)
- [Use](#use)
  - [Setup](#setup)
  - [Basic use](#basic-use)
  - [Specific uses](#specific-uses)
- [Support](#support)
  - [Contribute](#contribute)
  - [Questions and answers](#questions-and-answers)
  - [Donations](#donations)
- [Roadmap](#roadmap)
- [Ecosystem](#ecosystem)
- [Thanks to](#thanks-to)
  - [Contributors](#contributors)

## Features

- Automatic handle permissions
- Show images preview

## Use

### Setup

Since this package makes use of [file_picker](https://pub.dev/packages/file_picker) package, for platform specific setup follow [this instructions](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup)

### Basic use

```dart
 import 'package:flutter_form_builder/flutter_form_builder.dart';
 import 'package:form_builder_file_picker/form_builder_file_picker.dart';

  FormBuilderFilePicker(
    name: "images",
    decoration: InputDecoration(labelText: "Attachments"),
    maxFiles: null,
    previewImages: true,
    onChanged: (val) => print(val),
    typeSelectors: [
      TypeSelector(
        type: FileType.any,
        selector: Row(
          children: <Widget>[
            Icon(Icons.add_circle),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Add documents"),
            ),
          ],
        ),
      ),
    ],
    onFileLoading: (val) {
      print(val);
    },
  ),
```

### Specific uses

On mobile platforms the file picker will open a default document picker if used with `FileType.any`.
If you want to be able to pick documents and images in the same form field, you will need to define different file types and different selectors. To achieve this use the `typeSelectors` parameter.
This way the user will see two buttons to open a file picker for documents and a file picker for the photos gallery.

For example:

```dart
FormBuilderFilePicker(
  name: "attachments",
  previewImages: false,
  allowMultiple: true,
  withData: true,
  typeSelectors: [
    TypeSelector(
      type: FileType.any,
      selector: Row(
        children: <Widget>[
          Icon(Icons.add_circle),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Add documents"),
          ),
        ],
      ),
    ),
    if (!kIsWeb)
      TypeSelector(
        type: FileType.image,
        selector: Row(
          children: <Widget>[
            Icon(Icons.add_photo_alternate),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Add images"),
            ),
          ],
        ),
      ),
    ],
  )
```

## Support

### Contribute

You have some ways to contribute to this packages

- Beginner: Reporting bugs or request new features
- Intermediate: Implement new features (from issues or not) and created pull requests
- Advanced: Join the [organization](#ecosystem) like a member and help coding, manage issues, dicuss new features and other things

 See [contribution guide](https://github.com/flutter-form-builder-ecosystem/.github/blob/main/CONTRIBUTING.md) for more details

### Questions and answers

You can question or search answers on [Github discussion](https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/discussions) or on [StackOverflow](https://stackoverflow.com/questions/tagged/flutter-form-builder)

### Donations

Donate or become a sponsor of Flutter Form Builder Ecosystem

[![Become a Sponsor](https://opencollective.com/flutter-form-builder-ecosystem/tiers/sponsor.svg?avatarHeight=56)](https://opencollective.com/flutter-form-builder-ecosystem)

## Roadmap

- [Add visual examples](https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/issues/37) (images, gifs, videos, sample application)
- [Solve open issues](https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/issues), [prioritizing bugs](https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/labels/bug)

## Ecosystem

Take a look to [our awesome ecosystem](https://github.com/flutter-form-builder-ecosystem) and all packages in there

## Thanks to

### Contributors

<a href="https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutter-form-builder-ecosystem/form_builder_file_picker" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
