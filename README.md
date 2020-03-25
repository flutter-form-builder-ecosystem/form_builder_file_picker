# form_builder_file_picker

File Picker Field for [FlutterFormBuilder package](https://pub.dev/packages/flutter_form_builder)

# Setup

Since this package makes use of [file_picker package](https://pub.dev/packages/file_picker), for platform specific setup, follow the instructions [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup)

# Usage

```dart
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

FormBuilderFilePicker(
    attribute: "images",
    decoration: InputDecoration(labelText: "Attachments"),
    maxFiles: 5,
    multiple: true,
    previewImages: true,
    onChanged: (val) => print(val),
    fileType: FileType.any,
    selector: Row(
      children: <Widget>[
        Icon(Icons.file_upload),
        Text('Upload'),
      ],
    ),
),
```