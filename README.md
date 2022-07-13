# Form Builder File Picker

[![Pub Version](https://img.shields.io/pub/v/form_builder_file_picker?logo=flutter&style=for-the-badge)](https://pub.dev/packages/form_builder_file_picker)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/flutter-form-builder-ecosystem/form_builder_file_picker/Base?logo=github&style=for-the-badge)](https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/actions/workflows/base.yaml)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/flutter-form-builder-ecosystem/form_builder_file_picker?logo=codefactor&style=for-the-badge)](https://www.codefactor.io/repository/github/flutter-form-builder-ecosystem/form_builder_file_picker)
[![Codecov](https://img.shields.io/codecov/c/github/flutter-form-builder-ecosystem/form_builder_file_picker?logo=codecov&style=for-the-badge)](https://codecov.io/gh/flutter-form-builder-ecosystem/form_builder_file_picker/)

File Picker Field for [flutter_form_builder](https://pub.dev/packages/flutter_form_builder) package

# Setup

Since this package makes use of [file_picker package](https://pub.dev/packages/file_picker), for platform specific setup, follow the instructions [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup)

# Usage

```dart
 import 'package:flutter_form_builder/flutter_form_builder.dart';
 import 'package:form_builder_file_picker/form_builder_file_picker.dart';

  FormBuilderFilePicker(
    name: "images",
    decoration: InputDecoration(labelText: "Attachments"),
    maxFiles: null,
    previewImages: true,
    onChanged: (val) => print(val),
    selector: Row(
      children: <Widget>[
        Icon(Icons.file_upload),
        Text('Upload'),
      ],
    ),
    onFileLoading: (val) {
      print(val);
    },
  ),
```

## Credits

<a href="https://github.com/flutter-form-builder-ecosystem/form_builder_file_picker/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutter-form-builder-ecosystem/form_builder_file_picker" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
