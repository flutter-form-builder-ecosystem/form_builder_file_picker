# form_builder_file_picker

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

On mobile platforms the file picker will open a default document picker if used with FileType.any. 
If you want to be able to pick documents and images in the same form field you will need to define
different file types and thus different selectors. To achieve this use the typeSelectors parameter:
This way the user will see two buttons to open a file picker for documents and a file picker for the photos
gallery.

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